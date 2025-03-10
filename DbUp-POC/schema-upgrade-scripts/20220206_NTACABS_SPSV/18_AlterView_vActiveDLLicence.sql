USE [cabs_production]
GO

/****** Object:  View [cabs_cmo].[vActiveDLLicence]    Script Date: 04.11.2022 15:17:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [cabs_cmo].[vActiveDLLicence] as 
select 
	p.FirstName, 
	p.LastName AS Surname, 
	p.AddressLine1, 
	p.AddressLine2, 
	p.Town, 
	p.CountyName AS County, 
	p.PostCode, 
	lm.LicenceNumber, 
	lt.Name 'LicenceType', 
    lm.IssueDate, 
	lm.ExpiryDate, 
	p.Ppsn, 
	iu.ASPUserId, 
	p.DateOfBirth, 
	concat(lsm.Name, ' - ' + ls.Name) 'LicenceStateName',
	iu.ID as IndustryUserId
from 
			dl.LicenceMaster lm with (nolock)
				left join dl.LicenceType lt with (nolock) on lt.LicenceTypeId=lm.LicenceTypeId
				left join dl.LicenceHolderMaster lhm with (nolock) on lhm.LicenceMasterId=lm.LicenceMasterId
				left join person.v_opv p on p.Id=lhm.PersonId
				left join cabs_production.cabs_spsv.IndustryUserPerson iup with (nolock) on p.Id=iup.PersonId
				left join cabs_production.cabs_cmo.IndustryUser iu with (nolock) on iu.ID=iup.IndustryUserId
				--left join dl.Area pa on pa.AreaId=lm.PrimaryAreaId
				left join dl.LicenceStateMaster lsm with (nolock) on lsm.LicenceStateMasterID = lm.LicenceStateMasterID
				left join dl.LicenceState ls with (nolock) on ls.LicenceStateId = lm.LicenceStateId
			WHERE lm.LicenceStateMasterID = 1

GO


