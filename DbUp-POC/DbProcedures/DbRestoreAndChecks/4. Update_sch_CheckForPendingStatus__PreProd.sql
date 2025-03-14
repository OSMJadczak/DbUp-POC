USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[sch_CheckForPendingStatus]    Script Date: 7/4/2017 2:40:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Artur Ziemianski
-- Create date: 16.03.2017
-- Description:	Check if there are bookings stuck in pending status for more than 30 minutes
-- Previous Distribution List : --'elizabeth.heggs@nationaltransport.ie;ie.ops.nta@sgs.com;caroline.oleary@sgs.com;joseph.loughnane@sgs.com;deirdre.macnamara@sgs.com;Aine.Griffin@sgs.com;aoife.smyth@sgs.com', 
-- =============================================
ALTER PROCEDURE [dbo].[sch_CheckForPendingStatus] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @LicenceNumber varchar(10),
		@mailbody nvarchar(max),
		@count int,
		@skillsCount int,
		@bookingId int
		


select @skillsCount = COUNT(*) from cabs_sk.Booking b
where b.StatusID = 8 and DATEDIFF(minute, b.ModifiedOn, getdate()) > 10	
	
if @skillsCount = 0
begin
	return
end
		
set @mailbody = 'There are bookings with pending status:<br/> <br/>'
 			


DECLARE db_skillsCursor CURSOR FOR 
--Needs to be modified when mailbody will be known
select b.ID from cabs_sk.Booking b
where b.StatusId = 8 and DATEDIFF(minute, b.ModifiedOn, getdate()) > 10

	
OPEN db_skillsCursor   

FETCH NEXT FROM db_skillsCursor INTO @bookingId
WHILE @@FETCH_STATUS = 0
BEGIN
    --Needs to be modified when mailbody will be known
	set @mailbody +='* Booking ' +convert(nvarchar(10), @bookingId)+ ': https://cabsvlpreprod.nationaltransport.ie/Sk/ <br/>'
	FETCH NEXT FROM db_skillsCursor  INTO @bookingId
END
CLOSE db_skillsCursor 
DEALLOCATE db_skillsCursor 



--send email
 exec msdb.dbo.sp_send_dbmail 
 @profile_name                  = 'CABS',        
   @recipients                  = 'anosal@openskydata.com;Sarah.colclough@nationaltransport.ie;Elizabeth.heggs@nationaltransport.ie',
   @copy_recipients             = NULL,
   @blind_copy_recipients       = NULL,
   @subject                   = 'PreProd - Bookings in pending status',
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

		
END

GO


