USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[LicenceMasterVL_Insert]    Script Date: 8/18/2021 12:16:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceMasterVL_Insert]
    @PlateNumber int output,
    @LicenceNumber varchar (50) output,
    @LicenceHolderId int,
    @RegistrationNumber varchar (10),
    @LicenceTypeId tinyint,
    @LicenceStateId tinyint,
    @LicenceStateMasterId tinyint,
    @LicenceExpiryDate smalldatetime,
    @LicenceIssueDate smalldatetime,
    @CoExpiryDate smalldatetime,
    @CoIssueDate smalldatetime,
    @RenewalDate smalldatetime,
    @TransferedFromReg varchar (50),
    @HistoryChangeId  tinyint,
    @TestCenterId smallint,
    @RemainingTransfers int,
    @TransferDate smalldatetime,
    @OldPlateNumber varchar (50),
    @OldLicenceAuthority varchar (50),
    @CreatedBy nvarchar(50),
    @CreatedDate datetime output,
    @ModifiedBy nvarchar(50),
    @ModifiedDate datetime output,
	@LAHArea nvarchar(50),
	@MotorTaxRebateStatusId int,
	@MotorTaxRebateDate smalldatetime
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
SET NOCOUNT ON;

DECLARE @LicenceTypeShortCode varchar(1)

SELECT @LicenceTypeShortCode = LicenceTypeShortCode
FROM dbo.LicenceType
WHERE LicenceTypeId = @LicenceTypeId

SET @PlateNumber = (SELECT Max(PlateNumber) FROM LicenceMasterVL)
SET @PlateNumber = coalesce(@PlateNumber, 0) + 1

--For all new licences, set the system to generate sequential licence numbers starting from 50,000. 
--VLS Quarterly Release March 2014: BAU49
/*IF EXISTS (Select PlateNumber from LicenceMasterVL where PlateNumber=50000)
	BEGIN 
		SET @PlateNumber = (SELECT Max(PlateNumber) FROM LicenceMasterVL)
		SET @PlateNumber = coalesce(@PlateNumber, 0) + 1
	END
ELSE
	BEGIN
		SET @PlateNumber = 50000
	END
*/


SET @LicenceNumber = @LicenceTypeShortCode + Convert(varchar(50),@PlateNumber)
SET @CreatedDate = GETDATE()
SET @ModifiedDate = @CreatedDate

DECLARE @finalOperationDate datetime = dbo.LicenceMasterVL_GetFinalOperationDate(@PlateNumber,@RegistrationNumber, @LicenceTypeId, 11)

INSERT INTO LicenceMasterVL
(
PlateNumber,
LicenceNumber,
LicenceHolderId,
RegistrationNumber,
LicenceTypeId,
LicenceStateId,
LicenceStateMasterId,
LicenceExpiryDate,
LicenceIssueDate,
CoExpiryDate,
CoIssueDate,
RenewalDate,
TransferedFromReg,
HistoryChangeId ,
TestCenterId,
RemainingTransfers,
TransferDate,
OldPlateNumber,
OldLicenceAuthority,
CreatedBy,
ModifiedBy,
CreatedDate,
ModifiedDate,
FinalOperationDate,
MotorTaxRebateStatusId ,
MotorTaxRebateDate 
)
VALUES
(
@PlateNumber,
@LicenceNumber,
@LicenceHolderId,
@RegistrationNumber,
@LicenceTypeId,
@LicenceStateId,
@LicenceStateMasterId,
@LicenceExpiryDate,
@LicenceIssueDate,
@CoExpiryDate,
@CoIssueDate,
@RenewalDate,
@TransferedFromReg,
@HistoryChangeId ,
@TestCenterId,
@RemainingTransfers,
@TransferDate,
@OldPlateNumber,
@OldLicenceAuthority,
@CreatedBy,
@ModifiedBy,
@CreatedDate,
@ModifiedDate,
@finalOperationDate,
@MotorTaxRebateStatusId ,
@MotorTaxRebateDate 
)


IF @LicenceTypeId = 7 
	BEGIN
	INSERT INTO dbo.LAHLink(VehicleLicenceNumber,Area)
	VALUES(@LicenceNumber,@LAHArea)
	END



END



