USE [cabs_production]
GO

/****** Object:  View [cabs_spsv].[_ToDrop_vDriverLicenceIndustryUser]    Script Date: 20.06.2022 12:55:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cabs_spsv].[vIndustryUserPerson]
AS 

SELECT iup.[IndustryUserId], p.[PersonId], p.[CCSN]
FROM [cabs_spsv].[IndustryUserPerson] iup
INNER JOIN [Person].[Person] p ON [iup].[PersonId] = p.[PersonId]

GO
