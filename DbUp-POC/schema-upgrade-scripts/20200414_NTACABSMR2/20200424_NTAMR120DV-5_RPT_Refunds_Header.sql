USE [cabs_production]
GO
-- =============================================
-- Author:		---
-- Create date: ---
-- =============================================
ALTER PROCEDURE [dbo].[RPT_Refunds_Header]

@StartDate DateTime,
@EndDate DateTime

AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @Refunds TABLE
(
RefundId INT,
RefundAmount smallmoney,
PaidAmount smallmoney
)	

--Get all normal refunds for processes
INSERT INTO @Refunds
(
	RefundId,
	RefundAmount,
	PaidAmount
)	
SELECT RefundId, RefundAmount, PaidAmount FROM (
SELECT RefundId, RefundAmount, PaidAmount, BookingId, PaymentId
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
B.BookingId,
P.PaymentId
FROM  PaymentRefundVL  R
INNER JOIN dbo.BookingRefund BR ON BR.RefundId =R.RefundId
INNER JOIN dbo.Booking B ON B.BookingId=BR.BookingId
INNER JOIN dbo.PaymentVL P ON P.PaymentId = (SELECT MIN(PaymentId) FROM dbo.BookingPayment WHERE BookingId = B.BookingId)
LEFT OUTER JOIN dbo.SystemProcessVL SP ON SP.SystemProcessId = B.SystemProcessId
WHERE Cast(R.CreatedDate as DATE) BETWEEN @StartDate AND @EndDate
AND SP.SystemProcessId NOT IN (10,11)
) ds1

except

SELECT RefundId, RefundAmount, PaidAmount, BookingId, PaymentId
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
B.BookingId,
P.PaymentId
FROM  PaymentRefundVL  R
INNER JOIN dbo.BookingRefund BR ON BR.RefundId =R.RefundId
INNER JOIN dbo.Booking B ON B.BookingId=BR.BookingId
INNER JOIN dbo.PaymentVL P ON P.PaymentId = (SELECT MIN(PaymentId) FROM dbo.BookingPayment WHERE BookingId = B.BookingId)
LEFT OUTER JOIN dbo.SystemProcessVL SP ON SP.SystemProcessId = B.SystemProcessId
WHERE Cast(R.CreatedDate as DATE) BETWEEN @StartDate AND @EndDate
AND SP.SystemProcessId NOT IN (10,11)
) ds2
WHERE 1=1
	AND (ds2.Amount=0 AND ds2.RefundAmount<>0)
) ds

--Get all new licence 1s without a booking
INSERT INTO @Refunds
(
	RefundId,
	RefundAmount,
	PaidAmount
)	
SELECT DISTINCT
R.RefundId,
R.Amount AS RefundAmount,
P.Amount As PaidAmount
FROM dbo.LicenceMasterVL L
INNER JOIN dbo.PaymentRefundVL R ON L.LicenceNumber = R.LicenceNumber
INNER JOIN dbo.PaymentRefundItemVL RI ON RI.RefundId = R.RefundId --added
INNER JOIN dbo.PaymentItemVL [PI] ON [PI].PaymentItemId = RI.PaymentItemId --added
INNER JOIN dbo.PaymentVL P ON P.PaymentId = [PI].PaymentId --(SELECT MIN(PaymentId) FROM dbo.PaymentVL WHERE LicenceNumber = R.LicenceNumber)
INNER JOIN dbo.SystemProcessInstanceVL SP ON SP.PaymentId = P.PaymentId --added
WHERE Cast(R.CreatedDate as DATE) BETWEEN @StartDate AND @EndDate
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
	PaidAmount
)	
SELECT
R.RefundId,
--(	
--	SELECT COALESCE(SUM(Amount),0) FROM PaymentItemVL PIV
--	INNER JOIN dbo.PaymentRefundItemVL RI ON RI.PaymentItemId = PIV.PaymentItemId
--	WHERE PaymentId = dbo.GetFirstBookingPaymentId(B.BookingId)
--) AS RefundAmount, --if a payment is not found for a new licence 2 booking find the original payment for the licence
R.Amount AS RefundAmount,
P.Amount As PaidAmount
FROM PaymentRefundVL  R
INNER JOIN dbo.BookingRefund BR ON BR.RefundId =R.RefundId
INNER JOIN dbo.Booking B ON B.BookingId=BR.BookingId
INNER JOIN dbo.PaymentVL P ON P.PaymentId = dbo.GetFirstBookingPaymentId(B.BookingId)
LEFT OUTER JOIN dbo.SystemProcessVL SP ON SP.SystemProcessId = B.SystemProcessId
WHERE Cast(R.CreatedDate as DATE) BETWEEN @StartDate AND @EndDate
AND SP.SystemProcessId IN (11)
AND B.BookingId IS NOT NULL

SELECT	RefundId,
		RefundAmount,
		PaidAmount
		
FROM @Refunds

END