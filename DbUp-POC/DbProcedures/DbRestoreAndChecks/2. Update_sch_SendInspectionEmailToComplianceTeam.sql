-- Update [sch_SendInspectionEmailToComplianceTeam] to get rid of compliance team real email adresses

USE [cabs_production]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Syed
-- Create date: 30-Sep-2014
-- Description:	Check if there are Compliance Inspection is finished or is marked as No Show by the automated process then the email to Compliance Team.
-- The email would contains the following details .
-- Date & Time , Test Centre , Licence Number , Results (Completed : Failed or Successful , or No Show ).
-- It would execute every 10 minutes .
-- =============================================
-- -------------------------
-- TestResultID	TestResult
-- -------------------------
-- 1			Pass
-- 2			Fail
-- 3			No Show
-- 4			FAIL_ADVIS
-- 5			Duplicate TP


ALTER PROCEDURE [dbo].[sch_SendInspectionEmailToComplianceTeam]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @BookingId int,
		@TestCentreName varchar(50),
		@LicenceNumber varchar(50),
		@RegistrationNumber varchar(12),
		@BookingStatusName varchar(50),
		@TestResult varchar(50),
		@TestStartTime  varchar(100),
		@TestEndTime varchar(100),
		@ComplianceEmail nvarchar(MAX) ,
		@mailbody nvarchar(max),
		@title nvarchar(200),
		@Count int		
		
 		
DECLARE IU_NotInSync CURSOR FOR 

SELECT 		B.BookingId,
			TC.TestCentreName,
			B.LicenceNumber,
			B.RegistrationNumber,
			BS.BookingStatusName,
			TS.TestResult,
			CONVERT(VARCHAR(10), VI.[TestStartTime], 103) + ' '  + convert(VARCHAR(8), VI.[TestStartTime], 14) as TestStartTime,
			CONVERT(VARCHAR(10), VI.[TestEndTime], 103) + ' '  + convert(VARCHAR(8), VI.[TestEndTime], 14) as TestEndTime,			
			ComplianceEmail = ( SELECT m.Email  FROM Cabs_production.dbo.aspnet_Membership m Where m.UserId=B.[RequestedBy])  --Only Selected Compliance Team Member will recive en email
			--ComplianceEmail = (Select  dbo.GetComplianceTeamEmails() ) ----Send to All Live Compliance Team Members
			--ComplianceEmail = 'elizabeth.heggs@nationaltransport.ie'  --For Testing Purpose
		FROM
			dbo.Booking AS B
			JOIN dbo.VehicleInspections AS VI ON VI.BookingId = B.BookingId
			JOIN dbo.TestCentre TC On b.TestCentreId=TC.TestCentreId
			JOIN dbo.BookingStatus BS On B.BookingStatusId=BS.BookingStatusId
			JOIN dbo.TestResults TS ON VI.TestResultId=TS.TestResultID
		WHERE
		    ((B.BookingStatusId = 3 AND VI.TestResultId IN (1,2,3)) OR (B.BookingStatusId=5 AND VI.TestResultId=3))
			AND	B.[RequestedBy] IS NOT NULL AND
			B.[SystemProcessId]=18 AND   /* Compliance Inspection */
			(B.SentComplianceEmail IS NULL OR B.SentComplianceEmail = '')

	
OPEN IU_NotInSync   

Set @title = 'Compliance Inspection Booking Results';
FETCH NEXT FROM IU_NotInSync INTO @BookingId,@TestCentreName,@LicenceNumber,@RegistrationNumber,@BookingStatusName,@TestResult,@TestStartTime,@TestEndTime,@ComplianceEmail
while (@@FETCH_STATUS <> -1)	
  
	begin	  
		   IF(@ComplianceEmail <> '' AND @ComplianceEmail IS NOT NULL)
				BEGIN
				set @mailbody = '<html><head>
								<style type="text/css">
								body {font-family: Arial;font-size:12px;} 
								table{font-size:11px; border-collapse:collapse;table-layout: fixed} 
								td{ border:1px solid black; padding:3px;} 
								th{background-color:#F1F1F1;border:1px solid black; padding:3px;}
								h1{font-weight:bold; font-size:12pt}
								h2{font-weight:bold; font-size:10pt} </style></head>';

				set @mailbody += '<body><h3>Booking Inspection Details preprod </h3><br/> Dear User,<br/> <br/>The below Compliance Inspection has been completed.<br/> <br/>
				<table> 
				<tr>   
				<th> Booking Number </th> <th>Licence Number </th> <th> Test Centre </th> <th>Test Start Time</th><th>Test End Time</th><th>Status</th></tr>'  
				set @mailbody +='<tr><td>'+cast (@BookingId as varchar(20)) +'</td><td>'+cast (@LicenceNumber as varchar(20))+'</td>
				<td>' +cast (@TestCentreName as varchar(20))+ '</td><td>'+cast (@TestStartTime as varchar(20))+ '</td><td>' +cast (ISNULL(@TestEndTime, '') as varchar(20))+ '</td>
				<td>' +cast (@BookingStatusName +'-'+@TestResult as varchar(20))+ '</td></tr>'			
				set @mailbody += '</table><br/><br/>'				
				set @mailbody +='Best Regards,<br/>' ;
				set @mailbody +='National Transport Authority </body></html><br/><br/>' ;

				EXEC msdb.dbo.sp_send_dbmail
				@profile_name='cabs',
				@recipients = @ComplianceEmail,
				@copy_recipients =  'anosal@openskydata.com', 		
				@body = @mailbody,
				@subject = @title,
				@body_format = 'HTML';			
			

				Update  Cabs_production.dbo.Booking Set SentComplianceEmail=@ComplianceEmail Where BookingId =@BookingId

				INSERT INTO [Cabs_Production].[cabs_cmo].[AuditLog]
				([lkAuditLevelId] ,[lkAuditTypeId], [UserName], [TimeStamp], [Text])
				VALUES
				(40, 4, 'system_job', GETDATE(), 'Send Compliance EMail to : ' +@ComplianceEmail+' BookingID is :' + cast (@BookingId as varchar(20))+'');
				END

		  set @Count = @Count + 1	
     	
	  fetch next from IU_NotInSync into @BookingId,@TestCentreName,@LicenceNumber,@RegistrationNumber,@BookingStatusName,@TestResult,@TestStartTime,@TestEndTime,@ComplianceEmail
	end
    close IU_NotInSync
    deallocate IU_NotInSync	
    
   	   	        
END
GO
