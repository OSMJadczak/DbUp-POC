USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[GetExpireDeadTimeOutLicences]    Script Date: 6/16/2021 1:45:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[GetExpireDeadTimeOutLicences]

AS
BEGIN
	declare @ModifiedDate datetime
	SET @ModifiedDate = DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)
	DECLARE @LicenceRenewalPeriod int = (
    SELECT TOP 1 ParameterValue FROM SystemParameter where ParameterName = 'LicenceRenewalPeriod')

	SELECT	*
		FROM dbo.LicenceMasterVL L
		INNER JOIN dbo.LicenceHolderMaster H ON H.LicenceHolderId = L.LicenceHolderId
		INNER JOIN dbo.VehicleMaster V ON V.RegistrationNumber = L.RegistrationNumber
		INNER JOIN dbo.LicenceType T on L.LicenceTypeId = T.LicenceTypeId
		WHERE L.LicenceStateMasterId = 5
		AND L.LicenceStateId = 8	
		AND ( 
			(L.LicenceExpiryDate>=CONVERT(datetime,'1-31-2013') and DATEADD(year, @LicenceRenewalPeriod,L.LicenceExpiryDate) < @modifiedDate) --rule 1
			OR
			(L.LicenceExpiryDate<CONVERT(datetime,'1-31-2013') and L.LicenceExpiryDate>=CONVERT(datetime,'12-31-2008') and @modifiedDate>CONVERT(datetime,'01/31/2014')) --rule 2
			OR
			(L.LicenceExpiryDate<CONVERT(datetime,'12-31-2008') and DATEADD(year,5,L.LicenceExpiryDate) < @modifiedDate ) --rule 3
			)
		
END
GO


