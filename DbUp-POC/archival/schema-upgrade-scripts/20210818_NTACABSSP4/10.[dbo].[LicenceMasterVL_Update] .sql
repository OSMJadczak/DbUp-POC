USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[LicenceMasterVL_Update]    Script Date: 8/18/2021 12:16:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceMasterVL_Update] 
    @PlateNumber int,
    @LicenceNumber varchar(50),
    @LicenceHolderId int,
    @RegistrationNumber varchar(10),
    @LicenceTypeId tinyint,
    @LicenceStateId tinyint,
    @LicenceStateMasterId tinyint,
    @LicenceExpiryDate smalldatetime,
    @LicenceIssueDate smalldatetime,
    @CoExpiryDate smalldatetime,
    @CoIssueDate smalldatetime,
    @RenewalDate smalldatetime,
    @TransferedFromReg varchar(50),
    @HistoryChangeId tinyint,
    @TestCenterId smallint,
    @RemainingTransfers int,
    @TransferDate smalldatetime,
    @OldPlateNumber varchar(50),
    @OldLicenceAuthority varchar(50),
    @ModifiedDate datetime output,
    @CreatedDate datetime,
    @ModifiedBy nvarchar(20),
    @CreatedBy nvarchar(20),
	@LAHArea nvarchar(50),
	@SuspensionStartDate datetime,
	@SuspensionEndDate datetime,
	@EVGrantStatusId int,
	@ScrappageGrantStatusId tinyint,
	@EVGrantExpiryDate smalldatetime ,
	@WAVGrantStatusId int,
	@WAVGrantExpiryDate smalldatetime ,
	@MotorTaxRebateStatusId int,
	@MotorTaxRebateDate smalldatetime
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

SET @ModifiedDate = GETDATE()

DECLARE @finalOperationDate datetime = dbo.LicenceMasterVL_GetFinalOperationDate(@PlateNumber, @RegistrationNumber, @LicenceTypeId, 0)

UPDATE LicenceMasterVL
SET PlateNumber = @PlateNumber
	,LicenceHolderId = @LicenceHolderId
	,RegistrationNumber = @RegistrationNumber
	,LicenceTypeId = @LicenceTypeId
	,LicenceStateId = @LicenceStateId
	,LicenceStateMasterId = @LicenceStateMasterId
	,LicenceExpiryDate = @LicenceExpiryDate
	,LicenceIssueDate = @LicenceIssueDate
	,CoExpiryDate = @CoExpiryDate
	,CoIssueDate = @CoIssueDate
	,RenewalDate = @RenewalDate
	,TransferedFromReg = @TransferedFromReg
	,HistoryChangeId = @HistoryChangeId
	,TestCenterId = @TestCenterId
	,RemainingTransfers = @RemainingTransfers
	,TransferDate = @TransferDate
	,OldPlateNumber = @OldPlateNumber
	,OldLicenceAuthority = @OldLicenceAuthority
	,ModifiedBy = @ModifiedBy
	,ModifiedDate = @ModifiedDate
	,FinalOperationDate = @finalOperationDate
	,SuspensionStartDate = @SuspensionStartDate
	,SuspensionEndDate = @SuspensionEndDate
	,ScrappageGrantStatusId = @ScrappageGrantStatusId
	,MotorTaxRebateStatusId = @MotorTaxRebateStatusId
	,MotorTaxRebateDate = @MotorTaxRebateDate
WHERE LicenceNumber = @LicenceNumber

IF (
		@LAHArea IS NOT NULL
		AND @LAHArea <> ''
		)
BEGIN
	EXEC [dbo].[LAHLink_Update] @LicenceNumber
		,@LAHArea
END

IF (@EVGrantStatusId IS NOT NULL)
BEGIN
	EXEC dbo.[EVGrantRegister_Update] @LicenceNumber
		,@EVGrantStatusId
		,@EVGrantExpiryDate
		,@ModifiedBy
END

UPDATE WatRegister
SET WavGrantExpiryDate = @WAVGrantExpiryDate
	,WAVGrantStatusId = @WAVGrantStatusId
	,ModifiedBy = @ModifiedBy
	,ModifiedDate = @ModifiedDate
WHERE LicenceNumber = @LicenceNumber 
END
