USE [cabs_production]
GO

/****** Object:  View [dbo].[ssis_DL_DriverChangeLog]    Script Date: 04.11.2022 15:33:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[ssis_DL_DriverChangeLog] as

select 
distinct
pv.id 'PersonId', 
--lm.LicenceNumber,
STUFF((SELECT ', ' + lm1.LicenceNumber
	FROM dl.LicenceMaster lm1
	inner join dl.LicenceHolderMaster lhm1 on lhm1.LicenceMasterId=lm1.LicenceMasterId
	where lhm1.personid=pv.id
	FOR XML PATH ('')), 1, 2, '') AS 'LicenceNumber',
p.ProcessId,
convert(datetime, p.ChangeDate) 'ChangeDate',
case 
	when pv.PersonType = 'Individual' then concat(pv.FirstName, ' ' , pv.LastName) 
	else CompanyName
end 'Holder Name',
max(sms.MobilePhoneNumber) as [Current SMS Service Number],

max(iif(FieldName = 'Mobile Phone Number', OldValue, NULL)) 'Mobile Number (before update)',
max(iif(FieldName = 'Mobile Phone Number', NewValue, NULL)) 'Mobile Number (after update)',

max(iif(FieldName = 'Other Phone Number', OldValue, NULL)) 'Other phone number (before update)',
max(iif(FieldName = 'Other Phone Number', NewValue, NULL)) 'Other phone number (after update)',

max(iif(FieldName = 'Email Address', OldValue, NULL)) 'Email address (before update)',
max(iif(FieldName = 'Email Address', NewValue, NULL)) 'Email address (after update)',

max(iif(FieldName = 'Address Line 1', OldValue, NULL)) 'Address Line 1 (before update)',
max(iif(FieldName = 'Address Line 1', NewValue, NULL)) 'Address Line 1 (after update)',

max(iif(FieldName = 'Address Line 2', OldValue, NULL)) 'Address Line 2 (before update)',
max(iif(FieldName = 'Address Line 2', NewValue, NULL)) 'Address Line 2 (after update)',

max(iif(FieldName = 'Address Line 3', OldValue, NULL)) 'Address Line 3 (before update)',
max(iif(FieldName = 'Address Line 3', NewValue, NULL)) 'Address Line 3 (after update)',

max(iif(FieldName = 'Town', OldValue, NULL)) 'Town (before update)',
max(iif(FieldName = 'Town', NewValue, NULL)) 'Town (after update)',

max(iif(FieldName = 'County', OldValue, NULL)) 'County (before update)',
max(iif(FieldName = 'County', NewValue, NULL)) 'County (after update)',

max(iif(FieldName = 'Postcode', OldValue, NULL)) 'Postcode (before update)',
max(iif(FieldName = 'Postcode', NewValue, NULL)) 'Postcode (after update)'

from audit.Process p with (nolock)
 inner join audit.ChangeValue cv with (nolock) on cv.ProcessId=p.ProcessId
 inner join person.v_opv pv with (nolock) on pv.Id=p.ObjectId
 inner join dl.LicenceHolderMaster lhm with (nolock) on lhm.PersonId=pv.id
 inner join dl.LicenceMaster lm with (nolock) on lm.LicenceMasterId=lhm.LicenceMasterId
 left join cabs_spsv.IndustryUserPerson iup with (nolock) on pv.id =iup.PersonId
 left join cabs_sms.SmsServiceRegistration sms with (nolock) on iup.IndustryUserId=sms.IndustryUserId
where 
	ProcessTypeId in (10,26,37,38)
	and ModuleId = 6 --'SPSV Online'
group by 
	pv.id, p.ProcessId, p.ChangeDate, lm.LicenceNumber, pv.FirstName, pv.LastName, pv.PersonType, pv.CompanyName
GO


