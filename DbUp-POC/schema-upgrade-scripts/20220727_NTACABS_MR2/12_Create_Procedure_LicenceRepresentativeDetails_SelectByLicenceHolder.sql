USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceRepresentativeDetails_SelectByLicenceHolder]    Script Date: 12.09.2022 14:15:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LicenceRepresentativeDetails_SelectByLicenceHolder]  
(  
 @LicenceHolderMasterId nvarchar(10)  
)  
  
AS  
  
BEGIN  
DECLARE @LicenceRepresentativeId AS INT
DECLARE @CountyName As nvarchar(100) 
SET NOCOUNT ON;  
SELECT @LicenceRepresentativeId = LicenceRepresentativeId FROM  [dbo].[LicenceRepresentative] 
WHERE LicenceHolderMasterId = @LicenceHolderMasterId  

SELECT [RepresentativeId],
	[FirstName], 
	[LastName],
	[AddressLine1],
	[AddressLine2],
	[AddressLine3] ,
	[Town] ,
	Res.CountyId,
	[PostCode] ,
	[DateOfBirth] ,
	[PhoneNo1] ,
	[PhoneNo2],
	[Email] ,
	[HistoryChangeId], 
	Cou.CountyName as CountyName
	from dbo.Representative as Res
	INNER JOIN County Cou
    ON Res.CountyId = Cou.CountyId
	where Res.RepresentativeId = @LicenceRepresentativeId
  
END  
  
  
  
GO


