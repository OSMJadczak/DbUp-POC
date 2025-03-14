SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VehicleMaster_Update]

(
@RegistrationNumber varchar(10),
@VIN varchar(22),
@EngineCapacity smallint,
@TurboDieselYn bit,
@NumberPassengers tinyint,
@OccupancyWithWheelchair tinyint,
@NumberSeats tinyint,
@NumberDoors tinyint,
@YearOfManufacture smallint,
@RegistrationDateOrigin datetime,
@RegistrationDateIreland datetime,
@VrtVehicleCategory varchar(20),
@NctSerialNumber nvarchar(50),
@NctIssueDate smalldatetime,
@NctExpiryDate smalldatetime,
@LastDocumentationCheckDate datetime,
@InsuranceExpiryDate smalldatetime,
@InsuranceClassCorrect bit,
@TypeApprovalNumber varchar(50),
@TypeApprovalCategory varchar(50),
@PermissibleMassGvw int,
@SimiCode nvarchar(50),
@MileageReading int,
@ExcessWindowTint bit,
@ModifiedBy nvarchar(20),
@ModifiedDate datetime output,
@CreatedBy nvarchar(20),
@CreatedDate datetime,
@DataCheckedDate smalldatetime,
@HistoryChangeId int,
@MakeId int,
@ModelId int,
@BodyTypeId tinyint,
@FuelTypeId tinyint,
@ColourId tinyint,
@TestCenterId smallint,
@FinalOperationDate datetime,
@LicenceStateId int,
@LicenceStateMasterId int

)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SET @ModifiedDate = GETDATE()




UPDATE VehicleMaster

SET

RegistrationNumber = @RegistrationNumber,
MakeId = @MakeId,
ModelId = @ModelId,
BodyTypeId = @BodyTypeId,
FuelTypeId = @FuelTypeId,
ColourId = @ColourId,
TestCenterId = @TestCenterId,
VIN = @VIN,
EngineCapacity = @EngineCapacity,
TurboDieselYn = @TurboDieselYn,
NumberPassengers = @NumberPassengers,
OccupancyWithWheelchair = @OccupancyWithWheelchair,
NumberSeats = @NumberSeats,
NumberDoors = @NumberDoors,
YearOfManufacture = @YearOfManufacture,
RegistrationDateOrigin = @RegistrationDateOrigin,
RegistrationDateIreland = @RegistrationDateIreland,
VrtVehicleCategory = @VrtVehicleCategory,
NctSerialNumber = @NctSerialNumber,
NctIssueDate = @NctIssueDate,
NctExpiryDate = @NctExpiryDate,
LastDocumentationCheckDate = @LastDocumentationCheckDate,
InsuranceExpiryDate = @InsuranceExpiryDate,
InsuranceClassCorrect = @InsuranceClassCorrect,
TypeApprovalNumber = @TypeApprovalNumber,
TypeApprovalCategory = @TypeApprovalCategory,
PermissibleMassGvw = @PermissibleMassGvw,
SimiCode = @SimiCode,
MileageReading = @MileageReading,
ExcessWindowTint = @ExcessWindowTint,
CreatedBy = @CreatedBy,
ModifiedBy = @ModifiedBy,
ModifiedDate = @ModifiedDate,
CreatedDate = @CreatedDate,
DataCheckedDate = @DataCheckedDate,
HistoryChangeId = @HistoryChangeId

WHERE RegistrationNumber = @RegistrationNumber

UPDATE LicenceMasterVL 
SET
FinalOperationDate = @FinalOperationDate
WHERE RegistrationNumber = @RegistrationNumber and LicenceStateId is null and LicenceStateMasterId = @LicenceStateMasterId

END

GO
