USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[sch_RevertExpireDeadTimeOutLicence]    Script Date: 4/24/2020 2:49:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Syed
-- Create date: 20-Dec-2012
-- Description:	Process each licence in dead timeout state. UC 08 Carlos
-- =============================================
ALTER PROCEDURE [dbo].[sch_RevertExpireDeadTimeOutLicence] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @LicenceNumber varchar(10),
		@PlateNumber INT,
		@LicenceTypeId INT,
		@Counter INT,
		@LicenceHolderId INT,
		@VehicleRegistrationNumber varchar(10),
		@RegistrationDate DATETIME,
		@LicenceExpiryDate DATETIME,
		@LetterRequestTypeId INT,
		@RequestId INT,
		@ModifiedDate DATETIME,
		@ErrorMessage varchar(4000),
		@LetterError varchar(4000)
		


--A counter of 5278 is set to prevent any infinite loops...		
SET @Counter = 1
SET @ModifiedDate = GETDATE()

WHILE (1 = 1 AND @Counter < 5278)
BEGIN
	SET @Counter = @Counter + 1
		
	SELECT	TOP 1	@LicenceNumber = L.LicenceNumber,
					@PlateNumber = PlateNumber,
					@LicenceTypeId = L.LicenceTypeId,
					@LicenceHolderId = L.LicenceHolderId,
					@VehicleRegistrationNumber = L.RegistrationNumber,
					@RegistrationDate = RegistrationDate,
					@LicenceExpiryDate = LicenceExpiryDate
	FROM dbo.LicenceMasterVL L
	INNER JOIN dbo.LicenceHolderMaster H ON H.LicenceHolderId = L.LicenceHolderId
	INNER JOIN dbo.VehicleMaster V ON V.RegistrationNumber = L.RegistrationNumber
	INNER JOIN dbo.LicenceType T on L.LicenceTypeId = T.LicenceTypeId
	WHERE L.licencestateid=14 and L.licencestatemasterid=6 and L.modifieddate>'01/30/2014'  and L.LicenceExpiryDate>=CONVERT(datetime,'12-31-2008')
		and L.LicenceExpiryDate<CONVERT(datetime,'1-31-2013') 
		
	--If none are found, stop
	IF @LicenceNumber IS NULL
	BEGIN
		BREAK
	END
	
	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		
		BEGIN TRANSACTION FINISH
			
		UPDATE dbo.LicenceMasterVL
		SET LicenceStateId = 8,
		LicenceStateMasterId=5,
		ModifiedBy = 'Helpdesk',
		ModifiedDate = @ModifiedDate,		
		HistoryChangeId = 22 -- Time out (Expired)
		WHERE LicenceNumber = @LicenceNumber
				
		EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber = @LicenceNumber, @ModifiedDate = @ModifiedDate, @ModifiedBy = 'helpdesk'
					
		SET @LicenceNumber = NULL
		
		COMMIT TRANSACTION FINISH
			
	END TRY

	BEGIN CATCH
	
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION FINISH
		END
			SET @ErrorMessage = ERROR_MESSAGE()
		
			Begin Try
			--Log the error
		
			INSERT INTO [dbo].[PrintEventLogs]
					(
						[Date],
						[Thread],
						[Level],
						[Logger],
						[Message],
						[Usr]
					)
			VALUES
					(
						@ModifiedDate,
						1,
						'ERROR',
						'revert expired',
						@ErrorMessage,
						'helpdesk'
					)
					
			End	Try
					
			BEGIN CATCH
					
			--Nothing to do if the Print Event Log fails
					
			END CATCH
		
		
		RAISERROR (@ErrorMessage, 16, 1);
			
		RETURN 0
		
	END CATCH
			
	CONTINUE
END


END


GO


