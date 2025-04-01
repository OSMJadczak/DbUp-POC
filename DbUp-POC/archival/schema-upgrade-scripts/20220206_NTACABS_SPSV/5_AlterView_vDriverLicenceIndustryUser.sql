USE [cabs_production]
GO

/****** Object:  View [cabs_spsv].[vDriverLicenceIndustryUser]    Script Date: 22.06.2022 09:15:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [cabs_spsv].[vDriverLicenceIndustryUser]
as

SELECT
	lh.PersonId AS PersonId,
	lm.LicenceNumber AS LicenceNumber,
	iu.ID AS IndustryUserId

FROM dl.LicenceHolderMaster lh
	JOIN dl.LicenceMaster lm ON lm.LicenceMasterId = lh.LicenceMasterId
	INNER JOIN cabs_spsv.IndustryUserPerson iup ON lh.PersonId = iup.PersonId
	INNER JOIN cabs_cmo.IndustryUser iu ON iu.ID = iup.IndustryUserId

GO
