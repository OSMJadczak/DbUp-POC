USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[VehicleMaster_Update_DummyReg]    Script Date: 4/24/2020 2:53:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VehicleMaster_Update_DummyReg]

(
@RegistrationNumber varchar(10),
@LicenceNumber varchar(22)

)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Declare @currentReg varchar(30) = (Select top 1 RegistrationNumber from LicenceMasterVL Where LicenceNumber=@LicenceNumber)

		Update LicenceMasterVL 
					Set RegistrationNumber=@RegistrationNumber,
						ModifiedDate=getdate(),
						ModifiedBy='Helpdesk',
						[HistoryChangeId]=48 
					Where (RegistrationNumber=@currentReg AND LicenceNumber=@LicenceNumber)
					   
INSERT INTO [dbo].[LicenceMasterVLAudit]
           ([PlateNumber],[LicenceNumber],[LicenceHolderId],[RegistrationNumber],[LicenceTypeId],[LicenceStateId],[LicenceStateMasterId],[LicenceExpiryDate]
           ,[LicenceIssueDate],[CoExpiryDate],[CoIssueDate],[RenewalDate],[TransferedFromReg],[HistoryChangeId],[TestCenterId],[RemainingTransfers],[TransferDate]
           ,[OldPlateNumber],[OldLicenceAuthority],[Ccsn],[Ppsn],[CompanyNumber],[FirstName],[LastName],[DateOfBirth],[CompanyName],[TradingAs]
           ,[AddressLine1],[AddressLine2],[AddressLine3],[Town],[CountyId],[PostCode],[CountryId],[PhoneNo1],[PhoneNo2],[Email]
           ,[TaxClearanceVisual],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[AuditDate])    
Select top 1 [PlateNumber],[LicenceNumber],[LicenceHolderId],@RegistrationNumber,[LicenceTypeId],[LicenceStateId],[LicenceStateMasterId],[LicenceExpiryDate]
           ,[LicenceIssueDate],[CoExpiryDate],[CoIssueDate],[RenewalDate],[TransferedFromReg],48,[TestCenterId],[RemainingTransfers],[TransferDate]
           ,[OldPlateNumber],[OldLicenceAuthority],[Ccsn],[Ppsn],[CompanyNumber],[FirstName],[LastName],[DateOfBirth],[CompanyName],[TradingAs]
           ,[AddressLine1],[AddressLine2],[AddressLine3],[Town],[CountyId],[PostCode],[CountryId],[PhoneNo1],[PhoneNo2],[Email]
           ,[TaxClearanceVisual],[CreatedBy],[CreatedDate],'Helpdesk',getdate(),getdate()
		    from [dbo].[LicenceMasterVLAudit] where [LicenceNumber]=@LicenceNumber order by id desc


END

GO


