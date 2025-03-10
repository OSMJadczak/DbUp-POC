USE [cabs_production]
GO
-- =============================================
-- Author:		Andrew Snook
-- Create date: 12-Apr-2011
-- =============================================
ALTER PROCEDURE [dbo].[RPT_Refunds]

@StartDate DateTime,
@EndDate DateTime

AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @Refunds TABLE
(
RefundId INT,
RefundAmount smallmoney,
PaidAmount smallmoney,
LicenceNumber nvarchar(50), 
ReasonName nvarchar(100),
CreatedDate datetime,
CreatedBy nvarchar(50),
Comments nvarchar(500),
BookingCancellationReason nvarchar(100),
BookingId INT,
PaymentId INT,
PaymentMethodName nvarchar(100),
PaymentReference nvarchar(100),
BookingDateTime datetime,
RegistrationNumber nvarchar(50),
ProcessName nvarchar(100),
InspectionType nvarchar(100),
ServiceTypeName nvarchar(100)
)	

--Get all normal refunds for processes
INSERT INTO @Refunds
(
	RefundId,
	RefundAmount,
	PaidAmount,
	LicenceNumber, 
	ReasonName,
	CreatedDate,
	CreatedBy,
	Comments,
	BookingCancellationReason,
	BookingId,
	PaymentId,
	PaymentMethodName,
	PaymentReference,
	BookingDateTime,
	RegistrationNumber,
	ProcessName,
	InspectionType,
	ServiceTypeName
)	

SELECT 
	RefundId, 
	RefundAmount, 
	PaidAmount, 
	LicenceNumber, 
	ReasonName,
	CreatedDate,
	CreatedBy,
	Comments,
	BookingCancellationReason,
	BookingId,
	PaymentId,
	PaymentMethodName,
	PaymentReference,
	BookingDateTime,
	RegistrationNumber,
	ProcessName,
	InspectionType,
	ServiceTypeName
FROM (
	SELECT
		R.RefundId,
		R.Amount,
		(	
			SELECT COALESCE(SUM(Amount),0) FROM PaymentItemVL PIV
			INNER JOIN dbo.PaymentRefundItemVL RI ON RI.PaymentItemId = PIV.PaymentItemId
			WHERE PaymentId = (SELECT MIN(PaymentId) FROM dbo.BookingPayment WHERE BookingId = B.BookingId)
		) AS RefundAmount,
		P.Amount As PaidAmount,
		R.LicenceNumber, 
		BRR.ReasonName,
		R.CreatedDate,
		R.CreatedBy,
		R.Comments,
		CR.BookingCancellationReason,
		B.BookingId,
		P.PaymentId,
		PM.PaymentMethodName,
		P.PaymentReference,
		B.BookingDateTime,
		B.RegistrationNumber,
		ProcessName =  (Select ProcessName from SystemProcessVL Where SystemProcessId=B.SystemProcessId),
		T.Description AS InspectionType,
		case P.ServiceTypeId
					WHEN 1  THEN 'VL Booking'
					WHEN 2 THEN 'Duplicate Licence'
					WHEN 3 THEN 'Duplicate Licence With TP'
					WHEN 4 THEN 'Change Of Name With Duplicate Licence'
					WHEN 5 THEN 'Transfer Licence'
					WHEN 6 THEN 'Transfer Package'
					WHEN 7 THEN 'New Licence'
				ELSE ''
		END AS ServiceTypeName
	FROM   PaymentRefundVL  R
		INNER JOIN dbo.BookingRefund BR ON BR.RefundId =R.RefundId
		INNER JOIN dbo.Booking B ON B.BookingId=BR.BookingId
		INNER JOIN dbo.PaymentVL P ON P.PaymentId = (SELECT MIN(PaymentId) FROM dbo.BookingPayment WHERE BookingId = B.BookingId)
		INNER JOIN dbo.PaymentMethod PM ON PM.PaymentMethodId = P.PaymentMethodId
		LEFT OUTER JOIN dbo.PaymentItemVLRefundReason RR ON RR.RefundReasonId = R.RefundReasonId
		LEFT OUTER JOIN dbo.BookingCancellationReason CR ON CR.BookingCancellationReasonId = R.BookingCancellationId
		LEFT OUTER JOIN dbo.PaymentItemVLRefundReason BRR ON BRR.RefundReasonId = BR.RefundReasonId
		LEFT OUTER JOIN dbo.InspectionTime IT ON IT.InspectionTimeId = B.InspectionTimeId
		LEFT OUTER JOIN dbo.InspectionType T ON T.InspectionTypeId = IT.InspectionTypeId
	WHERE 
		Cast(R.CreatedDate as DATE)  BETWEEN @StartDate AND @EndDate
		AND B.SystemProcessId NOT IN (10,11)
) ds1
--order by 1
except
SELECT 
	RefundId, 
	RefundAmount, 
	PaidAmount, 
	LicenceNumber, 
	ReasonName,
	CreatedDate,
	CreatedBy,
	Comments,
	BookingCancellationReason,
	BookingId,
	PaymentId,
	PaymentMethodName,
	PaymentReference,
	BookingDateTime,
	RegistrationNumber,
	ProcessName,
	InspectionType,
	ServiceTypeName
FROM (
	SELECT
		R.RefundId,
		R.Amount,
		(	
			SELECT COALESCE(SUM(Amount),0) FROM PaymentItemVL PIV
			INNER JOIN dbo.PaymentRefundItemVL RI ON RI.PaymentItemId = PIV.PaymentItemId
			WHERE PaymentId = (SELECT MIN(PaymentId) FROM dbo.BookingPayment WHERE BookingId = B.BookingId)
		) AS RefundAmount,
		P.Amount As PaidAmount,
		R.LicenceNumber, 
		BRR.ReasonName,
		R.CreatedDate,
		R.CreatedBy,
		R.Comments,
		CR.BookingCancellationReason,
		B.BookingId,
		P.PaymentId,
		PM.PaymentMethodName,
		P.PaymentReference,
		B.BookingDateTime,
		B.RegistrationNumber,
		ProcessName =  (Select ProcessName from SystemProcessVL Where SystemProcessId=B.SystemProcessId),
		T.Description AS InspectionType,
		case P.ServiceTypeId
					WHEN 1  THEN 'VL Booking'
					WHEN 2 THEN 'Duplicate Licence'
					WHEN 3 THEN 'Duplicate Licence With TP'
					WHEN 4 THEN 'Change Of Name With Duplicate Licence'
					WHEN 5 THEN 'Transfer Licence'
					WHEN 6 THEN 'Transfer Package'
					WHEN 7 THEN 'New Licence'
				ELSE ''
	END AS ServiceTypeName
	FROM   PaymentRefundVL  R
		INNER JOIN dbo.BookingRefund BR ON BR.RefundId =R.RefundId
		INNER JOIN dbo.Booking B ON B.BookingId=BR.BookingId
		INNER JOIN dbo.PaymentVL P ON P.PaymentId = (SELECT MIN(PaymentId) FROM dbo.BookingPayment WHERE BookingId = B.BookingId)
		INNER JOIN dbo.PaymentMethod PM ON PM.PaymentMethodId = P.PaymentMethodId
		LEFT OUTER JOIN dbo.PaymentItemVLRefundReason RR ON RR.RefundReasonId = R.RefundReasonId
		LEFT OUTER JOIN dbo.BookingCancellationReason CR ON CR.BookingCancellationReasonId = R.BookingCancellationId
		LEFT OUTER JOIN dbo.PaymentItemVLRefundReason BRR ON BRR.RefundReasonId = BR.RefundReasonId
		LEFT OUTER JOIN dbo.InspectionTime IT ON IT.InspectionTimeId = B.InspectionTimeId
		LEFT OUTER JOIN dbo.InspectionType T ON T.InspectionTypeId = IT.InspectionTypeId
	WHERE 
		Cast(R.CreatedDate as DATE)  BETWEEN @StartDate AND @EndDate
		AND B.SystemProcessId NOT IN (10,11)
) ds2
WHERE 1=1
	AND (ds2.Amount=0 AND ds2.RefundAmount<>0)

--Get all new licence 1s without a booking
INSERT INTO @Refunds
(
	RefundId,
	RefundAmount,
	PaidAmount,
	LicenceNumber, 
	ReasonName,
	CreatedDate,
	CreatedBy,
	Comments,
	BookingCancellationReason,
	BookingId,
	PaymentId,
	PaymentMethodName,
	PaymentReference,
	BookingDateTime,
	RegistrationNumber,
	ProcessName,
	InspectionType,
	ServiceTypeName
)	
SELECT distinct
R.RefundId,
R.Amount AS RefundAmount,
P.Amount As PaidAmount,
R.LicenceNumber, 
RR.ReasonName,
R.CreatedDate,
R.CreatedBy,
R.Comments,
CR.BookingCancellationReason,
null as BookingId,
P.PaymentId,
PM.PaymentMethodName,
P.PaymentReference,
null as BookingDateTime,
L.RegistrationNumber,
'New Licence 1' AS ProcessName,
null AS InspectionType,
case P.ServiceTypeId
			WHEN 1  THEN 'VL Booking'
			WHEN 2 THEN 'Duplicate Licence'
			WHEN 3 THEN 'Duplicate Licence With TP'
			WHEN 4 THEN 'Change Of Name With Duplicate Licence'
			WHEN 5 THEN 'Transfer Licence'
			WHEN 6 THEN 'Transfer Package'
			WHEN 7 THEN 'New Licence'
		ELSE ''
		END AS ServiceTypeName

FROM dbo.LicenceMasterVL L
INNER JOIN dbo.PaymentRefundVL R ON L.LicenceNumber = R.LicenceNumber
INNER JOIN dbo.PaymentRefundItemVL RI ON RI.RefundId = R.RefundId --added
INNER JOIN dbo.PaymentItemVL [PI] ON [PI].PaymentItemId = RI.PaymentItemId --added
INNER JOIN dbo.PaymentVL P ON P.PaymentId = [PI].PaymentId --(SELECT MIN(PaymentId) FROM dbo.PaymentVL WHERE LicenceNumber = R.LicenceNumber)
INNER JOIN dbo.PaymentMethod PM ON PM.PaymentMethodId = (P.PaymentMethodId)
LEFT OUTER JOIN dbo.PaymentItemVLRefundReason RR ON RR.RefundReasonId = R.RefundReasonId
LEFT OUTER JOIN dbo.BookingCancellationReason CR ON CR.BookingCancellationReasonId = R.BookingCancellationId
INNER JOIN  dbo.SystemProcessInstanceVL SP ON SP.PaymentId = P.PaymentId
WHERE Cast(R.CreatedDate as DATE)  BETWEEN @StartDate AND @EndDate
AND SP.SystemProcessId = 10
AND R.RefundID NOT IN (Select RefundId from dbo.BookingRefund)
--AND L.LicenceNumber NOT IN
--(
--	SELECT LicenceNumber FROM Booking
--)



--Get all new licence 2 refunds where a booking exists
INSERT INTO @Refunds
(
	RefundId,
	RefundAmount,
	PaidAmount,
	LicenceNumber, 
	ReasonName,
	CreatedDate,
	CreatedBy,
	Comments,
	BookingCancellationReason,
	BookingId,
	PaymentId,
	PaymentMethodName,
	PaymentReference,
	BookingDateTime,
	RegistrationNumber,
	ProcessName,
	InspectionType,
	ServiceTypeName
)	
SELECT
R.RefundId,
--(	
--	SELECT COALESCE(SUM(Amount),0) FROM PaymentItemVL PIV
--	INNER JOIN dbo.PaymentRefundItemVL RI ON RI.PaymentItemId = PIV.PaymentItemId
--	WHERE PaymentId = dbo.GetFirstBookingPaymentId(B.BookingId)
--) AS RefundAmount, --if a payment is not found for a new licence 2 booking find the original payment for the licence
R.Amount AS RefundAmount,
P.Amount As PaidAmount,
R.LicenceNumber, 
BRR.ReasonName,
R.CreatedDate,
R.CreatedBy,
R.Comments,
CR.BookingCancellationReason,
B.BookingId,
P.PaymentId,
PM.PaymentMethodName,
P.PaymentReference,
B.BookingDateTime,
B.RegistrationNumber,
ProcessName =  (Select ProcessName from SystemProcessVL Where SystemProcessId=B.SystemProcessId),
T.Description AS InspectionType,
case P.ServiceTypeId
			WHEN 1  THEN 'VL Booking'
			WHEN 2 THEN 'Duplicate Licence'
			WHEN 3 THEN 'Duplicate Licence With TP'
			WHEN 4 THEN 'Change Of Name With Duplicate Licence'
			WHEN 5 THEN 'Transfer Licence'
			WHEN 6 THEN 'Transfer Package'
			WHEN 7 THEN 'New Licence'
		ELSE ''
		END AS ServiceTypeName

FROM PaymentRefundVL  R
INNER JOIN dbo.BookingRefund BR ON BR.RefundId =R.RefundId
INNER JOIN dbo.Booking B ON B.BookingId=BR.BookingId
INNER JOIN dbo.PaymentVL P ON P.PaymentId = dbo.GetFirstBookingPaymentId(B.BookingId)
INNER JOIN dbo.PaymentMethod PM ON PM.PaymentMethodId = (P.PaymentMethodId)
LEFT OUTER JOIN dbo.PaymentItemVLRefundReason RR ON RR.RefundReasonId = R.RefundReasonId
LEFT OUTER JOIN dbo.BookingCancellationReason CR ON CR.BookingCancellationReasonId = R.BookingCancellationId
LEFT OUTER JOIN dbo.PaymentItemVLRefundReason BRR ON BRR.RefundReasonId = BR.RefundReasonId
LEFT OUTER JOIN dbo.InspectionTime IT ON IT.InspectionTimeId = B.InspectionTimeId
LEFT OUTER JOIN dbo.InspectionType T ON T.InspectionTypeId = IT.InspectionTypeId
WHERE Cast(R.CreatedDate as DATE)  BETWEEN @StartDate AND @EndDate
AND B.SystemProcessId IN (11)
AND B.BookingId IS NOT NULL


--Get all skillsrefunds where a booking exists
INSERT INTO @Refunds
(
	RefundId,
	RefundAmount,
	PaidAmount,
	LicenceNumber, 
	ReasonName,
	CreatedDate,
	CreatedBy,
	Comments,
	BookingCancellationReason,
	BookingId,
	PaymentId,
	PaymentMethodName,
	PaymentReference,
	BookingDateTime,
	RegistrationNumber,
	ProcessName,
	InspectionType,
	ServiceTypeName
)
SELECT
R.RefundId,
(	
	SELECT COALESCE(SUM(Amount),0) FROM PaymentItemVL PIV
	INNER JOIN dbo.PaymentRefundItemVL RI ON RI.PaymentItemId = PIV.PaymentItemId
	INNER JOIN [cabs_sk].[BookingRefund] BR ON BR.RefundId =RI.RefundId
	WHERE PaymentId = dbo.GetFirstSkillsBookingPaymentId(B.ID)
) AS RefundAmount,
P.Amount As PaidAmount,
pe.PPSN AS LicenceNumber, 
BRR.ReasonName,
R.CreatedDate,
R.CreatedBy,
R.Comments,
CR.BookingCancellationReason,
B.ID as BookingId,
P.PaymentId,
PM.PaymentMethodName,
P.PaymentReference,
B.EndDateTime as BookingDateTime,
'' as RegistrationNumber,
test.Name AS ProcessName,
'Skills Test' AS InspectionType,
'Skills Booking' as ServiceTypeName 
FROM  PaymentRefundVL  R
INNER JOIN [cabs_sk].[BookingRefund] BR ON BR.RefundId =R.RefundId
INNER JOIN cabs_sk.Booking B ON B.ID=BR.BookingId
INNER JOIN [cabs_sk].[BookingPayment] BP ON B.ID = BP.BookingID
INNER JOIN  [cabs_sk].[Candidate]  ca ON B.CandidateID=ca.ID 
INNER JOIN  [cabs_cmo].[Person] pe ON   ca.PersonID=pe.ID 
INNER JOIN dbo.PaymentVL P ON P.PaymentId = BP.PaymentID AND P.PaymentId=dbo.GetFirstSkillsBookingPaymentId(B.ID)
INNER JOIN dbo.PaymentMethod PM ON PM.PaymentMethodId = (P.PaymentMethodId)
INNER JOIN  cabs_sk.Test test ON B.TestID = test.ID
LEFT OUTER JOIN dbo.PaymentItemVLRefundReason RR ON RR.RefundReasonId = R.RefundReasonId
LEFT OUTER JOIN dbo.BookingCancellationReason CR ON CR.BookingCancellationReasonId = R.BookingCancellationId
LEFT OUTER JOIN dbo.PaymentItemVLRefundReason BRR ON BRR.RefundReasonId = BR.RefundReasonId
WHERE Cast(R.CreatedDate as DATE)  BETWEEN @StartDate AND @EndDate
AND B.ID IS NOT NULL


SELECT	RefundId,
		RefundAmount,
		PaidAmount,
		LicenceNumber, 
		ReasonName,
		CreatedDate,
		CreatedBy,
		Comments,
		BookingCancellationReason,
		BookingId,
		PaymentId,
		PaymentMethodName,
		PaymentReference,
		BookingDateTime,
		RegistrationNumber,
		ProcessName,
		InspectionType,
		ServiceTypeName
		
FROM @Refunds

END