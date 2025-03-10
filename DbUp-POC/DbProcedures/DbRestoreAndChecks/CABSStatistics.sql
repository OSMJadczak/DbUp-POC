DECLARE @StartDate datetime
DECLARE @EndDate datetime

SET @StartDate =  '2019-01-01 00:00:00.000'
SET @EndDate =	  '2019-12-31 23:59:00.000'

-- Number of DL licences added in month April - 52
select count(*) as NoOfDLLicencesAdded from cabs_production.dl.licencemaster where createddate between @StartDate and @EndDate

-- Number of VL licences added in month April - 61
select count(*) as NoOfVLLicencesAdded from cabs_production.dbo.licencemastervl where createddate between @StartDate and @EndDate

-- Number of VLS bookings for April
select count(*) as NoOfVLBookings from [dbo].[Booking] where createddate between @StartDate and @EndDate

-- Number of completed Vehicle Inspections in month April - 2502
select  count(*) as NoOfCompletedVehInspections from cabs_production.[dbo].[VehicleInspections] where createddate between @StartDate and @EndDate

-- Number of completed Skills tests in month April - 295
select  count(*) as NoOfCompletedSkillsTests from  cabs_production.[cabs_sk].[CandidateTest] where startdatetime between @StartDate and @EndDate

-- Number of SKILLS bookings for April
select count(*) as NoOfCompletedSkillsBookings from cabs_sk.[Booking] where createdon between @StartDate and @EndDate

-- Number of road side audits in month April - 1283
select  count(*) as NoOfRoadSideAudits from [cabs_enf].[Audit] where datetime between @StartDate and @EndDate

-- number of road side searches/checks performed by enbforcement officers - 6897
select  count(*) as NoOfRoadSideSearches from [cabs_enf].[SearchAudit] where createdon between @StartDate and @EndDate

-- number of Vehicle/driver links created in month April - 9520
select  count(*) as NoOfVehDriverLinksCreated  from [cabs_dvl].[VehicleDriver] where createdon between @StartDate and @EndDate

-- number of Vehicle/driver links created in month April - 101
select count(*)  as NoOfRentalAgreementsCreated from [cabs_rta].[RentalAgreement] where createdon between @StartDate and @EndDate

--number of searches performed via DriverCheck mobile app
SELECT count(*) as NoOfDriverCheckAppSearches FROM [cabs_production].[cabs_dck].[DriverCheckLog] where searchdate  between @StartDate and @EndDate

-- Number of DL Letters created in month April
select count(*) as NoOfDLLettersIssued from cabs_production.dl.LetterRequestMaster p where p.LetterRequestTypeId in (1,2,3) and createddate between @StartDate and @EndDate
select count(*) as NoOfDLLettersIssuedviaSPSVOnline  from cabs_production.dl.LetterRequestMaster where linkmethod = 'SPSV Online' and createddate between @StartDate and @EndDate
select count(*) as NoOfDLLettersIssuedviaSPSVApp from cabs_production.dl.LetterRequestMaster where linkmethod = 'Industry App'  and createddate between @StartDate and @EndDate
select count(*) as NoOfDLLettersIssuedviaSMSService from cabs_production.dl.LetterRequestMaster where linkmethod = 'SMS Service' and createddate between @StartDate and @EndDate 
select count(*) as NoOfDLLettersIssuedviaNTASPSVInternal from cabs_production.dl.LetterRequestMaster where linkmethod = 'NTA Internal' and createddate between @StartDate and @EndDate
select count(*) as NoOfDLLettersIssuedviaCABSSystem from cabs_production.dl.LetterRequestMaster where linkmethod = 'System' and createddate between @StartDate and @EndDate

-- Number of VL Letters created in month April
select count(*) as NoOfVLLettersIssued from [dbo].[PrintRequestMasterVL] where createddate between @StartDate and @EndDate

-- Number of Processed SMS Messages created in month April
-- SMS Messages --
SELECT count(*) as NoOfSMSMessagesProcessed
FROM [cabs_sms].[IncomingMessage] im
JOIN [cabs_sms].[IncomingMessageContentType] imc on imc.id = im.contenttypeid
JOIN [cabs_sms].[IncomingMessageProcessResultType] impt on impt.id = im.processresulttypeid
where PROCESSEDDATE between @StartDate and @EndDate 


-- CASE MANAGEMENT
select count(*) as NoOfCMSCasesCreated  from cabs_live.[dbo].[Cases] c where creation_date between @StartDate and @EndDate 

-- Taxi Compliments and complaints
select count(*) as NoOfCMSCasesCreatedFromTFISite  from cabs_live.[dbo].[Cases] c where source = 'Consumer Site'and creation_date between @StartDate and @EndDate   

-- Contact Us
select count(*) as NoOfCMSCasesCreatedFromContactUS from cabs_live.[dbo].[Cases] c   where source = 'Industry Site'and creation_date between @StartDate and @EndDate

--- Stats for 2018
Number of new Driver Licences issued: 1333
Number of new Vehicle Licences issued: 1019
Number of Vehicle Inspecton Bookings: 31147
Number of completed Vehicle Inspections: 29433
Number of Completed Skills Bookings: 6652
Number of completed Skills Tests: 5603
Number of Driver Check app searches: N/A – table that logs data had to be truncated due to GDPR changes made to the systems. Number of searches from 2019-01-01 12:00:00.000 until now (2019): 562925
Number of Road Side Searches (iCABS): 206795
Number of Road Side audits (iCABS): 17610
Number of Driver to Vehicle links created: 153371
Number of Rental Agreements created: 2109
Number of Driver Licence holder letters issued via  SPSV Online Public system: 23300
Number of Driver Licence holder letters issued via  SPSV Online Internal system: 36082
Number of Driver Licence holder letters issued via  SPSV  mobile application: 110460
Number of Driver Licence holder letters issued via  SMS Service: 101736
Number of Driver Licence holder letters issued via  Driver Licencing System: 43538
Number of Vehicle Licence holder letters issued via  Vehicle Licencing System: 341343
Number of processed SMS Messages (vehicle to driver linking): 56552
Number of Cases created in CMS system: 9216
Number of Cases created in CMS via Taxi for Ireland site: 1946
Number of Cases created in CMS via Contact Us site: 699

--- Stats for 2019
Number of new Driver Licences issued: 1697
Number of new Vehicle Licences issued: 1351
Number of Vehicle Inspecton Bookings: 32234
Number of completed Vehicle Inspections: 31032
Number of Completed Skills Bookings: 6619
Number of completed Skills Tests: 5353
Number of Driver Check app searches: 275478
Number of Road Side Searches (iCABS): 202571
Number of Road Side audits (iCABS): 14589
Number of Driver to Vehicle links created: 155927
Number of Rental Agreements created: 2109
Number of Driver Licence holder letters issued via  SPSV Online Public system: 20976
Number of Driver Licence holder letters issued via  SPSV Online Internal system: 36942
Number of Driver Licence holder letters issued via  SPSV  mobile application: 125358
Number of Driver Licence holder letters issued via  SMS Service: 94616
Number of Driver Licence holder letters issued via  Driver Licencing System: 42211
Number of Vehicle Licence holder letters issued via  Vehicle Licencing System: 345180
Number of processed SMS Messages (vehicle to driver linking): 51455
Number of Cases created in CMS system: 9667
Number of Cases created in CMS via Taxi for Ireland site: 2048
Number of Cases created in CMS via Contact Us site: 603


-- TOTAL NUMBER OF ACTIVE/REGISTERED USERS USERS WITH ROLES
SELECT   
AU.USERNAME,
Roles = STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID 
						 FOR XML PATH ('')), 1, 1, ''
      ),
AM.EMAIL, 
AM.CREATEDATE, 
AM.LASTLOGINDATE, 
AM.ISAPPROVED 
FROM  ASPNET_MEMBERSHIP AS AM 
INNER JOIN ASPNET_USERS AS AU ON AM.USERID = AU.USERID
WHERE IsApproved = 1
AND STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID 
						 FOR XML PATH ('')), 1, 1, ''
      ) IS NOT NULL
order by LastLoginDate desc

-- TOTAL NUMBER OF SPSV PORTAL USERS
SELECT   
AU.USERNAME,
Roles = STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID  
						 FOR XML PATH ('')), 1, 1, ''
      ),
AM.EMAIL, 
AM.CREATEDATE, 
AM.LASTLOGINDATE, 
AM.ISAPPROVED 
FROM  ASPNET_MEMBERSHIP AS AM 
INNER JOIN ASPNET_USERS AS AU ON AM.USERID = AU.USERID
WHERE IsApproved = 1 and
STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID  
						 FOR XML PATH ('')), 1, 1, ''
      ) = 'SPSV,SPSVDL'
order by LastLoginDate desc

-- TOTAL NUMBER OF TAXI PORTAL USERS
SELECT   
AU.USERNAME,
Roles = STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID  
						 FOR XML PATH ('')), 1, 1, ''
      ),
AM.EMAIL, 
AM.CREATEDATE, 
AM.LASTLOGINDATE, 
AM.ISAPPROVED 
FROM  ASPNET_MEMBERSHIP AS AM 
INNER JOIN ASPNET_USERS AS AU ON AM.USERID = AU.USERID
WHERE IsApproved = 1 and
STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID  
						 FOR XML PATH ('')), 1, 1, ''
      ) = 'SPSV,SPSVVL'
order by LastLoginDate desc

-- TOTAL NUMBER OF INTERNAL NTA USERS
SELECT   
AU.USERNAME,
Roles = STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID  
						 FOR XML PATH ('')), 1, 1, ''
      ),
AM.EMAIL, 
AM.CREATEDATE, 
AM.LASTLOGINDATE, 
AM.ISAPPROVED 
FROM  ASPNET_MEMBERSHIP AS AM 
INNER JOIN ASPNET_USERS AS AU ON AM.USERID = AU.USERID
WHERE IsApproved = 1 and
STUFF(
                 (SELECT ',' + ar.ROLENAME FROM  ASPNET_USERSINROLES AS AUR 
						INNER JOIN ASPNET_ROLES AS AR ON AUR.ROLEID = AR.ROLEID
						WHERE AU.USERID = AUR.USERID  
						 FOR XML PATH ('')), 1, 1, ''
      ) not in  ('SPSV,SPSVDL', 'SPSV,SPSVVL')
order by LastLoginDate desc




