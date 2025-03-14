USE [cabs_production]
GO

/****** Object:  View [cabs_spsv].[_ToDrop_vDriverLicenceIndustryUser]    Script Date: 20.06.2022 12:55:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cabs_spsv].[vVehicleLicenceHolderPerson]
AS 

SELECT [lh].[LicenceHolderId], [p].[PersonId]
FROM [dbo].[LicenceHolderMaster] lh
INNER JOIN [person].[Person] p ON lh.[Ccsn] = p.[CCSN]

GO
