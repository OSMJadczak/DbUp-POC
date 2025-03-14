USE [DataMarshaller]
GO
/****** Object:  StoredProcedure [marshaller].[sch_CheckDataMarshallerJob]    Script Date: 3/25/2020 11:11:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Adam Nosal
-- Create date: 25-Mar-2019
-- Description:	Job checks if Data marshaller is running on time 
--
--
-- =============================================
 ALTER PROCEDURE [marshaller].[sch_CheckDataMarshallerJob] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	declare @mailbody nvarchar(max),
	 @lastRun datetime,
	 @isRun int,
	 @getDate datetime, 
	 @recordsToUpdate int ;
	

	SELECT  @lastRun= [SynchronizationProcess].Timestamp ,
	@isRun = IsRun,
	@getDate = getDate(),
	@recordsToUpdate = (SELECT count(*) FROM [DataMarshaller].[marshaller].[SynchronizationIds] with (nolock))
	FROM [DataMarshaller].[marshaller].[SynchronizationProcess] with (nolock) 

	
	IF (DATEDIFF(s,@lastRun,@getDate)>=900)
begin 

set @mailbody = 'Data Marshaller process was interupted : <br/> <br/>';

set @mailbody += 'Check time :  ';
set @mailbody += cast(@getDate as nvarchar(40));
set @mailbody += '<br/> <br/>';
set @mailbody += 'Last run time :  ';
set @mailbody += cast(@lastRun as nvarchar(40));
set @mailbody += '<br/> <br/>';
set @mailbody += 'IsRun :  ';
set @mailbody +=  cast(@isRun as nvarchar(2));
set @mailbody += '<br/> <br/>';
set @mailbody += 'Records to update  :  ';
set @mailbody += cast(@recordsToUpdate as nvarchar(40));
set @mailbody += '<br/> <br/> <br/> <br/>';

set @mailbody += 'Sincerly, <br/> Your Humble DataMarshallerCheck Job <br/> ';



--send email
 exec msdb.dbo.sp_send_dbmail 
 @profile_name                  = 'CABS',        
  -- @recipients                  = 'rpodgorski@openskydata.com;anosal@openskydata.com',
   @recipients                    = 'rpodgorski@openskydata.com;anosal@openskydata.com;kbyrne@openkydata.com;vbrahmbhatt@openskydata.com',
   @copy_recipients             = NULL,
   @blind_copy_recipients       = NULL,
   @subject                   = 'Data Marshaller FAIL - PREPRODUCTION',
   @body                       = @mailbody, 
   @body_format                = 'HTML', 
   @importance                  = 'NORMAL',
   @sensitivity                 = 'NORMAL',
   @file_attachments          = NULL,  
   @query                       = NULL,
   @execute_query_database          = NULL,  
   @attach_query_result_as_file           = 0,
   @query_attachment_filename   = NULL,  
   @query_result_header                  = 1,
   @query_result_width                    = 256,            
   @query_result_separator            = ' ',
   @exclude_query_output                  = 0,
   @append_query_error                    = 0,
   @query_no_truncate                     = 0,
   @query_result_no_padding               = 0,
   @mailitem_id                           = NULL,
   @from_address                 = NULL,
   @reply_to                     = NULL

   end 



		
END
