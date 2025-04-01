USE [cabs_production]
GO

/****** Object:  View [cabs_cmo].[vActiveVLLicence]    Script Date: 04.11.2022 15:11:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [cabs_cmo].[vActiveVLLicence]
AS
SELECT l.LicenceNumber, m.LicenceStateMaster, l.RegistrationNumber, lh.Ppsn, iu.ASPUserId
FROM dbo.LicenceMasterVL AS l
	INNER JOIN dbo.LicenceHolderMaster AS lh ON l.LicenceHolderId = lh.LicenceHolderId
	INNER JOIN dbo.LicenceStateMaster AS m ON l.LicenceStateMasterId = m.LicenceStateMasterId
	INNER JOIN person.Person AS p ON p.CCSN = lh.Ccsn
	INNER JOIN cabs_spsv.IndustryUserPerson AS iup ON iup.PersonId = p.PersonId
	INNER JOIN cabs_cmo.IndustryUser AS iu ON iu.ID = iup.IndustryUserId
WHERE 
	(l.LicenceStateMasterId = 4)

GO
