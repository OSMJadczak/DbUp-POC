
/* ======================================================== 
--- DISABLE CHANGE TRACKING
======================================================== */
USE [cabs_production]
GO


ALTER TABLE [cabs_cmo].[Person] DISABLE CHANGE_TRACKING;

ALTER TABLE [dbo].[LicenceHolderMaster] DISABLE CHANGE_TRACKING;

ALTER TABLE [person].[Person] DISABLE CHANGE_TRACKING;

ALTER TABLE [person].[Individual] DISABLE CHANGE_TRACKING;

ALTER TABLE [person].[Company] DISABLE CHANGE_TRACKING;

ALTER TABLE [person].[Email] DISABLE CHANGE_TRACKING;

ALTER TABLE [person].[Address] DISABLE CHANGE_TRACKING;

ALTER TABLE [person].[Phone] DISABLE CHANGE_TRACKING;

ALTER DATABASE [cabs_production] SET CHANGE_TRACKING = OFF 

go

-- MARSHALLER FIX FOR SYS CHANGED VERSION
update [DataMarshaller].[marshaller].[DatabaseChangeVersion] set SysChangeVersion = 0


/* ======================================================== 
--  UPDATE EMAILS FOR ALL LICENCE HOLDERS TO DUMMY
======================================================== */
use [cabs_production]
GO

UPDATE [cabs_production].[dbo].[LicenceHolderMaster] SET Email = 'CABSPREPROD@NATIONALTRANSPORT.IE' where email is not null
UPDATE [cabs_production].[cabs_cmo].[Person] SET Email = 'CABSPREPROD@NATIONALTRANSPORT.IE' where email is not null
--UPDATE [cabs_live].[dbo].[LicenceHolderMaster]  SET Email = 'CABSPREPROD@NATIONALTRANSPORT.IE' where email is not null
UPDATE [cabs_production].[person].[Email] SET Email = 'CABSPREPROD@NATIONALTRANSPORT.IE' where email is not null
update cabs_live.dbo.Cases set raisedby_emailaddress = replace(raisedby_emailaddress,'@','@example') where raisedby_emailaddress is not null or raisedby_emailaddress != ''

GO

/* ======================================================== 
-- UPDATE PASSWORDS FOR OPENSKY USER ACCOUNTS
======================================================== */
DECLARE @pass varchar(MAX);
DECLARE @salt varchar(MAX);
SET @salt = '4P5xaqOGHG90xTCTMm2zUg==';	 
-- ***************  PASSWORD: uatosdsnat*1		 ************************
SET @pass = 'W4wxGKrco4RGk6yYy3nY/5I1JJs=';			 
-- update opensky account
update dbo.aspnet_membership set password=@pass, passwordsalt=@salt where userid IN (SELECT UserId FROM aspnet_Users WHERE UserName LIKE 'opensky%' or Username Like 'background%' or username like 'tc_job_user' or username like 'taxi_portal' or UserName LIKE 'os%' or UserName LIKE '%nosal%';
UPDATE aspnet_Membership SET IsLockedOut=0,LastPasswordChangedDate=GETDATE()+365 WHERE UserId IN (SELECT UserId FROM aspnet_Users WHERE UserName LIKE 'opensky%' or Username Like 'background%' or username like 'tc_job_user' or username like 'taxi_portal' or UserName LIKE 'os%'or UserName LIKE '%nosal%');

update dbo.aspnet_membership set password=@pass, passwordsalt=@salt where userid IN (SELECT aspnet_Users.UserId FROM aspnet_Users join aspnet_membership m on m.[UserId] = aspnet_users.[UserId] WHERE m.email like '%opensky%' or m.email like '%national%');
UPDATE aspnet_Membership SET IsLockedOut=0,LastPasswordChangedDate=GETDATE()+365 WHERE UserId IN (SELECT aspnet_Users.UserId FROM aspnet_Users join aspnet_membership m on m.[UserId] = aspnet_users.[UserId] WHERE m.email like '%opensky%' or m.email like '%national%');
--check icabs user 

/* ======================================================== 
-- UPDATE PASSWORDS FOR OPENSKY USER ACCOUNTS
======================================================== */
DECLARE @pass varchar(MAX);
DECLARE @salt varchar(MAX);
SET @salt = '4P5xaqOGHG90xTCTMm2zUg==';	 
-- ***************  PASSWORD: uatosdsnat*1		 ************************
SET @pass = 'W4wxGKrco4RGk6yYy3nY/5I1JJs=';			 
-- update opensky account
update dbo.aspnet_membership set password=@pass, passwordsalt=@salt where userid IN (SELECT UserId from aspnet_Membership where Email like '%nationaltransport%');
UPDATE aspnet_Membership SET IsLockedOut=0,LastPasswordChangedDate=GETDATE()+365 WHERE UserId IN (SELECT UserId from aspnet_Membership where Email like '%nationaltransport%');


---======================================================== */
DECLARE @pass varchar(MAX);
DECLARE @salt varchar(MAX);
SET @salt = '4P5xaqOGHG90xTCTMm2zUg==';	 
-- ***************  PASSWORD: uatosdsnat*1		 ************************
SET @pass = 'W4wxGKrco4RGk6yYy3nY/5I1JJs=';			 
-- update opensky account
update dbo.aspnet_membership set password=@pass, passwordsalt=@salt where userid IN (SELECT UserId FROM aspnet_Users WHERE UserName LIKE 'sk_onlineRegister%' );
UPDATE aspnet_Membership SET IsLockedOut=0,LastPasswordChangedDate=GETDATE()+365 WHERE UserId IN (SELECT UserId FROM aspnet_Users WHERE UserName LIKE 'sk_onlineRegister%' );


GO

/* ======================================================== 
-- UPDATE PASSWORDS FOR ALL INDUSTRY USERS ACCOUNTS
======================================================== */
DECLARE @pass varchar(MAX);
DECLARE @salt varchar(MAX);
SET @salt = '4P5xaqOGHG90xTCTMm2zUg==';
-- ***************  PASSWORD: uatosdsnat*1    ************************
SET @pass = 'W4wxGKrco4RGk6yYy3nY/5I1JJs=';		
update dbo.aspnet_membership
set password=@pass, passwordsalt=@salt from dbo.aspnet_membership inner join cabs_cmo.IndustryUser on IndustryUser.ASPUserId=UserId
GO

/* ======================================================== 
-- UPDATE PASSWORDS FOR ALL Branding Suppliers
======================================================== */
-- Select loweredusername, supplierid, * from [cabs_tds].[AuthorizedSupplier] tds join aspnet_users au on au.userid = tds.aspuserid
DECLARE @pass varchar(MAX);
DECLARE @salt varchar(MAX);
SET @salt = '4P5xaqOGHG90xTCTMm2zUg==';
-- ***************  PASSWORD: uatosdsnat*1    ************************
SET @pass = 'W4wxGKrco4RGk6yYy3nY/5I1JJs=';		
update dbo.aspnet_membership
set password=@pass, passwordsalt=@salt from dbo.aspnet_membership WHERE UserId IN (Select au.userid from [cabs_tds].[AuthorizedSupplier] tds join aspnet_users au on au.userid = tds.aspuserid)
GO


/* ======================================================== 
-- Prevent SPSV AND SKILLS LETTERS FROM BEING SENT TWICE
======================================================== */


USE [cabs_production]

--SELECT * FROM [cabs_production].[dl].[LetterRequestDetail] where letterrequeststatusid = 1
--SELECT * FROM [cabs_production].[dl].[LetterRequestMaster] where letterrequeststatusid = 1
 
 
update [cabs_production].[dl].[LetterRequestDetail] set letterrequeststatusid = 3 where letterrequeststatusid = 1
update [cabs_production].[dl].[LetterRequestMaster]  set letterrequeststatusid = 3 where letterrequeststatusid = 1


-- Prevent SPSV Letters from sending
USE [cabs_production]
GO

/*	--- DISPLAY ALL UNSENT SPSV VLS PRINT REQUESTS
SELECT	
	count(*)
	FROM dbo.PrintRequestDetailVL P
	WHERE PrintCompanyId = 1 -- SGS
	AND PrintRequestStatusId = 1 -- NEW
	AND PrintRequestMasterId NOT IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL_InvalidRequests
	)
	AND PrintRequestMasterId IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL where SkBookingID is null
	)
	AND PrintRequestMasterId IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL cabs_production WHERE [LetterRequestTypeAuditId] IN (SELECT [LetterRequestTypeAuditId] FROM [dbo].[LetterRequestTypeVLAudit] where LetterCode like 'SPSV%')
	)
*/

	UPDATE  dbo.PrintRequestDetailVL set PrintRequestStatusId = 3 where  PrintCompanyId = 1 -- SGS
	AND PrintRequestStatusId = 1 -- NEW
	AND PrintRequestMasterId NOT IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL_InvalidRequests
	)
	AND PrintRequestMasterId IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL where SkBookingID is null
	)
	AND PrintRequestMasterId IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL cabs_production WHERE [LetterRequestTypeAuditId] IN (SELECT [LetterRequestTypeAuditId] FROM [dbo].[LetterRequestTypeVLAudit] where LetterCode like 'SPSV%')
	)
	
	-- Prevent VLS Letters from sending
	USE [cabs_production]
	GO

	/*	--- DISPLAY ALL UNSENT VLS PRINT REQUESTS
	SELECT	
		count(*)
		FROM dbo.PrintRequestDetailVL P
		WHERE PrintCompanyId = 1 -- SGS
		AND PrintRequestStatusId = 1 -- NEW
		AND PrintRequestMasterId NOT IN
		(
			SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL_InvalidRequests
		)
		AND PrintRequestMasterId IN
		(
			SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL where SkBookingID is null
		)

	*/
	-- DISPLAY ALL UNSENT SPSV VLS PRINT REQUESTS
		UPDATE  dbo.PrintRequestDetailVL set PrintRequestStatusId = 3 where  PrintCompanyId = 1 -- SGS
		AND PrintRequestStatusId = 1 -- NEW
		AND PrintRequestMasterId NOT IN
		(
			SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL_InvalidRequests
		)
		AND PrintRequestMasterId IN
		(
			SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL where SkBookingID is null
		)

	

	/*	--- DISPLAY ALL UNSENT SKILLS PRINT REQUESTS
	select count(*)
	FROM dbo.PrintRequestDetailVL P
	WHERE PrintCompanyId = 1 -- SGS
	AND PrintRequestStatusId = 1 -- NEW
	AND PrintRequestMasterId NOT IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL_InvalidRequests
	)
	AND PrintRequestMasterId IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL where SkBookingID is  not null
	)*/
	
	-- UPDATE SKILLS LETTERS QUERY
	UPDATE  dbo.PrintRequestDetailVL set PrintRequestStatusId = 3 where  PrintCompanyId = 1 -- SGS
	AND PrintRequestStatusId = 1 -- NEW
	AND PrintRequestMasterId NOT IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL_InvalidRequests
	)
	AND PrintRequestMasterId IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL where SkBookingID is not null
	)

GO

/* ======================================================== 
-- Clear temp tables
======================================================== */

	truncate table [Cabs_production].[cabs_aut].[AuthToken]
	truncate table [Cabs_production].[cabs_aut].[AuthTokenHistory]
	truncate table [Cabs_production].[cabs_cmo].[Audit]
	truncate table [Cabs_production].[cabs_cmo].[AuditLog]
	truncate table [Cabs_production].[cabs_cmo].[PasswordHistory]
	truncate table [Cabs_production].[cabs_cmo].[PasswordReminder]
	truncate table [Cabs_production].[cabs_cmo].[RegistrationToken]
	truncate table [Cabs_production].[cabs_dck].[AuthTokenWatchList]
	delete from [Cabs_production].[cabs_dck].[AnonymousToken]
	truncate table [Cabs_production].[cabs_dck].[DriverCheckLog]
	truncate table [Cabs_production].[cabs_dck].[DriverCheckReport]
	truncate table [Cabs_production].[cabs_dck].[DriverCheckSearchResult]
	truncate table [Cabs_production].[cabs_enf].[DeviceLock]
	truncate table [Cabs_production].[cabs_enf].[SearchAudit]
	truncate table [Cabs_production].[cabs_enf].[SearchAudit_DataImport]
	truncate table [Cabs_production].[cabs_enf].[UsersLock]

	truncate table [Cabs_production].[cabs_log].[InternalLog]
	truncate table [Cabs_production].[dbo].[Logs]
	truncate table [Cabs_production].[dbo].[BookingCheckings]
	truncate table [Cabs_production].[dbo].[LetterPrintJobLogs]
	truncate table [Cabs_production].[dbo].[PrintEventLogs]

GO

/* ======================================================== 
-- UNREGISTER ALL SPSV Users from SMS SERVICE
======================================================== */
USE [cabs_production]
GO
 UPDATE [cabs_production].[cabs_sms].[SmsServiceRegistration] set isRegistered = 0
GO

/* ======================================================== 
-- ENABLE CHANGE TRACKING
======================================================== */
USE [cabs_production]
GO

ALTER DATABASE [cabs_production] SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS,AUTO_CLEANUP = ON)

ALTER TABLE [cabs_cmo].[Person] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

ALTER TABLE [dbo].[LicenceHolderMaster] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)


ALTER TABLE [person].[Person] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

ALTER TABLE [person].[Individual] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

ALTER TABLE [person].[Company] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

ALTER TABLE [person].[Email] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

ALTER TABLE [person].[Address] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

ALTER TABLE [person].[Phone] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)
go


/* ======================================================== 
-- Modify [GetComplianceTeamEmails] stored procedure
======================================================== */
USE [cabs_production]
GO
/****** Object:  UserDefinedFunction [dbo].[GetComplianceTeamEmails]    Script Date: 12/12/2014 12:38:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec SELECT dbo.GetString(7)  
alter FUNCTION [dbo].[GetComplianceTeamEmails] 
(   
    
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
declare @RESULT_STRING varchar(MAX)
SET @RESULT_STRING = ''
SELECT  @RESULT_STRING = 'anosal@openskydata.com;fscolard@openskydata.com;'
Set @RESULT_STRING= SUBSTRING(@RESULT_STRING, 0, LEN(@RESULT_STRING)) 
RETURN @RESULT_STRING
END
GO



/* Check for sent letters

select * from cabs_cmo.Person where Email not like '%@NATIONALTRANSPORT.IE%'
select * from dbo.LicenceHolderMaster where Email not like '%@NATIONALTRANSPORT.IE%'
select * from person.Email where Email not like '%@NATIONALTRANSPORT.IE%'

-- DL
select top 1000 PRM.modifieddate, LetterCode, email,  * from [dl].[LetterRequestMaster] PRM  
INNER JOIN  cabs_production.dbo.LetterRequestTypeVL LRA ON LRA.LetterRequestTypeId = PRM.LetterRequestTypeVLId
where DespatchMethodid = 3 /*email*/ AND PRM.modifieddate > '2023-10-29 00:00:00.000' 
AND EMAIL not like '%@NATIONALTRANSPORT.IE'
order by LetterRequestmasterid desc

-- VL
select PRM.modifieddate,[PrintRequestStatusId], LetterCode, HolderEmail, * from [dbo].PrintRequestMasterVL   PRM
left join dbo.PrintRequestDetailVL prd on prd.PrintRequestMasterId = prm.PrintRequestMasterId
INNER JOIN dbo.LetterRequestTypeVLAudit LRA ON LRA.LetterRequestTypeAuditId = PRM.LetterRequestTypeAuditId
where DespatchMethodid = 3 /*email*/ AND SkBookingID is null AND prm.modifieddate > '2023-10-29 00:00:00.000'   
AND HolderEmail not like '%@NATIONALTRANSPORT.IE'
order by PRM.PrintRequestMasterId desc

-- SK
select PRM.modifieddate,[PrintRequestStatusId],  LetterCode, HolderEmail, * from [dbo].PrintRequestMasterVL   PRM
left join dbo.PrintRequestDetailVL prd on prd.PrintRequestMasterId = prm.PrintRequestMasterId
INNER JOIN dbo.LetterRequestTypeVLAudit LRA ON LRA.LetterRequestTypeAuditId = PRM.LetterRequestTypeAuditId
where SkBookingID is NOT null AND prm.modifieddate > '2023-10-29 00:00:00.000'  
AND HolderPPSN  in (select PPSN from cabs_production.cabs_cmo.Person where ContactMethodID = 1)
AND HolderEmail not like '%@NATIONALTRANSPORT.IE'
order by PRM.PrintRequestMasterId desc



*/

