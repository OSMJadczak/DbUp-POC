USE [cabs_production]
GO

---------------------- Step 1: Migrate DL IndustryUsers ----------------------
-- * insert IndustryUser with PersonId from cabs_spsv.IndustryUserDriverLicenceHolderMaster
--   there is no duplicates in cabs_spsv.IndustryUserDriverLicenceHolderMaster and LicenceHolderMasterFK is PersonId so direct insert can be performed

insert into cabs_spsv.IndustryUserPerson(IndustryUserId, PersonId)
select iu.id, p.PersonId from 
cabs_cmo.IndustryUser iu 
inner join cabs_spsv.IndustryUserDriverLicenceHolderMaster iudl on iu.ID = iudl.IndustryUserFK
inner join person.Person p on p.PersonId = iudl.LicenceHolderMasterFK

---------------------- Step 2: Migrate VL IndustryUsers ----------------------
-- * to get personId for given VL IndusryUser join between cabs_spsv.IndustryUserLicenceHolderMaster, dbo.LicenceHolderMaster and person.Person is required (join is done by CCSN number)
-- * already existing PersonId in cabs_spsv.IndustryUserPerson are skipped - this is a case when given user has a VL and DL licence,
--   (those PersonId's exists because of DL IndustryUsers migation, according to SRS DL users have higher priority)
-- * there are some duplicates for given LicenceHolder (could be checked with GroupBy LicenceHolderFK on cabs_spsv.IndustryUserLicenceHolderMaster)
--   so, one LicenceHolder can have multiple VL Licences, so, it has multiple IndustryUser profiles because signle IndustryUser profile relates to signle licence.
--   In such scenerio most recently used profile will be migrated. Also, if given user has never been used (registration haven't been completed yet, so LastActivityDate is null), then most recently created is taken

insert into cabs_spsv.IndustryUserPerson(IndustryUserId, PersonId)
select id, PersonId
from (
select iu.id, p.PersonId, u.LastActivityDate, iu.CreatedOn, row_number() over(partition by p.PersonId order by u.LastActivityDate desc, iu.CreatedOn desc) as roworder
from cabs_cmo.IndustryUser iu
inner join cabs_spsv.IndustryUserLicenceHolderMaster iuvl on iu.ID = iuvl.IndustryUserFK
inner join dbo.LicenceHolderMaster vl on iuvl.LicenceHolderMasterFK = vl.LicenceHolderId
inner join person.Person p on p.CCSN = vl.Ccsn
left outer join dbo.aspnet_Users u on u.UserId = iu.ASPUserId
where PersonId not in (select PersonId from cabs_spsv.IndustryUserPerson)
) temp
where roworder = 1 and Id not in (select IndustryUserId from cabs_spsv.IndustryUserPerson)
