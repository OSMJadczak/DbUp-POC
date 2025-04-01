USE [cabs_production]
GO

/****** Object:  StoredProcedure [cabs_sk].[SkillsRemoveCandidateData]    Script Date: 5/14/2020 2:04:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Stored Procedure

-- =============================================
-- Author:		<Author, Radoslaw Podgorski>
-- Create date: <Create Date, 03-May-2014>
-- Description:	<Removes all Bookings,Payments,Tests, Restresults, Questions and Candidate Data from Skills(Can be chosen by parameter) >
-- =============================================
ALTER PROCEDURE [cabs_sk].[SkillsRemoveCandidateData]
(
@PPSN VARCHAR(20),
@KeepLegacyTests bit,
@DeleteCandidate bit
)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

----------------------------------- SET VARIABLES ---------------------------

DECLARE @CandidateId INT
DECLARE @T_BookingsOfCandidate TABLE(BookingID INT)

SET @CandidateId = (SELECT TOP 1 CandidateID
			   FROM [cabs_sk].[Booking] BK
			   JOIN [cabs_sk].[Candidate] C ON C.ID = BK.CandidateID
			   JOIN [cabs_cmo].[Person] P ON P.ID = C.PersonID
			   WHERE P.PPSN = @PPSN)


IF (@KeepLegacyTests = 0)
	BEGIN
		INSERT INTO @T_BookingsOfCandidate 
		SELECT BK.ID 
		FROM [cabs_sk].[Booking] BK
		JOIN [cabs_sk].[Candidate] C ON C.ID = BK.CandidateID
		JOIN [cabs_cmo].[Person] P ON P.ID = C.PersonID
		WHERE P.PPSN = @PPSN
	END
ELSE
	BEGIN
		INSERT INTO @T_BookingsOfCandidate 
		SELECT BK.ID 
		FROM [cabs_sk].[Booking] BK
		JOIN [cabs_sk].[Candidate] C ON C.ID = BK.CandidateID
		JOIN [cabs_cmo].[Person] P ON P.ID = C.PersonID
		WHERE CONFIRMATIONNUMBER IS NULL AND P.PPSN = @PPSN
	END

----------------------------------- MAIN ---------------------------


-- 1. DELETE FROM PAYMENTREFUND

DELETE PRIV FROM [dbo].[PaymentRefundItemVL] PRIV
JOIN [cabs_sk].[BookingRefund] BR ON BR.REFUNDID = PRIV.RefundId
WHERE BR.BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

DELETE BR FROM [cabs_sk].[BookingRefund] BR
WHERE BR.BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

DELETE PRV FROM [dbo].[PaymentRefundVL] PRV
JOIN [cabs_sk].[BookingRefund] BR ON BR.REFUNDID = PRV.RefundId
WHERE BR.BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

PRINT N'REMOVED PAYMENT REFUNDS RELATED WITH USER SKILLS BOOKINGS'


-- 2. DELETE FROM PAYMENTITEM AND PAYMENTITEMAUDIT

DELETE PIVA FROM [dbo].[PaymentItemVLAudit] PIVA
JOIN [cabs_sk].[BookingPayment] BP ON BP.PAYMENTID = PIVA.PAYMENTID
WHERE BP.BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

DELETE PIV FROM [dbo].[PaymentItemVL] PIV
JOIN [cabs_sk].[BookingPayment] BP ON BP.PAYMENTID = PIV.PAYMENTID
WHERE BP.BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

DELETE FROM [cabs_sk].[BookingPayment] 
WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

PRINT N'REMOVED PAYMENTS RELATED WITH USER SKILLS BOOKINGS'


-- 3. DELETE LETTERS

DELETE FROM [dbo].[PrintRequestMasterVLDownload] 
WHERE PRINTREQUESTMASTERID IN (SELECT PRINTREQUESTMASTERID 
						       FROM [dbo].[PrintRequestMasterVL] 
						       WHERE SKBOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate))

DELETE FROM [dbo].[PrintRequestDetailVLQueueItem] 
WHERE PRINTREQUESTID IN (SELECT PRINTREQUESTID 
FROM [dbo].[PrintRequestDetailVL]
WHERE PRINTREQUESTMASTERID IN (SELECT PRINTREQUESTMASTERID
							   FROM [dbo].[PrintRequestMasterVL] 
							   WHERE SKBOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)))

DELETE FROM [dbo].[PrintRequestDetailVL]  
WHERE PRINTREQUESTMASTERID IN (SELECT PRINTREQUESTMASTERID 
							   FROM [dbo].[PrintRequestMasterVL] 
							   WHERE SKBOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate))


DELETE FROM [dbo].[PrintRequestMasterVL] WHERE SKBOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

PRINT N'REMOVED LETTERS RELATED WITH USER SKILLS BOOKINGS'


-- 4. DELETE FROM [CandidateTestNote]

DELETE FROM [cabs_sk].[CandidateTestNote] 
WHERE CANDIDATETESTID IN (SELECT ID 
						  FROM [cabs_sk].[CandidateTest] 
						  WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate))

PRINT N'REMOVED BOOKING NOTES'

-- 5. DELETE FROM [CandidateTestPauseTime]

DELETE FROM [cabs_sk].[CandidateTestPauseTime] 
WHERE CANDIDATETESTID IN (SELECT ID 
						  FROM [cabs_sk].[CandidateTest] 
						  WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate))

PRINT N'REMOVED TESTS PAUSED TIMES'

-- 6. DELETE FROM [CandidateTestQuestionAnswer]

DELETE FROM [cabs_sk].[CandidateTestQuestionAnswer]
WHERE CandidateTestQuestionID IN ( SELECT ID
								   FROM [cabs_sk].[CandidateTestQuestion]
	                               WHERE CANDIDATETESTMODULEID IN (SELECT ID 
																   FROM [cabs_sk].[CandidateTestModule]
																   WHERE CANDIDATETESTID IN (SELECT ID 
																			    		     FROM [cabs_sk].[CandidateTest] 
																			    		     WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate))))
PRINT N'REMOVED USERS TESTS ANSWERS'

-- 7. DELETE FROM [CandidateTestQuestion]

DELETE FROM [cabs_sk].[CandidateTestQuestion] 
WHERE CANDIDATETESTMODULEID IN ( SELECT ID 
								 FROM [cabs_sk].[CandidateTestModule]
								 WHERE CANDIDATETESTID IN (SELECT ID 
														FROM [cabs_sk].[CandidateTest] 
														WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)))
PRINT N'REMOVED USERS TESTS QUESTIONS'

-- 8. DELETE FROM [CandidateTestModule]

DELETE FROM [cabs_sk].[CandidateTestModule] 
WHERE CANDIDATETESTID IN (SELECT ID 
						  FROM [cabs_sk].[CandidateTest] 
						  WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate))

PRINT N'REMOVED USERS TESTS MODULES'

-- 9. DELETE FROM [CandidateTest]

DELETE FROM [cabs_sk].[CandidateTest] 
WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

PRINT N'REMOVED USERS TESTS'

-- 10. DELETE FROM [CandidateHistoryImage]

DELETE FROM [cabs_sk].CandidateHistoryImage 
WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

PRINT N'REMOVED USERS HISTORY IMAGE'

-- 11. DELETE FROM BOOKINGAUDIT

DELETE FROM [cabs_sk].[BookingAudit]
WHERE BOOKINGID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

-- 12. DELETE FROM BOOKING

DELETE FROM [cabs_sk].[Booking] WHERE ID IN (SELECT BookingID FROM @T_BookingsOfCandidate)

PRINT N'REMOVED USERS BOOKINGS'


IF (@DeleteCandidate = 1)
	BEGIN

	-- 13. DELETE FROM [Candidate]

	DELETE FROM [cabs_sk].[Candidate] WHERE ID = @CandidateId
	PRINT N'REMOVED CANDIDATE RECORD'

	DECLARE @PhotoID INT
	SET @PhotoID = (SELECT PHOTOID FROM [cabs_cmo].[Person] WHERE PPSN = @PPSN)

	DECLARE @SignatureID INT
	SET @SignatureID = (SELECT SIGNATUREID FROM [cabs_cmo].[Person] WHERE PPSN = @PPSN)

	-- 14. DELETE FROM [Person]
	DELETE FROM [cabs_cmo].[PersonAudit] WHERE PERSONID = (SELECT ID FROM [cabs_cmo].[Person] WHERE PPSN = @PPSN)
	DELETE FROM [cabs_cmo].[Person] WHERE PPSN = @PPSN
	PRINT N'REMOVED USER'

	-- 15. DELETE FROM [Image]
    -- PHOTO
	DELETE FROM [cabs_sk].[Image] WHERE ID = @PhotoID
	PRINT N'REMOVED USERS PHOTO'
	-- SIGNATURE
	DELETE FROM [cabs_sk].[Image] WHERE ID IN (SELECT SIGNATUREID FROM [cabs_cmo].[Person] WHERE PPSN = @PPSN)
	PRINT N'REMOVED USERS SIGNATURE'

END

END

GO


