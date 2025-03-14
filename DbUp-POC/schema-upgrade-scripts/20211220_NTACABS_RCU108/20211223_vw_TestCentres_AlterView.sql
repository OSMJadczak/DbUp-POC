USE [cabs_production]
GO

/****** Object:  View [dbo].[vw_TestCentres]    Script Date: 12/23/2021 3:22:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_TestCentres]
AS
SELECT     dbo.TestCentre.TestCentreName, dbo.TestCentre.AddressLine1, dbo.TestCentre.AddressLine2, dbo.TestCentre.AddressLine3, dbo.TestCentre.Town, 
                      dbo.TestCentre.PostCode, dbo.TestCentre.Eircode, dbo.TestCentre.ContactName, dbo.TestCentre.ContactNumberPrimary, 
					  dbo.TestCentre.ContactNumberSecondary, dbo.TestCentre.Email, dbo.Region.RegionName, dbo.County.CountyName, dbo.Country.CountryName, 
                      dbo.TestCentre.TestCentreId, dbo.Region.RegionId, dbo.County.CountyId, dbo.Country.CountryId
FROM         dbo.TestCentre LEFT OUTER JOIN
                      dbo.Region ON dbo.TestCentre.RegionId = dbo.Region.RegionId LEFT OUTER JOIN
                      dbo.Country ON dbo.TestCentre.CountryId = dbo.Country.CountryId LEFT OUTER JOIN
                      dbo.County ON dbo.TestCentre.CountyId = dbo.County.CountyId
GO


