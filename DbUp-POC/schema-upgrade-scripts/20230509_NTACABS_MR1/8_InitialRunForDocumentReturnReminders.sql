USE cabs_production;
/*
 * Initial run of expired licence document return reminder
 * BEFORE RUNNING MAKE SURE THAT LETTER REQUEST TYPE IDS FROM #letterstmp ARE INCLUDED IN dbo.USP_DWH_PrintRequestVL_Insert stored procedure. 
 * IF NOT, DESPATCH METHOD WON'T BE ASSIGNED IN STORED PROCEDURE
 * COMMIT AND ROLLBACK ARE COMMENTED
*/

DROP TABLE IF EXISTS #receiverstmp;
DROP TABLE IF EXISTS #letterstmp;

DECLARE @DateDiffNewest INT = 29;
DECLARE @DuplicateSafeguard INT = 14;
DECLARE @DateCutoff DATETIME = DATEFROMPARTS(2023,1,1);
DECLARE @InsertDate DATETIME = GETDATE();

DECLARE @InactiveState INT = 5;
DECLARE @ConditionalOffer INT = 10;
DECLARE @AllDocumentsReturned INT = 4;

DECLARE @PrintRequest INT;

SELECT LetterRequestTypeId, LetterCode
INTO #letterstmp
FROM dbo.LetterRequestTypeVL
WHERE LetterCode LIKE 'S17%';

/* 
* Gets users that do not have any booking in Awaiting Payment/Confirmed status
*/
WITH bookings AS(
SELECT DISTINCT(b.LicenceNumber)
FROM dbo.Booking b
JOIN dbo.Booking b2 ON b.BookingId=b2.BookingId
WHERE NOT EXISTS (SELECT 1 FROM dbo.Booking b2 WHERE b2.LicenceNumber=b.LicenceNumber AND b2.BookingStatusId IN (1,2))
UNION
SELECT DISTINCT(b.LicenceNumber)
FROM dbo.LicenceMasterVL lm
LEFT JOIN dbo.Booking b ON lm.LicenceNumber=b.LicenceNumber
WHERE b.LicenceNumber IS NULL),

/*
* Gets licences and basic holder data of licences that are in Inactive status that are not in Conditional Offer state (1),
* do not have any booking in Confirmed/completed status (2),
* expired 29 or 43 days ago and after agreed cut-off date (3), 
* do not have any stored document record or record does not indicate that everything has been returned (4)
*/
eligiblelicences AS(
SELECT lm.LicenceNumber,lm.LicenceHolderId,lm.RegistrationNumber,
    COALESCE(sd.StoredDocumentType, 1) AS 'StoredDocumentType',
    DATEDIFF(DAY, LicenceExpiryDate, GETDATE()) AS DaysSinceDeactivation
FROM dbo.LicenceMasterVL lm
	JOIN bookings b ON b.LicenceNumber=lm.LicenceNumber
	LEFT JOIN dbo.VehicleLicenceStoredDocument vlsd ON lm.LicenceNumber=vlsd.LicenceNumber
	LEFT JOIN dbo.StoredDocument sd ON vlsd.StoredDocumentId=sd.StoredDocumentId
	JOIN dbo.LicenceHolderMaster lhm ON lm.LicenceHolderId=lhm.LicenceHolderId
WHERE 1 = 1
	AND lm.LicenceStateMasterId = @InactiveState -- (1)
	AND lm.LicenceStateId != @ConditionalOffer -- (1)
	AND (b.LicenceNumber IS NOT NULL) -- (2)
	AND DATEDIFF(DAY, LicenceExpiryDate, GETDATE()) >= @DateDiffNewest -- (3)
	AND LicenceExpiryDate >= @DateCutoff -- (3)
	AND (sd.StoredDocumentId IS NULL OR sd.StoredDocumentType < @AllDocumentsReturned)), -- (4)

/*
* Exists for the purpose of getting the last sent notification date of a specific stored document type for a licence
*/
groupedreminders AS(SELECT LicenceNumber, StoredDocumentType, 
	MAX(FirstNotificationSendingDate) AS 'FirstNotificationSendingDate', 
	MAX(SecondNotificationSendingDate) AS 'SecondNotificationSendingDate'
FROM dbo.DocumentReturnReminderReceiver
GROUP BY LicenceNumber, StoredDocumentType)

/*
* Merges the licence and last sent notification data to ensure that no duplicated letters are sent. Output point for data in service
*/
SELECT
	uc.LicenceNumber,
	uc.LicenceHolderId,
	uc.RegistrationNumber,
	(SELECT LetterRequestTypeId FROM #letterstmp WHERE LetterCode=CONCAT('S17-D',uc.StoredDocumentType,'-S',CASE WHEN uc.DaysSinceDeactivation < 43 THEN 1 ELSE 2 END)) AS 'LetterRequestTypeId',
	uc.StoredDocumentType,
	uc.DaysSinceDeactivation
INTO #receiverstmp
FROM eligiblelicences uc
	LEFT JOIN groupedreminders gr ON gr.LicenceNumber=uc.LicenceNumber AND uc.StoredDocumentType=gr.StoredDocumentType
WHERE NOT(uc.StoredDocumentType=2 AND uc.DaysSinceDeactivation > 42) -- notifying of late return of VL Cert is handled by different process on NTA side (CMR123-86)
	AND ((gr.FirstNotificationSendingDate IS NULL AND DATEDIFF(DAY,gr.SecondNotificationSendingDate,GETDATE()) > uc.DaysSinceDeactivation) 
	OR (DATEDIFF(DAY,gr.FirstNotificationSendingDate,GETDATE())>=@DuplicateSafeguard AND gr.SecondNotificationSendingDate IS NULL)
	OR gr.StoredDocumentType IS NULL)
ORDER BY uc.LicenceNumber

IF ((SELECT COUNT(*) FROM #receiverstmp) = 0) 
	THROW 51000, 'No drivers requiring a reminder. No print requests have to be created.', 1;

/*
 * ADDING PRINT REQUEST AND RECORD IN DOCUMENT RECEIVERS TABLE
*/
BEGIN TRAN

DECLARE RECEIVER_CURSOR CURSOR STATIC FORWARD_ONLY READ_ONLY
FOR SELECT LicenceNumber, LicenceHolderId, RegistrationNumber, LetterRequestTypeId, StoredDocumentType FROM #receiverstmp

DECLARE @CursorLicence VARCHAR(10);
DECLARE @CursorHolderId INT;
DECLARE @CursorRegistration VARCHAR(20);
DECLARE @CursorLetterType INT;
DECLARE @CursorStoredDocument INT;

OPEN RECEIVER_CURSOR
FETCH NEXT FROM RECEIVER_CURSOR INTO @CursorLicence, @CursorHolderId, @CursorRegistration, @CursorLetterType, @CursorStoredDocument

WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC USP_DWH_PrintRequestVL_Insert
		@PrintRequestId = @PrintRequest,
		@LicenceNumber = @CursorLicence,
		@LicenceHolderId = @CursorHolderId,
		@VehicleRegistrationNumber = @CursorRegistration,
		@LetterRequestTypeId = @CursorLetterType,
		@PrintRequestReasonId = 1,
		@CreatedBy = 'Init'

	FETCH NEXT FROM RECEIVER_CURSOR INTO @CursorLicence, @CursorHolderId, @CursorRegistration, @CursorLetterType, @CursorStoredDocument
END

CLOSE RECEIVER_CURSOR
DEALLOCATE RECEIVER_CURSOR

INSERT INTO dbo.DocumentReturnReminderReceiver (LicenceNumber, StoredDocumentType, FirstNotificationSendingDate, SecondNotificationSendingDate)
SELECT LicenceNumber, StoredDocumentType, NULL, @InsertDate FROM #receiverstmp

/*
SELECT TOP 3 *
FROM dbo.PrintRequestDetailVL
ORDER BY CreatedDate DESC
SELECT TOP 3 *
FROM dbo.PrintRequestMasterVL
ORDER BY CreatedDate DESC

SELECT TOP 3 *
FROM dbo.DocumentReturnReminderReceiver
ORDER BY SecondNotificationSendingDate DESC
*/

--COMMIT TRAN
--ROLLBACK