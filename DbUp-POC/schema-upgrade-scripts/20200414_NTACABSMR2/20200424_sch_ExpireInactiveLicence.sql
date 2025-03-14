USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[sch_ExpireInactiveLicence]    Script Date: 4/24/2020 2:30:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sch_ExpireInactiveLicence] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @LicenceNumber varchar(10),
		@PlateNumber INT,
		@BookingID INT,
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
	WHERE LicenceStateMasterId = 5 --inactive
	AND ( 
		(LicenceExpiryDate>=CONVERT(datetime,'1-1-2013') and DATEADD(year, 1,LicenceExpiryDate) < @modifiedDate) --rule 1
		OR
		(LicenceExpiryDate<CONVERT(datetime,'1-1-2013') and LicenceExpiryDate>=CONVERT(datetime,'12-31-2008') and @modifiedDate>CONVERT(datetime,'12/31/2013')) --rule 2
		OR
		(LicenceExpiryDate<CONVERT(datetime,'12-31-2008') and DATEADD(year,5,LicenceExpiryDate) < @modifiedDate ) --rule 3
		)
		
	--If none are found, stop
	IF @LicenceNumber IS NULL
	BEGIN
		BREAK
	END
	
	SELECT TOP 1 @BookingID = dbo.Booking.BookingID 
	FROM dbo.Booking
	INNER JOIN dbo.VehicleInspections on dbo.VehicleInspections.BookingID = dbo.Booking.BookingID
	WHERE dbo.Booking.LicenceNumber = @LicenceNumber
	AND dbo.Booking.BookingStatusID = 3 --Completed
	AND dbo.VehicleInspections.TestResultID = 2 --Failed
	AND DATEDIFF(Day, dbo.Booking.CreatedDate, GETDATE()) < 90
	ORDER BY dbo.Booking.CreatedDate DESC
	
	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

		BEGIN TRANSACTION FINISH

		UPDATE dbo.LicenceMasterVL
		SET LicenceStateMasterId = 6, -- dead
		LicenceStateId = 14, -- time out
		ModifiedBy = 'System',
		ModifiedDate = @ModifiedDate,
		HistoryChangeId = 22 -- Time Out Expired
		WHERE LicenceNumber = @LicenceNumber
				
        EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber = @LicenceNumber, @ModifiedDate = @ModifiedDate
					
		--Also cancel/refund any open bookings in the system that have not been cancelled
		IF @BookingID IS NOT NULL
		BEGIN
				EXEC [Booking_CancelAndRefund] 
				@LicenceNumber = @LicenceNumber, 
				@RefundId = null, 
				@BookingId = @BookingID, 
				@RefundReasonId = 2, --System Refund
				@BookingCancellationReasonId = 4, --Late Cancellation 
				@ProcessExpiration = 0, 
				@Username = 'System (Exp Lic.)'
		END

		SET @LicenceNumber = NULL
		SET @BookingID = NULL
		
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
						'sch_ExpireInactiveLicence',
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

------------------*********************END HERE*************************----------------------------



GO


