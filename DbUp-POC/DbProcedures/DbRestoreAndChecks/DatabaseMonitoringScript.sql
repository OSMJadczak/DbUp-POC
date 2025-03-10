
-- Audit Logs Check
SELECT TOP 100 * from  [cabs_production].[cabs_log].[InternalLog] with (NOLOCK) where methodname not in ('ValidateAuthToken','ValidateToken')  order by id desc
SELECT TOP 100 * from  [cabs_production].[cabs_log].[InternalLog] with (NOLOCK) where LogLevel = 3   order by id desc
SELECT TOP 100 * from  [cabs_production].[cabs_log].[InternalLog] with (NOLOCK)  order by id desc
SELECT TOP 100 * FROM [cabs_production].[cabs_dck].[DriverCheckLog] with (NOLOCK) ORDER BY SEARCHID DESC
SELECT TOP 100 * FROM [cabs_production].[cabs_cmo].[Audit] with (NOLOCK) ORDER BY ID DESC
SELECT TOP 100 * FROM [cabs_production].[cabs_cmo].[AuditLog] with (NOLOCK) ORDER BY ID DESC

SELECT TOP 100 * from  [cabs_production].[cabs_log].[InternalLog] where message like '%exception%' and MethodName not in ('LogInDriverLicenceHolder','LogInVehicleLicenceHolder') order by id desc

-- ICABS Search Audit check
select top 100 createdby,sa.* from [cabs_enf].[SearchAudit] sa 
	left join aspnet_Users au on au.userid = sa.enforcementofficeruid-- where gps_lon is null
		--where createdby in ('jkineen')
order by id desc


-- CHECK IF MOBILE APPS ARE WORKING AND SPSV JOBS RUNNING
/*
linkmethod
NULL
Industry App
NTA Internal
SMS Service
SPSV Online
System
*/

select top 30 CreatedDate, ModifiedDate, * from cabs_live.dbo.printrequestmaster where linkmethod = 'SPSV Online' order by printrequestmasterid  desc
select top 30 CreatedDate, ModifiedDate, * from cabs_live.dbo.printrequestmaster where linkmethod = 'Industry App' order by printrequestmasterid  desc
select top 30 CreatedDate, ModifiedDate, * from cabs_live.dbo.printrequestmaster where linkmethod = 'SMS Service' order by printrequestmasterid  desc

select count(*)  from cabs_live.dbo.printrequestmaster where linkmethod = 'SPSV Online' and  CreatedDate >  '2017-04-08 04:00:00.000' 
select count(*) from cabs_live.dbo.printrequestmaster where linkmethod = 'Industry App' and  CreatedDate >  '2017-04-08 04:00:00.000' 
select count(*) from cabs_live.dbo.printrequestmaster where linkmethod = 'SMS Service' and  CreatedDate >  '2017-04-08 04:00:00.000'  

-- Check Rental Agreements
select top 100 * from [cabs_rta].[RentalAgreement]  order by id desc
select top 100 * from [cabs_dvl].VehicleDriver order by CreatedOn desc

select count(*) from [cabs_rta].[RentalAgreement] where   CreatedOn >  '2017-04-08 04:00:00.000' 
select count(*) from [cabs_dvl].VehicleDriver where   CreatedOn >  '2017-04-08 04:00:00.000' 

-- VLS Check Revenue Check
select top 1000 lastdocumentationcheckdate,* from Cabs_production.dbo.LicenceHolderMaster l where  TaxClearanceCertExists = 1 and lastdocumentationcheckdate > DATEADD(day, -1 , DATEDIFF(dd, 0, GETDATE())) order by l.lastdocumentationcheckdate desc
select top 1000  lastdocumentationcheckdate,* from Cabs_production.dbo.LicenceHolderMaster l where  TaxClearanceCertExists = 0 and lastdocumentationcheckdate > DATEADD(day, -1 , DATEDIFF(dd, 0, GETDATE()))  order by l.lastdocumentationcheckdate desc
select top 1000  lastdocumentationcheckdate,* from Cabs_production.dbo.LicenceHolderMaster l where  TaxClearanceCertExists is null and lastdocumentationcheckdate > DATEADD(day, -1 , DATEDIFF(dd, 0, GETDATE())) order by l.lastdocumentationcheckdate desc

-- DLS Revenue Check
select TaxClearanceCheckDate,* from Cabs_production.[person].[TaxClearanceCheck] l where  TaxClearanceStatusId = 1  and TaxClearanceCheckDate > DATEADD(day, -1, DATEDIFF(dd, 0, GETDATE())) order by l.TaxClearanceCheckDate desc
select TaxClearanceCheckDate,* from Cabs_production.[person].[TaxClearanceCheck] l where  TaxClearanceStatusId = 2  and TaxClearanceCheckDate > DATEADD(day, -1 , DATEDIFF(dd, 0, GETDATE())) order by l.TaxClearanceCheckDate desc
select TaxClearanceCheckDate,* from Cabs_production.[person].[TaxClearanceCheck] l where  TaxClearanceStatusId = 3  and TaxClearanceCheckDate > DATEADD(day, -1 , DATEDIFF(dd, 0, GETDATE())) order by l.TaxClearanceCheckDate desc

-- NOTIFICATIONS
select  rn.[RevenueNotificationSendDate], rn.CreatedDate,rn.CreatedBy, rt.RevenueNotificationType from [cabs_production].[person].[RevenueNotification] rn
join [cabs_production].[person].[RevenueNotificationType] rt on rt. [RevenueNotificationTypeId] = rn.RevenueNotificationTypeId
where rn.[RevenueNotificationSendDate] > DATEADD(day, -1 , DATEDIFF(dd, 0, GETDATE())) order by rn.[RevenueNotificationSendDate] desc

-- DL Letters 
select top 1000 PRM.modifieddate, LetterCode, email,  * from [cabs_production].[dl].[LetterRequestMaster] PRM  
INNER JOIN  cabs_production.dbo.LetterRequestTypeVL LRA ON LRA.LetterRequestTypeId = PRM.LetterRequestTypeVLId
where /*DespatchMethodid = 3 /*email*/ AND*/ PRM.modifieddate >  DATEADD(day, -1 , DATEDIFF(dd, 0, GETDATE()))
--AND EMAIL <> 'CABSUAT1@nationaltransport.ie'
order by LetterRequestmasterid desc

-- INSPECTIONS Revenue Check
SELECT TOP 100 * from  [cabs_production].[cabs_log].[InternalLog] with (NOLOCK) where methodname = 'CheckRevenue' order by id desc

-- SMS Messages --
SELECT top 50 im.id,imc.type, impt.type,receiveddate, processeddate, industryuserid, messagetext, mobilephonenumber   
FROM [cabs_sms].[IncomingMessage] im
JOIN [cabs_sms].[IncomingMessageContentType] imc on imc.id = im.contenttypeid
JOIN [cabs_sms].[IncomingMessageProcessResultType] impt on impt.id = im.processresulttypeid
ORDER BY PROCESSEDDATE DESC

-- PRINT CARDS
select pr.PrintcardRequestId,
	pr.CreatedDate as CardRequestCreatedDate, 
	LicenceNumber,
	pro.PrintcardRequestOptionName as PrintCardName,
	prt.PrintcardRequestTypeName as PrintReqestType,  
	prrs.PrintcardRequestSourceName as PrintCardProcess, 
	prs.PrintcardStatusName as PrintCardStatus, 
	prr.PrincardRequestReasonName as PrincardRequestReason , 
	BatchId  as PrintRequestBatchCreatedDate,
	PrintcardRequestStatusMessage
from  cabs_production.dl.PrintcardRequest pr 
left join [dl].[PrintcardStatus] prs on prs.PrintcardStatusId = pr.PrintcardStatusId
left join [dl].[PrintcardRequestReason] prr on prr.PrintcardRequestReasonId = pr.PrintcardRequestReasonId
left join [dl].[PrintcardRequestType] prt on prt.PrintcardRequestTypeId = pr.PrintcardRequestTypeId
left join [dl].[PrintcardRequestSource] prrs on prrs.PrintcardRequestSourceId = pr.PrintcardRequestSourceId
left join [dl].[PrintcardRequestOption] pro on pro.PrintcardRequestOptionId = pr.PrintcardRequestOptionId
--where BatchId = '20190409110216' 
--and prt.PrintcardRequestTypeName = 'Yellow'
where pr.printcardstatusid = 1 and BatchId is null
-- and PrintcardRequestOptionName = 'Area Roofsign Sticker' 
order by pr.PrintcardRequestId desc


-- CASE MANAGEMENT
select top 100 creation_date,* from cabs_live.[dbo].[Cases] c order by id desc

-- Taxi Compliments and complaints
select top 100 creation_date,* from cabs_live.[dbo].[Cases] c where source = 'Consumer Site'  order by id desc

-- Contact Us
select top 100 creation_date,* from cabs_live.[dbo].[Cases] c   where source = 'Industry Site' order by id desc


-- OTHER

SELECT TOP 100 * FROM [cabs_production].[cabs_cmo].[AuditLog] where ActionId in ('SmsSender', 'SmsServiceLogic') ORDER BY ID DESC
SELECT * FROM [CABS_DCK].[ANONYMOUSTOKEN] WHERE DATEDIFF(MINUTE, LASTUSEDUTC, GETUTCDATE()) BETWEEN 0 AND 15 ORDER BY LASTUSEDUTC DESC

-- DBMAIL CHECKS
SELECT top 1000 *, items.subject,
	items.last_mod_date
	,l.description FROM msdb.dbo.sysmail_mailitems as items
INNER JOIN msdb.dbo.sysmail_event_log AS l
	ON items.mailitem_id = l.mailitem_id
--	where  event_type <> 'error'
order by send_request_date  desc

select * from cabs_sms.SmsServiceRegistration where MobilePhoneNumber = '353871616287'
-update cabs_sms.SmsServiceRegistration  set MobilePhoneNumber = '353871616288' where id = 5019
