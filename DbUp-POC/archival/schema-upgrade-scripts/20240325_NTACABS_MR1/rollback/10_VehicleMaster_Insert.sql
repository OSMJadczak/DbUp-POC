SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VehicleMaster_Insert]
	-- Add the parameters for the stored procedure here

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
@DataCheckedDate smalldatetime,
@HistoryChangeId tinyint,
@MakeId int,
@ModelId int,
@BodyTypeId tinyint,
@FuelTypeId tinyint,
@ColourId tinyint,
@TestCenterId smallint,
@CreatedBy nvarchar(50),	
@CreatedDate datetime output,	
@ModifiedBy nvarchar(50),	
@ModifiedDate datetime output
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SET @CreatedDate = GETDATE()
SET @ModifiedDate = @CreatedDate

INSERT INTO VehicleMaster
(
RegistrationNumber,
MakeId,
ModelId,
BodyTypeId,
FuelTypeId,
ColourId,
TestCenterId,
VIN,
EngineCapacity,
TurboDieselYn,
NumberPassengers,
OccupancyWithWheelchair,
NumberSeats,
NumberDoors,
YearOfManufacture,
RegistrationDateOrigin,
RegistrationDateIreland,
VrtVehicleCategory,
NctSerialNumber,
NctIssueDate,
NctExpiryDate,
LastDocumentationCheckDate,
InsuranceExpiryDate,
InsuranceClassCorrect,
TypeApprovalNumber,
TypeApprovalCategory,
PermissibleMassGvw,
SimiCode,
MileageReading,
ExcessWindowTint,
CreatedBy,
ModifiedBy,
CreatedDate,
ModifiedDate
)

VALUES
(
RTRIM(@RegistrationNumber),
@MakeId,
@ModelId,
@BodyTypeId,
@FuelTypeId,
@ColourId,
@TestCenterId,
@VIN,
@EngineCapacity,
@TurboDieselYn,
@NumberPassengers,
@OccupancyWithWheelchair,
@NumberSeats,
@NumberDoors,
@YearOfManufacture,
@RegistrationDateOrigin,
@RegistrationDateIreland,
@VrtVehicleCategory,
@NctSerialNumber,
@NctIssueDate,
@NctExpiryDate,
@LastDocumentationCheckDate,
@InsuranceExpiryDate,
@InsuranceClassCorrect,
@TypeApprovalNumber,
@TypeApprovalCategory,
@PermissibleMassGvw,
@SimiCode,
@MileageReading,
@ExcessWindowTint,
@CreatedBy,
@ModifiedBy,
@CreatedDate,
@ModifiedDate
)

END

GO
