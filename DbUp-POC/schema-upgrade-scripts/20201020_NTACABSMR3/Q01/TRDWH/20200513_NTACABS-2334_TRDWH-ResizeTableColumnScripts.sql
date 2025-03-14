USE [TRDWH]
GO

ALTER TABLE [dbo].[DispatchOperator]
	ALTER COLUMN [CompanyName] [varchar](100) NULL
ALTER TABLE [dbo].[DispatchOperator]
	ALTER COLUMN [CompanyAddress1] [varchar](100) NULL
ALTER TABLE [dbo].[DispatchOperator]
	ALTER COLUMN [CompanyAddress2] [varchar](100) NULL
ALTER TABLE [dbo].[DispatchOperator]
	ALTER COLUMN [CompanyAddress3] [varchar](100) NULL
ALTER TABLE [dbo].[DispatchOperator]
	ALTER COLUMN [CompanyAddress4] [varchar](100) NULL
ALTER TABLE [dbo].[DispatchOperator]
	ALTER COLUMN [CompanyOwnerName] [varchar](100) NULL
	
	
ALTER TABLE [dbo].[DWH_Driver_SnapShot]
	ALTER COLUMN [PrimLicenseArea] [nvarchar](64) NULL
ALTER TABLE [dbo].[DWH_Driver_SnapShot]
	ALTER COLUMN [GardaArea] [nvarchar](64) NULL
	
ALTER TABLE [dbo].[DWH_DRIVERS_COUNTY]
	ALTER COLUMN [PrimLicenceArea] [nvarchar](64) NULL
ALTER TABLE [dbo].[DWH_DRIVERS_COUNTY]
	ALTER COLUMN [SecLicenseArea] [nvarchar](64) NULL
	
ALTER TABLE [dbo].[DWH_LicenceHolderMasterHistory]
	ALTER COLUMN [Addr_1] [nvarchar](100) NULL
ALTER TABLE [dbo].[DWH_LicenceHolderMasterHistory]
	ALTER COLUMN [Addr_2] [nvarchar](100) NULL
ALTER TABLE [dbo].[DWH_LicenceHolderMasterHistory]
	ALTER COLUMN [Addr_3] [nvarchar](100) NULL
ALTER TABLE [dbo].[DWH_LicenceHolderMasterHistory]
	ALTER COLUMN [PostCode] [nvarchar](12) NULL
ALTER TABLE [dbo].[DWH_LicenceHolderMasterHistory]
	ALTER COLUMN [TradingAs] [nvarchar](100) NULL
	
ALTER TABLE [dbo].[DWH_RentalAgreement]
	ALTER COLUMN [Name] [nvarchar](101) NULL
ALTER TABLE [dbo].[DWH_RentalAgreement]
	ALTER COLUMN [Address] [nvarchar](450) NULL

ALTER TABLE [dbo].[LICENCES_EXTRACT_ARCHIVE_ALL]
	ALTER COLUMN [Company] [nvarchar](100) NULL
	
ALTER TABLE [dbo].[Temp_DWH_RentalAgreement]
	ALTER COLUMN [Name] [nvarchar](101) NULL
ALTER TABLE [dbo].[Temp_DWH_RentalAgreement]
	ALTER COLUMN [Address] [nvarchar](450) NULL
	
--Rename old SP
EXEC sp_rename '[dbo].[iCabs_GetDriverEnforcementComplaints]', 'ToDrop_iCabs_GetDriverEnforcementComplaints'
EXEC sp_rename '[dbo].[USP_DWH_EnforcementComplaints]', 'ToDrop_USP_DWH_EnforcementComplaints'
EXEC sp_rename '[dbo].[USP_DWH_EnforcementFines_Select]', 'ToDrop_USP_DWH_EnforcementFines_Select'
EXEC sp_rename '[dbo].[USP_DWH_GetDriverEnforcementComplaints]', 'ToDrop_USP_DWH_GetDriverEnforcementComplaints'
EXEC sp_rename '[dbo].[USP_DWH_UnPaidFines_Select]', 'ToDrop_USP_DWH_UnPaidFines_Select'
	