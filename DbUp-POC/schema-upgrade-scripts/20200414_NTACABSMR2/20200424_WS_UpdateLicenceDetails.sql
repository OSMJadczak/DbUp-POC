USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[WS_UpdateLicenceDetails]    Script Date: 4/24/2020 2:55:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[WS_UpdateLicenceDetails]
	@regNo NVARCHAR (20), 
	@Body_Type_CD NVARCHAR (5), 
	@Colour_CD NVARCHAR (5), 
	@FuelType int,
	@ExcessWindowTint BIT, 
	@InsuranceExpiryDate DATETIME, 
	@MeterSealed BIT, 
	@MileageReading INT, 
	@Model_CD NVARCHAR (5), 
	@NumberDoors TINYINT, 
	@NumberPassengers TINYINT, 
	@NumberSeats TINYINT, 
	@RoofSignSticker BIT, 
	@user NVARCHAR (50), 
	@historyChangeID INT, 
	@inspectionID INT, 
	@LicenceNumber NVARCHAR (20), 
	@TestCentreId INT, 
	@BookingId INT, 
	@InspectorId INT, 
	@TestStartTime DATETIME, 
	@TestEndTime DATETIME, 
	@TestResultId INT, 
	@Comment NVARCHAR (2000), 
	@licenceIssueDate DATETIME, 
	@licenceExpiryDate DATETIME, 
	@statusActiveId INT, 
	@remainingTransfers INT, 
	@transferDate DATETIME, 
	@OdometerUnitID INT = NULL,	
	@TamperProofPrinted BIT = NULL,
	@LettersProcessed BIT = NULL,
	@LettersProcessDate DATETIME = NULL,
	@TPRemoved BIT = NULL,
	@TPDestroyed BIT = NULL,
	@TPComment NVARCHAR(500) = NULL,
	@TPReasonID INT = NULL,
	@LateArrivalTime DATETIME = NULL,
	@LateArrivalReasonID INT = NULL,
	@currentSystemProcessId tinyint = 0,	
	@error NVARCHAR (4000) OUTPUT, 
	@success BIT OUTPUT	
	
AS
BEGIN

	DECLARE @TranStarted bit
	SET @TranStarted = 0
	IF( @@TRANCOUNT = 0 )
	BEGIN
		BEGIN TRANSACTION
		SET @TranStarted = 1
	END
	ELSE
		SET @TranStarted = 0

    BEGIN TRY        
        
        DECLARE @now AS DATETIME, @RequestId AS INT, @DeferralLicenceHolderId AS INT;
        SET @now = getdate();
        --find old reg field
        DECLARE @oldReg AS NVARCHAR (10);
        
        SELECT @oldReg = RegistrationNumber
        FROM   dbo.LicenceMasterVL
        WHERE  LicenceNumber = @LicenceNumber;
        IF @oldReg = @regNo
            BEGIN
                SET @oldReg = NULL;
            END
            
        --find licence holderID
        DECLARE @holderID AS INT;
        SELECT @holderID = NewLicenceHolderId
        FROM   dbo.Booking
        WHERE  BookingId = @BookingId;
        IF @holderID IS NULL
            BEGIN
                SELECT @holderID = LicenceHolderId
                FROM   dbo.LicenceMasterVL
                WHERE  LicenceNumber = @LicenceNumber;
            END
            
  --Get Final Operation Date of against LicenceTypeID
  DECLARE @LicenceTypeID  tinyint  = (Select licencetypeid from dbo.LicenceMasterVL where LicenceNumber=@LicenceNumber);
  IF (@currentSystemProcessId = (select TOP 1 SystemProcessId from dbo.SystemProcessVL WHERE ProcessName = 'Exchange')) -- IF PROCESS IS EXCHANGE LICENCETYPE WILL CHANGE
	BEGIN
			IF(@LicenceTypeId = 1 ) -- TAXI
				BEGIN
					Set @LicenceTypeId = 4
				END
			ELSE IF (@LicenceTypeId = 4) -- WHEELCHAIR ACCESSIBLE TAXI
				BEGIN
					Set @LicenceTypeId = 1
				END
	END
	
  DECLARE @plateNumber  int  = (Select PlateNumber from dbo.LicenceMasterVL where LicenceNumber=@LicenceNumber); 
  DECLARE @finalOperationDate datetime = dbo.LicenceMasterVL_GetFinalOperationDate(@plateNumber,@regNo, @LicenceTypeId, @currentSystemProcessId)

  DECLARE @licenceStateId INT
  SET @licenceStateId = NULL
    
--If Booking has been confirmed for 'Inactive-Suspended' type of licence so licence should stay in inactive-suspended status during Inspection.
-- Expiry dates should be updated according to standard rules.
--*********************************************** Inactive Suspended Inspection **************************************************
	   IF (EXISTS (Select top 1 LMV.LicenceNumber from dbo.LicenceMasterVL LMV Where LMV.LicenceNumber=@LicenceNumber AND LMV.LicenceStateId=11 AND LMV.LicenceStateMasterId=5))
			BEGIN
				Set @statusActiveId = 5   ---Inactive
				Set @licenceStateId = 11 ---Suspended				
			END		
--*********************************************** Inactive Suspended Inspection **************************************************


	    --update licence table
        UPDATE  dbo.LicenceMasterVL
            SET LicenceHolderId      = @holderID,
                RegistrationNumber   = @regNo,
                LicenceStateMasterId = @statusActiveId,
                LicenceStateId       = @licenceStateId,
                LicenceExpiryDate    = @licenceExpiryDate,
                LicenceIssueDate     = @licenceIssueDate,
                RenewalDate          = @TestStartTime,
                TransferedFromReg    = @oldReg,
                HistoryChangeId      = @historyChangeID,
                TestCenterId         = @TestCentreId,
                RemainingTransfers   = isnull(RemainingTransfers - @remainingTransfers, RemainingTransfers),
                TransferDate         = isnull(@transferDate, TransferDate),
                ModifiedBy           = @user,
                ModifiedDate         = @now,
				FinalOperationDate   =@finalOperationDate
        WHERE   LicenceNumber = @LicenceNumber;
        --add licence history item
        EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber = @LicenceNumber, @ModifiedDate = @now
        
        --*********************************************** handle inspection **************************************************
        INSERT  INTO [dbo].[VehicleInspections] 
				(VehicleInspectionId, 
				[RegistrationNumber], 
				[LicenceNumber], 
				[TestCentreId], 
				[BookingId], 
				[InspectorId], 
				[TestStartTime], 
				[TestEndTime], 
				[TestResultId], 
				[Comment], 
				[CreatedBy], 
				[CreatedDate], 
				[ModifiedBy], 
				[ModifiedDate],				
				TamperProofPrinted,
				LettersProcessed,
				LettersProcessDate,
				TPRemoved,
				TPDestroyed,
				TPComment,
				TPReasonID,
				LateArrivalTime,
				LateArrivalReasonID)
        VALUES (
				@inspectionID, 
				@regNo, 
				@LicenceNumber, 
				@TestCentreId, 
				@BookingId, 
				@InspectorId, 
				@TestStartTime, 
				@TestEndTime, 
				@TestResultId, 
				@Comment, 
				@user, 
				@now, 
				@user, 
				@now,				
				@TamperProofPrinted,
				@LettersProcessed,
				@LettersProcessDate,
				@TPRemoved,
				@TPDestroyed,
				@TPComment,
				@TPReasonID,
				@LateArrivalTime,
				@LateArrivalReasonID);
        --**************************************************** handle vehicle  ************************************************
       
	   --*********************************************** handle nominee **************************************************
	   IF (EXISTS (Select * from dbo.VehicleInspections vi join dbo.Booking b ON vi.BookingId=b.BookingId Where vi.BookingId=@BookingId AND vi.TestResultId=1
						AND (b.SystemProcessId in (19,21) OR (b.SystemProcessId in (23,24) AND b.NewLicenceHolderId is not null))))
			BEGIN
				Update dbo.LicenceNominee Set EndDate=GetDate(),ModifiedBy=@user,ModifiedDate=@now Where (LicenceNumber=@LicenceNumber AND EndDate is NUll)
			END
		--*********************************************** handle nominee **************************************************


        -- declare variables        
        DECLARE @makeID AS INT;
        DECLARE @modelID AS INT;
        DECLARE @colorID AS TINYINT;
		declare @fuelTypeID int = @FuelType
        DECLARE @bodyTypeID AS TINYINT;
        --get makeID
        SELECT @makeID = MakeId
        FROM   dbo.VehicleMaster
        WHERE  RegistrationNumber = @regNo;
        -- get proper modelID
        SELECT @modelID = ModelId
        FROM   dbo.VehicleModel
        WHERE  MakeId = @makeID
               AND Model_CD = @Model_CD;
        -- get proper colorID
        SELECT @colorID = ColourId
        FROM   dbo.VehicleColour
        WHERE  Colour_CD = @Colour_CD;
        --get proper bodyTypeID
        SELECT @bodyTypeID = BodyTypeId
        FROM   dbo.VehicleBodyType
        WHERE  Body_Type_CD = @Body_Type_CD;
        -- update vehicle master record
        UPDATE  dbo.VehicleMaster
            SET BodyTypeId          = @bodyTypeID,
				FuelTypeId          = @fuelTypeID,
                ColourId            = @colorID,
                ExcessWindowTint    = @ExcessWindowTint,
                InsuranceExpiryDate = @InsuranceExpiryDate,
                MeterSealed         = @MeterSealed,
                MileageReading      = @MileageReading,
                ModelId             = @modelID,
                NumberDoors         = @NumberDoors,
                NumberPassengers    = @NumberPassengers,
                NumberSeats         = @NumberSeats,
                RoofSignSticker     = @RoofSignSticker,
                ModifiedDate        = @now,
                ModifiedBy          = @user,
                HistoryChangeId     = @historyChangeID,
                TestCenterId        = @TestCentreId,
                OdometerUnitID		= @OdometerUnitID                
        WHERE   RegistrationNumber = @regNo;
        --insert  history record
        INSERT INTO [dbo].[VehicleMasterAudit] ([RegistrationNumber], [MakeId], [ModelId], [BodyTypeId], [FuelTypeId], [ColourId], [EngineCapacity], [VIN], [YearOfManufacture], [RegistrationDateIreland], [RegistrationDateOrigin], [TurboDieselYn], [TestCenterId], [NumberPassengers], [NumberSeats], [NumberDoors], [TypeApprovalNumber], [TypeApprovalCategory], [PermissibleMassGvw], [VrtVehicleCategory], [SimiCode], [NctSerialNumber], [NctIssueDate], [NctExpiryDate], [MileageReading], [ExcessWindowTint], [DataCheckedDate], [InsuranceExpiryDate], [InsuranceClassCorrect], [CreatedBy], [ModifiedBy], [CreatedDate], [ModifiedDate], [AuditDate], [HistoryChangeId], [RoofSignSticker], [MeterSealed], [OdometerUnitID])
        SELECT [RegistrationNumber],
               [MakeId],
               [ModelId],
               [BodyTypeId],
               [FuelTypeId],
               [ColourId],
               [EngineCapacity],
               [VIN],
               [YearOfManufacture],
               [RegistrationDateIreland],
               [RegistrationDateOrigin],
               [TurboDieselYn],
               [TestCenterId],
               [NumberPassengers],
               [NumberSeats],
               [NumberDoors],
               [TypeApprovalNumber],
               [TypeApprovalCategory],
               [PermissibleMassGvw],
               [VrtVehicleCategory],
               [SimiCode],
               [NctSerialNumber],
               [NctIssueDate],
               [NctExpiryDate],
               [MileageReading],
               [ExcessWindowTint],
               [DataCheckedDate],
               [InsuranceExpiryDate],
               [InsuranceClassCorrect],
               [CreatedBy],
               [ModifiedBy],
               [CreatedDate],
               [ModifiedDate],
               @now,
               [HistoryChangeId],
               [RoofSignSticker],
               [MeterSealed],
               [OdometerUnitID]
        FROM   dbo.VehicleMaster
        WHERE  RegistrationNumber = @regNo;
        UPDATE  dbo.Booking
            SET BookingStatusId = 3
        WHERE   BookingId = @BookingId;
        -----------------------------------deferals--------------------------------------
        IF 1 = 1
            BEGIN
                DECLARE @defLicenceNumber AS VARCHAR (10), @Counter AS INT;				
                SELECT TOP 1 @defLicenceNumber = l.LicenceNumber,
                             @DeferralLicenceHolderId = l.LicenceHolderId,
							 @licenceStateId = l.LicenceStateId
                FROM   dbo.LicenceMasterVL AS l
                WHERE  l.RegistrationNumber = @regNo
                       AND l.LicenceNumber <> @LicenceNumber
                       AND (l.LicenceStateMasterId = 4 OR (l.LicenceStateId=11 AND l.LicenceStateMasterId=5));

				 
				IF (@licenceStateId IS NULL OR @licenceStateId <> 11)
					BEGIN
						Set @licenceStateId = 9 ----DEFERRED
					END

                IF @defLicenceNumber IS NOT NULL
                    BEGIN
                        --update licence
                        UPDATE  dbo.LicenceMasterVL
                            SET LicenceStateMasterId = 5,
                                LicenceStateId       = @licenceStateId,  
                                ModifiedBy           = 'System',
                                ModifiedDate         = @now,
                                HistoryChangeId      = 11 -- Deferred
                        WHERE   LicenceNumber = @defLicenceNumber;
                        --create audit record
                        EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber =  @defLicenceNumber, @ModifiedDate = @now
                        --Issue a deferral letter
                        SET @RequestId = NULL;
                        EXECUTE USP_DWH_PrintRequestVL_Insert @PrintRequestId = @RequestId OUTPUT, @LicenceNumber = @defLicenceNumber, @LicenceHolderId = @DeferralLicenceHolderId, @NewLicenceHolderId = NULL, @PreviousLicenceHolderId = NULL, @VehicleRegistrationNumber = @regNo, @NewVehicleRegistrationNumber = NULL, @PreviousVehicleRegistrationNumber = NULL, @BookingId = NULL, @PaymentId = NULL, @PrintRequestReasonId = 1, @LetterRequestTypeId = 15, @CreatedBy = 'System';
                        IF @RequestId IS NULL
                            BEGIN
                                INSERT  INTO [dbo].[PrintEventLogs] ([Date], [Thread], [Level], [Logger], [Message], [Usr])
                                VALUES                             (@now, 1, 'ERROR', 'WS_UpdateLicenceDetails', 'failled to create deferal letter for reg: ' + @regNo, 'System');
                            END
                    END
            END
        -----------------------------------end deferals--------------------------------------
        SET @success = 1;
        SET @error = '';
        
        IF( @TranStarted = 1 )
		BEGIN	
			SET @TranStarted = 0
			COMMIT TRANSACTION    
		END
        
    END TRY
    BEGIN CATCH    
        SET @success = 0;
        SET @error = ERROR_MESSAGE() + '; line: ' + CONVERT (NVARCHAR, ERROR_LINE());  
              
		IF( @TranStarted = 1 )
		BEGIN	
			SET @TranStarted = 0
			ROLLBACK TRANSACTION    
		END        
    END CATCH
END


GO


