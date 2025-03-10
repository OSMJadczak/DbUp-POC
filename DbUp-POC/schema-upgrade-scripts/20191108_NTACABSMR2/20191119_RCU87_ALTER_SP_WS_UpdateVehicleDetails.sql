USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[WS_UpdateVehicleDetails]    Script Date: 19.11.2019 14:05:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Dan Rusu
-- Create date: 25.01.2011
-- Change Author: Aleksey Naliviako
-- Change date: 2013.10.24
-- Change reason: Added condition logic for opening transaction (IF @@TRANCOUNT..)
-- Description:	<Description,,>
-- =============================================

ALTER PROCEDURE [dbo].[WS_UpdateVehicleDetails]
	@regNo nvarchar(20),
	@Body_Type_CD nvarchar(5),
	@Colour_CD nvarchar(5),
	@FuelType int,
	@ExcessWindowTint bit,
	@InsuranceExpiryDate datetime,
	@MeterSealed bit,
	@MileageReading int,
	@Model_CD nvarchar(5),
	@NumberDoors tinyint,
	@NumberPassengers tinyint,
	@NumberSeats tinyint,
	@RoofSignSticker bit,
	@user nvarchar(50),
	@historyChangeID int,
	@OdometerUnitID INT = NULL,
	@error nvarchar(500) output,
	@success bit output
AS
BEGIN

DECLARE @TranStarted bit
SET @TranStarted = 0

IF( @@TRANCOUNT = 0 )
BEGIN
    BEGIN TRANSACTION update_vehicle
    SET @TranStarted = 1
END
ELSE
    SET @TranStarted = 0

BEGIN TRY

declare @makeID int
declare @modelID int
declare @colorID tinyint
declare @bodyTypeID tinyint
declare @fuelTypeId int = @FuelType

select @makeID = MakeId from dbo.VehicleMaster where RegistrationNumber = @regNo
select @modelID = ModelId from dbo.VehicleModel where MakeId = @makeID and Model_CD = @Model_CD
select @colorID = ColourId from dbo.VehicleColour where Colour_CD = @Colour_CD
select @bodyTypeID = BodyTypeId  from dbo.VehicleBodyType where Body_Type_CD = @Body_Type_CD

-- update vehicle master record

update dbo.VehicleMaster set 
		BodyTypeId = @bodyTypeID,
		ColourId =  @colorID,
		FuelTypeId = @fuelTypeId,
		ExcessWindowTint = @ExcessWindowTint,
		InsuranceExpiryDate = @InsuranceExpiryDate,
		MeterSealed = @MeterSealed,
		MileageReading = @MileageReading,
		ModelId = @modelID,
		NumberDoors = @NumberDoors ,
		NumberPassengers = @NumberPassengers ,
		NumberSeats = @NumberSeats ,
		RoofSignSticker = @RoofSignSticker,
		ModifiedDate = getdate(),
		ModifiedBy = @user,
		HistoryChangeId	= @historyChangeID,
		OdometerUnitID = @OdometerUnitID
where RegistrationNumber = @regNo 

--insert  history record
INSERT INTO [dbo].[VehicleMasterAudit]
			([RegistrationNumber]
           ,[MakeId]
           ,[ModelId]
           ,[BodyTypeId]
           ,[FuelTypeId]
           ,[ColourId]
           ,[EngineCapacity]
           ,[VIN]
           ,[YearOfManufacture]
           ,[RegistrationDateIreland]
           ,[RegistrationDateOrigin]
           ,[TurboDieselYn]
           ,[TestCenterId]
           ,[NumberPassengers]
           ,[NumberSeats]
           ,[NumberDoors]
           ,[TypeApprovalNumber]
           ,[TypeApprovalCategory]
           ,[PermissibleMassGvw]
           ,[VrtVehicleCategory]
           ,[SimiCode]
           ,[NctSerialNumber]
           ,[NctIssueDate]
           ,[NctExpiryDate]
           ,[MileageReading]
           ,[ExcessWindowTint]
           ,[DataCheckedDate]
           ,[InsuranceExpiryDate]
           ,[InsuranceClassCorrect]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[CreatedDate]
           ,[ModifiedDate]
           ,[AuditDate]
           ,[HistoryChangeId]
           ,[RoofSignSticker]
           ,[MeterSealed]
           ,[OdometerUnitID])
SELECT [RegistrationNumber]
           ,[MakeId]
           ,[ModelId]
           ,[BodyTypeId]
           ,[FuelTypeId]
           ,[ColourId]
           ,[EngineCapacity]
           ,[VIN]
           ,[YearOfManufacture]
           ,[RegistrationDateIreland]
           ,[RegistrationDateOrigin]
           ,[TurboDieselYn]
           ,[TestCenterId]
           ,[NumberPassengers]
           ,[NumberSeats]
           ,[NumberDoors]
           ,[TypeApprovalNumber]
           ,[TypeApprovalCategory]
           ,[PermissibleMassGvw]
           ,[VrtVehicleCategory]
           ,[SimiCode]
           ,[NctSerialNumber]
           ,[NctIssueDate]
           ,[NctExpiryDate]
           ,[MileageReading]
           ,[ExcessWindowTint]
           ,[DataCheckedDate]
           ,[InsuranceExpiryDate]
           ,[InsuranceClassCorrect]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[CreatedDate]
           ,[ModifiedDate]
           ,getdate()
           ,[HistoryChangeId]
           ,[RoofSignSticker]
           ,[MeterSealed]
           ,[OdometerUnitID]
FROM dbo.VehicleMaster
WHERE RegistrationNumber = @regNo

set @success = 1 
set @error = ''

IF( @TranStarted = 1 )
BEGIN	
	SET @TranStarted = 0
	COMMIT TRANSACTION update_vehicle   
END

END TRY

BEGIN CATCH

set @success = 0 
set @error = ERROR_MESSAGE()

IF( @TranStarted = 1 )
BEGIN	
    SET @TranStarted = 0
    ROLLBACK TRANSACTION update_vehicle
END

END CATCH

END

GO


