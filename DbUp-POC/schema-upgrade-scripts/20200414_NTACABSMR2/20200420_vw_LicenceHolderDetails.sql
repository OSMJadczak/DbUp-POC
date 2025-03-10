USE [cabs_production]
GO

/****** Object:  View [dbo].[vw_LicenceHolderDetails]    Script Date: 4/22/2020 9:53:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[vw_LicenceHolderDetails]
 
AS
SELECT     dbo.LicenceHolderMaster.Ccsn, dbo.LicenceHolderMaster.Ppsn, dbo.LicenceHolderMaster.HolderName, dbo.LicenceHolderMaster.FirstName, 
                      dbo.LicenceHolderMaster.DateOfBirth, dbo.LicenceHolderMaster.LastName, dbo.LicenceHolderMaster.CompanyNumber, dbo.LicenceHolderMaster.CompanyName, 
                      dbo.LicenceHolderMaster.TradingAs, dbo.LicenceHolderMaster.AddressLine1, dbo.LicenceHolderMaster.AddressLine2, dbo.LicenceHolderMaster.AddressLine3, 
                      dbo.LicenceHolderMaster.Town, dbo.LicenceHolderMaster.PostCode, dbo.LicenceHolderMaster.PhoneNo1, dbo.LicenceHolderMaster.PhoneNo2, 
                      dbo.LicenceHolderMaster.Email, dbo.LicenceHolderMaster.TaxClearanceNumber, 
                      dbo.LicenceHolderMaster.TaxClearanceExpiryDate, dbo.LicenceHolderMaster.TaxClearanceStatus, dbo.LicenceHolderMaster.TaxClearanceVisual, 
                      dbo.LicenceHolderMaster.TaxClearanceName,dbo.LicenceHolderMaster.IrishLanguageAddress, dbo.County.CountyName, dbo.County.IrishName, dbo.Country.CountryName, dbo.LicenceHolderMaster.LicenceHolderId
FROM         dbo.LicenceHolderMaster 
LEFT JOIN dbo.Country ON dbo.LicenceHolderMaster.CountryId = dbo.Country.CountryId 
LEFT JOIN dbo.County ON dbo.LicenceHolderMaster.CountyId = dbo.County.CountyId 

GO


