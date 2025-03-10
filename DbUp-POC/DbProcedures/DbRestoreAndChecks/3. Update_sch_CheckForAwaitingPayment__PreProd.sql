USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[sch_CheckForAwaitingPayment]    Script Date: 12/10/2016 17:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Dan Rusu
-- Create date: 17-Jun-2011
-- Description:	Check if there are bookings stuck in awaiting payment status for more than 30 minutes
-- Previous Distribution List : --'elizabeth.heggs@nationaltransport.ie;ie.ops.nta@sgs.com;caroline.oleary@sgs.com;joseph.loughnane@sgs.com;deirdre.macnamara@sgs.com;Aine.Griffin@sgs.com;aoife.smyth@sgs.com', 
-- =============================================
AlTER PROCEDURE [dbo].[sch_CheckForAwaitingPayment] 
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
		
select @count = COUNT(*) from dbo.Booking b
where b.BookingStatusId = 1 and DATEDIFF(minute, b.ModifiedDate, getdate()) > 10	

select @skillsCount = COUNT(*) from cabs_sk.Booking b
where b.StatusID = 1 and DATEDIFF(minute, b.ModifiedOn, getdate()) > 10	
	
if @count = 0 and @skillsCount =0
begin
	return
end
		
set @mailbody = 'There are bookings with awaiting payment status:<br/> <br/>'
 		
DECLARE db_cursor CURSOR FOR 
select b.LicenceNumber from dbo.Booking b
where b.BookingStatusId = 1 and DATEDIFF(minute, b.ModifiedDate, getdate()) > 10

	
OPEN db_cursor   

FETCH NEXT FROM db_cursor INTO @LicenceNumber
WHILE @@FETCH_STATUS = 0
BEGIN
	set @mailbody += '* License '+@LicenceNumber+' : https://cabsvlpreprod.nationaltransport.ie/Sections/VehicleLicencing/DashBoard/Default.aspx?LicenceNumber=' + @LicenceNumber + '<br/>'
	FETCH NEXT FROM db_cursor INTO @LicenceNumber
END
CLOSE db_cursor
DEALLOCATE db_cursor


DECLARE db_skillsCursor CURSOR FOR 
--Needs to be modified when mailbody will be known
select b.ID from cabs_sk.Booking b
where b.StatusId = 1 and DATEDIFF(minute, b.ModifiedOn, getdate()) > 10

	
OPEN db_skillsCursor   

FETCH NEXT FROM db_skillsCursor INTO @bookingId
WHILE @@FETCH_STATUS = 0
BEGIN
    --Needs to be modified when mailbody will be known
	set @mailbody +='* Booking' +convert(nvarchar(10), @bookingId)+ ': https://cabsvlpreprod.nationaltransport.ie//Sk/????' +convert(nvarchar(10), @bookingId)+' <br/>'
	FETCH NEXT FROM db_skillsCursor  INTO @bookingId
END
CLOSE db_skillsCursor 
DEALLOCATE db_skillsCursor 

--send email
 exec msdb.dbo.sp_send_dbmail 
 @profile_name                  = 'CABS',        
  -- @recipients                  = 'elizabeth.heggs@nationaltransport.ie;ie.ops.nta@sgs.com;caroline.oleary@sgs.com;Alison.Keane@sgs.com;Sharon.Conneely@sgs.com;Aine.Griffin@sgs.com;Laura.lyons@sgs.com',    
   @recipients                    = 'anosal@openskydata.com;elizabeth.heggs@nationaltransport.ie;Sarah.colclough@nationaltransport.ie',
   @copy_recipients             = NULL,
   @blind_copy_recipients       = NULL,
   @subject                   = 'PreProd - Bookings in awaiting payment status',
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


