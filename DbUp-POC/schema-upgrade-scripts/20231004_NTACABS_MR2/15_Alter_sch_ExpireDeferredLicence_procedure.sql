SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Damien Dennehy
-- Create date: 19-Apr-2011
-- Description:	Process each licence in deferred state.
-- =============================================
ALTER PROCEDURE [dbo].[sch_ExpireDeferredLicence] 
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
		


--A counter of 2000 is set to prevent any infinite loops...		
SET @Counter = 1
SET @ModifiedDate = GETDATE()

WHILE (1 = 1 AND @Counter < 2000)
BEGIN
	SET @Counter = @Counter + 1
		
	SELECT	TOP 1	@LicenceNumber = L.LicenceNumber,
					@PlateNumber = L.PlateNumber,
					@LicenceTypeId = L.LicenceTypeId,
					@LicenceHolderId = L.LicenceHolderId,
					@VehicleRegistrationNumber = L.RegistrationNumber,
					@RegistrationDate = RegistrationDate,
					@LicenceExpiryDate = L.LicenceExpiryDate
					FROM dbo.LicenceMasterVL L   
	INNER JOIN dbo.LicenceHolderMaster H ON H.LicenceHolderId = L.LicenceHolderId
    INNER JOIN dbo.VehicleMaster V ON V.RegistrationNumber = L.RegistrationNumber	
    WHERE L.LicenceStateMasterId = 5
    AND L.LicenceStateId = 9
    AND L.LicenceNumber in
    (
	Select top 1 LA.LicenceNumber from  LicenceMasterVLAudit LA
    Where LA.LicenceStateId=9
    AND LA.LicenceStateMasterId=5
    AND L.LicenceNumber=LA.LicenceNumber
    AND LA.ModifiedBy='System'
    AND
    (
		(
		LA.HistoryChangeID=11 
		AND DATEDIFF(DAY, LA.AuditDate, GETDATE()) > 30
		)
		OR
		(LA.HistoryChangeID=59 --suspend end
		AND DATEDIFF(DAY, LA.AuditDate, GETDATE()) - DATEDIFF(day, L.SuspensionEndDate, L.SuspensionStartDate) > 30
		)
	)
    order by LA.Id desc
	)
			
	--If none are found, stop
	IF @LicenceNumber IS NULL
	BEGIN
		BREAK
	END
	
	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

		BEGIN TRANSACTION FINISH

		-- update just Expiry date for printing purposes
		UPDATE dbo.LicenceMasterVL
		SET LicenceExpiryDate = GETDATE()
		WHERE LicenceNumber = @LicenceNumber

        -- Generate LRA - CONFIRMATION OF LICENCE EXPIRY letter
		exec USP_DWH_PrintRequestVL_Insert
		@PrintRequestId = @RequestId OUTPUT,
		@LicenceNumber = @LicenceNumber,
		@LicenceHolderId = @LicenceHolderId,
		@NewLicenceHolderId = null,
		@PreviousLicenceHolderId = null,
		@VehicleRegistrationNumber = @VehicleRegistrationNumber,
		@NewVehicleRegistrationNumber = null,
		@PreviousVehicleRegistrationNumber = null,
		@BookingId = null,
		@PaymentId = null,
		@PrintRequestReasonId = 1,
		@LetterRequestTypeId = 8,
		@CreatedBy = 'System'	

		IF @RequestId IS NULL
		BEGIN
			SET @LetterError = 'Unable to generate licence expiry letter for licence # ' + @LicenceNumber
			Raiserror (@LetterError, 16, 1)
		END	
		
		UPDATE dbo.LicenceMasterVL
		SET LicenceStateId = 8,
		ModifiedBy = 'System',
		ModifiedDate = @ModifiedDate,
		LicenceExpiryDate = GETDATE(),
		HistoryChangeId = 24 -- Time Out Deferred
		WHERE LicenceNumber = @LicenceNumber

        EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber = @LicenceNumber, @ModifiedDate = @ModifiedDate
		
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
						'sch_LetterVL_ExpireDeferredLicence',
						@ErrorMessage,
						'System'
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
