USE [cabs_production]
GO

/****** Object:  View [cabs_spsv].[vDriverLicenceHolderMaster]    Script Date: 4/30/2020 9:27:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [cabs_spsv].[vDriverLicenceHolderMaster]
as
SELECT [PersonId]
      ,[CCSN]
      ,[PPSN]
      ,[PersonType]
      ,[PersonStatus]
      ,[FirstName]
      ,[LastName]
      ,[CompanyName]
      ,[CompanyNumber]
      ,[TradingAs]
      ,[DateOfBirth]
      ,[PhoneNo1]
      ,[PhoneNo2]
      ,[Email]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[Irish]
      ,[Eircode]
      ,[PrefContactMethod]
      ,[Town]
      ,[PostCode]
      ,[CountyName]
      ,[CountyId]
      ,[CountryName]
      ,[CountryId]
      ,[CreatedBy]
      ,[CreatedOn]
      ,[ModifiedBy]
      ,[ModifiedOn]
FROM [person].[DriverLicenceHolderDetails]

GO


