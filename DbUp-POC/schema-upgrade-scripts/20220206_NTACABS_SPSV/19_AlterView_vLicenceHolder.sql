USE [cabs_production]
GO

/****** Object:  View [cabs_rta].[vLicenceHolder]    Script Date: 04.11.2022 15:27:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [cabs_rta].[vLicenceHolder]
AS
SELECT	vlhm1.LicenceHolderId,
		ISNULL(vlhm1.AddressLine1,'') + ' ' + ISNULL(vlhm1.AddressLine2,'') + ' ' + ISNULL(vlhm1.AddressLine3, '') AS Address,
		dllm.LicenceNumber AS DriverLicenceNo, 
		ISNULL(vlhm1.HolderName, '') AS DriverName,
		indus.ASPUserId,
		indus.ID AS IndustryUserID
FROM cabs_cmo.IndustryUser AS indus 
	INNER JOIN cabs_spsv.IndustryUserPerson AS iup on iup.IndustryUserId=indus.Id
	INNER JOIN person.Person AS p on iup.PersonId = p.PersonId
	INNER JOIN dbo.LicenceHolderMaster AS vlhm1 ON (vlhm1.Ccsn = p.CCSN)
	LEFT OUTER JOIN dl.LicenceHolderMaster AS dlhm2 ON (iup.PersonId = dlhm2.PersonId)
	LEFT OUTER JOIN dl.LicenceMaster AS dllm ON dllm.LicenceMasterId = dlhm2.LicenceMasterId
GO


