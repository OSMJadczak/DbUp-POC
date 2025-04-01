SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VehicleMasterAudit_Insert]
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
@CreatedDate datetime,	
@ModifiedBy nvarchar(50),	
@ModifiedDate datetime
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO VehicleMasterAudit
(
RegistrationNumber,
MakeId,
ModelId,
BodyTypeId,
FuelTypeId,
ColourId,
EngineCapacity,
VIN,
YearOfManufacture,
RegistrationDateIreland,
RegistrationDateOrigin,
TurboDieselYn,
TestCenterId,
NumberPassengers,
OccupancyWithWheelchair,
NumberSeats,
NumberDoors,
TypeApprovalNumber,
TypeApprovalCategory,
PermissibleMassGvw,
VrtVehicleCategory,
SimiCode,
NctSerialNumber,
NctIssueDate,
NctExpiryDate,
LastDocumentationCheckDate,
MileageReading,
ExcessWindowTint,
DataCheckedDate,
InsuranceExpiryDate,
InsuranceClassCorrect,
CreatedBy,
ModifiedBy,
CreatedDate,
ModifiedDate,
AuditDate,
HistoryChangeId
)

VALUES
(
@RegistrationNumber,
@MakeId,
@ModelId,
@BodyTypeId,
@FuelTypeId,
@ColourId,
@EngineCapacity,
@VIN,
@YearOfManufacture,
@RegistrationDateIreland,
@RegistrationDateOrigin,
@TurboDieselYn,
@TestCenterId,
@NumberPassengers,
@OccupancyWithWheelchair,
@NumberSeats,
@NumberDoors,
@TypeApprovalNumber,
@TypeApprovalCategory,
@PermissibleMassGvw,
@VrtVehicleCategory,
@SimiCode,
@NctSerialNumber,
@NctIssueDate,
@NctExpiryDate,
@LastDocumentationCheckDate,
@MileageReading,
@ExcessWindowTint,
@DataCheckedDate,
@InsuranceExpiryDate,
@InsuranceClassCorrect,
@CreatedBy,
@ModifiedBy,
@CreatedDate,
@ModifiedDate,
GETDATE(),
@HistoryChangeId
)

END

GO
