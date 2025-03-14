USE [cabs_production]
GO

ALTER TABLE [cabs_cmo].[PersonAudit]
	ALTER COLUMN [PostCode] [nvarchar](12) NULL

ALTER TABLE [cabs_dck].[DriverCheckReport]
	ALTER COLUMN [DriverName] [varchar](101) NULL
	
ALTER TABLE [cabs_dck].[DriverCheckSearchResult]
	ALTER COLUMN [DriverName] [varchar](101) NULL	
	
ALTER TABLE [cabs_rta].[RentalAgreement]
	ALTER COLUMN [Name] [nvarchar](101) NULL
ALTER TABLE [cabs_rta].[RentalAgreement]
	ALTER COLUMN [Address] [nvarchar](450) NULL
	
ALTER TABLE [dbo].[BookingMIData]
	ALTER COLUMN [AddressLine1] [nvarchar](100) NOT NULL
ALTER TABLE [dbo].[BookingMIData]
	ALTER COLUMN [AddressLine2] [nvarchar](100) NULL
ALTER TABLE [dbo].[BookingMIData]
	ALTER COLUMN [AddressLine3] [nvarchar](100) NULL
	
ALTER TABLE [dbo].[LicenceHolderAudit]
	ALTER COLUMN [PostCode] [nvarchar](12) NULL

--This is alredy change 
ALTER TABLE [dbo].[LicenceMasterVLAudit]
	ALTER COLUMN [Ccsn] [nvarchar](20) NULL
ALTER TABLE [dbo].[LicenceMasterVLAudit]
	ALTER COLUMN [CompanyName] [nvarchar](100) NULL
ALTER TABLE [dbo].[LicenceMasterVLAudit]
	ALTER COLUMN [TradingAs] [nvarchar](100) NULL
ALTER TABLE [dbo].[LicenceMasterVLAudit]
	ALTER COLUMN [AddressLine1] [nvarchar](100) NULL
ALTER TABLE [dbo].[LicenceMasterVLAudit]
	ALTER COLUMN [AddressLine2] [nvarchar](100) NULL
ALTER TABLE [dbo].[LicenceMasterVLAudit]
	ALTER COLUMN [AddressLine3] [nvarchar](100) NULL
ALTER TABLE [dbo].[LicenceMasterVLAudit]
	ALTER COLUMN [PostCode] [nvarchar](12) NULL

ALTER TABLE [dbo].[PrintRequestMasterVL]
	DROP COLUMN [HolderFullName];
ALTER TABLE [dbo].[PrintRequestMasterVL]
	DROP COLUMN [HolderFullAddress] 
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [HolderCCSN] [nvarchar](20) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [HolderName] [nvarchar](101) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [NewHolderName] [nvarchar](101) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [PreviousHolderName] [nvarchar](101) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [HolderCompanyName] [nvarchar](100) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [HolderTradingAs] [nvarchar](100) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [HolderAddressLine1] [nvarchar](100) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [HolderAddressLine2] [nvarchar](100) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ALTER COLUMN [HolderAddressLine3] [nvarchar](100) NULL
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ADD [HolderFullName]  AS (case when isnull([HolderCompanyName],'')='' then ([HolderFirstName]+' ')+[HolderLastName] else [HolderCompanyName] end)
ALTER TABLE [dbo].[PrintRequestMasterVL]
	ADD [HolderFullAddress]  AS ((((((((((isnull([HolderAddressLine1],'')+' ')+isnull([HolderAddressLine2],''))+' ')+isnull([HolderAddressLine3],''))+' ')+isnull([HolderTown],''))+' ')+isnull([HolderCounty],''))+' ')+isnull([HolderPostCode],''))

ALTER TABLE [dl].[LetterRequestMaster]
	ALTER COLUMN [Ccsn] [varchar](20) NULL
ALTER TABLE [dl].[LetterRequestMaster]
	ALTER COLUMN [FirstName] [nvarchar](50) NOT NULL
ALTER TABLE [dl].[LetterRequestMaster]
	ALTER COLUMN [LastName] [nvarchar](50) NOT NULL
ALTER TABLE [dl].[LetterRequestMaster]
	ALTER COLUMN [DriverPostCode] [varchar](12) NULL
	
	
ALTER TABLE [dbo].[DispatchOperatorMaster]
	ALTER COLUMN [CompanyOwnerName] [varchar](100) NULL
ALTER TABLE [dbo].[DispatchOperatorMaster]
	ALTER COLUMN [Website] [nvarchar](255) NULL	
	

--Rename old TABLE
EXEC sp_rename '[cabs_enf].[CaseNotes_20200109]', 'ToDrop_CaseNotes_20200109' -- this is only on prod/preprod
	
--Rename old SP
EXEC sp_rename '[cabs_enf].[AddFine]', 'ToDrop_AddFine'
EXEC sp_rename '[cabs_sk].[CreatePrintRequestMaster]', 'ToDrop_CreatePrintRequestMaster'
EXEC sp_rename '[cabs_spsv].[UpdatePostalAddressLicenceHolderMaster]', 'ToDrop_UpdatePostalAddressLicenceHolderMaster'
EXEC sp_rename '[cabs_spsv].[UpdateEmailDriverLicenceHolderMaster]', 'ToDrop_UpdateEmailDriverLicenceHolderMaster'
EXEC sp_rename '[cabs_sk].[UpdateLicenceHolderMasterLive]', 'ToDrop_UpdateLicenceHolderMasterLive'
EXEC sp_rename '[cabs_spsv].[UpdateEmailForSPSVPortal]', 'ToDrop_UpdateEmailForSPSVPortal'
EXEC sp_rename '[cabs_cmo].[SyncEmails]', 'ToDrop_SyncEmails'
EXEC sp_rename '[cabs_cmo].[SyncPersonTable]', 'ToDrop_SyncPersonTable'
EXEC sp_rename '[cabs_cmo].[SyncPortalMobile]', 'ToDrop_SyncPortalMobile'
 	