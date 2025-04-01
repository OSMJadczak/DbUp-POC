use [cabs_production]
go

insert into cabs_spsv.IndustryUserPerson (PersonId, IndustryUserId) 
select PersonId, IndustryUserFK from (
select p.PersonId, iulhm.IndustryUserFK, row_number() over(partition by p.PersonId order by u.LastActivityDate desc, iu.CreatedOn desc) as roworder
from person.Person p
inner join person.DataSource ds on p.PersonId = ds.PersonId and ds.SourceSystemName = 'vls'
inner join dbo.LicenceMasterVL lmvl on lmvl.LicenceHolderId = ds.SourceSystemId
inner join cabs_spsv._ToDrop_IndustryUserLicenceHolderMaster iulhm on iulhm.LicenceHolderMasterFK = lmvl.LicenceHolderId 
	and iulhm.IndustryUserFK not in (select IndustryUserId from cabs_spsv.IndustryUserPerson)
inner join cabs_cmo.IndustryUser iu on iu.ID = iulhm.IndustryUserFK
left outer join dbo.aspnet_Users u on u.UserId = iu.ASPUserId
where p.PersonId not in (select PersonId from cabs_spsv.IndustryUserPerson)) temp
where roworder = 1