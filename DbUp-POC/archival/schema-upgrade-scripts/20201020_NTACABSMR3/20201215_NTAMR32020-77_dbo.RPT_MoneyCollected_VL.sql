USE [cabs_production]
GO
CREATE OR ALTER PROCEDURE dbo.RPT_MoneyCollected_VL
(
@StartDate datetime = NULL,
@EndDate datetime = NULL
) as 
begin

SET NOCOUNT ON;

declare @SP_StartDate date = convert(date, @StartDate)
declare @SP_EndDate date = convert(date, @EndDate)

SELECT 
	PaymentId,
	Amount,
	CreatedDate,
	LicenceNumber,
	PaymentMethodName,
	PaymentReference,
	Comment,
	ServiceTypeName,
	CreatedBy,
	BookingId,
	InspectionType,
	COALESCE(SystemProcessName, ServiceTypeName) AS ProcessName,
	Category, 
	LicencePeriod
FROM (
	SELECT	DISTINCT 
		PVL.PaymentId, 
		PVL.Amount,
		PVL.CreatedDate,
		PVL.LicenceNumber,
		case PVL.[PaymentMethodId]
			WHEN 1 THEN 'Credit/Debit Card'
			WHEN 2 THEN 'Cheque'
			WHEN 3 THEN 'Waivered – SGS'
			WHEN 4 THEN 'Waivered – NTA'
			WHEN 5 THEN 'Bank draft/PO'
			WHEN 6 THEN 'Waivered – Applus'
			WHEN 7 THEN 'Waivered – Abtran'
			WHEN 8 THEN 'No Fee'
			ELSE PM.PaymentMethodName
		END AS PaymentMethodName,
		case PVL.ServiceTypeId
			WHEN 1  THEN 'VL Booking'
			WHEN 2 THEN 'Duplicate Licence'
			WHEN 3 THEN 'Duplicate Licence With TP'
			WHEN 4 THEN 'Change Of Name With Duplicate Licence'
			WHEN 5 THEN 'Transfer Licence'
			WHEN 6 THEN 'Transfer Package'
			WHEN 7 THEN 'New Licence'
			ELSE ''
		END AS ServiceTypeName,
		PVL.PaymentReference,
		PVL.Comment,		
		PVL.CreatedBy,
		B.BookingId,
		ITY.Description As InspectionType, 
		spvl.ProcessName 'SystemProcessName',
		LT.LicenceType AS Category,
		case WHEN F.FeeName like '%1 year%' then '1 year' when F.FeeName like '%6 months%' then '6 months' else '' end as LicencePeriod
FROM dbo.PaymentVL PVL with (nolock)
LEFT JOIN dbo.PaymentItemVL PIVL with (nolock) ON PVL.PaymentId = PIVL.PaymentId and FeeId in (select FeeId from dbo.Fee F with (nolock) where (F.FeeName like '%1 year%' or F.FeeName like '%6 months%') and F.FeeName not like 'Expired%')
LEFT JOIN dbo.Fee F with (nolock) on PIVL.FeeId = F.FeeId 
INNER JOIN dbo.PaymentMethod PM with (nolock) ON PM.PaymentMethodId = PVL.PaymentMethodId
LEFT JOIN dbo.LicenceMasterVL LMVL with (nolock) ON LMVL.LicenceNumber = PVL.LicenceNumber
LEFT JOIN dbo.LicenceType LT with (nolock) ON LMVL.LicenceTypeId = LT.LicenceTypeId
INNER JOIN dbo.ServiceTypeVL ST with (nolock) ON ST.ServiceTypeId = PVL.ServiceTypeId
LEFT JOIN dbo.BookingPayment BP with (nolock) ON BP.PaymentId = PVL.PaymentId
LEFT JOIN dbo.Booking B with (nolock) ON B.BookingId = BP.BookingId
	left join SystemProcessVL spvl with (nolock) ON spvl.SystemProcessId=B.SystemProcessId
LEFT JOIN dbo.InspectionTime IT with (nolock) ON IT.InspectionTimeId = B.InspectionTimeId
LEFT JOIN dbo.InspectionType ITY with (nolock) ON ITY.InspectionTypeId = IT.InspectionTypeId
left join dbo.SystemProcessInstanceVL SPIVL with (nolock) on SPIVL.PaymentId = PVL.PaymentId and SPIVL.Completed = 1

WHERE 
Cast(PVL.CreatedDate as DATE)  BETWEEN @SP_StartDate AND @SP_EndDate
AND SPIVL.Completed = 1
and (SPIVL.SystemProcessId is not null or PVL.CreatedDate < (
					select CONVERT(DateTime, ParameterValue) from dbo.SystemParameter WHERE ParameterName = 'CABS_Launch_Date')) 
) a

END