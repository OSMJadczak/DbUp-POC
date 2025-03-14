USE [cabs_production]
GO

/****** Object:  View [search].[vSearchDriverLink]    Script Date: 13.10.2022 09:00:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [search].[vSearchDriverLink] as 

with CTEDL as 
(
 SELECT 
 p.PersonId as [DLPersonId], 
 iu.ID as [IndustryUserId], 
 CONCAT(i.firstname, ' ', i.lastname) as DLDriverName 
 ,p.PPSN as [DLPPSN], 
 dlm.LicenceMasterId as DLDriverId,
 dlm.LicenceNumber as DLLicenceNumber
 from CABS_CMO.INDUSTRYUSER iu
 JOIN CABS_SPSV.IndustryUserPerson iudlhm ON iu.ID = iudlhm.IndustryUserId
 JOIN dl.LICENCEHOLDERMASTER dlhm ON iudlhm.PersonId = dlhm.PersonId
 JOIN dl.LICENCEMASTER dlm ON dlm.LicenceMasterId = dlhm.LicenceMasterId
 JOIN [person].[Person] p on p.PersonId = dlhm.PersonId
 JOIN [person].[Individual] i on p.PersonId = i.PersonId 
),
CTEVL as
(

	SELECT
	 lh.Ppsn as [VLPPSN]
	,lh.HolderName as [VLHName]
	,lm.LicenceNumber as [VLLicenceNumber]
	FROM [dbo].[LicenceMasterVL] lm 
	JOIN [dbo].[LicenceHolderMaster] lh on lh.LicenceHolderId = lm.LicenceHolderId
)
 select 
	   [DLPersonId]
      ,[DLDriverName]
      ,[DLPPSN]
      ,[DLDriverId]
      ,[LinkId]
      ,vd.StartDate as [ValidFrom]
      ,vd.EndDate as [ValidTo]
      ,[VehicleLicenseNumber]
      ,[HistoricalVehicleLicenceNumber]
      ,[WasLinkBroken]
      ,[VehicleLicenceHolderId]
      ,vd.RegistrationNumberFK as [VehicleRegistrationNumber]
      ,vd.IndustryUserId as [IndustryUserId]
      ,[VLPPSN]
      ,[VLHName]
      ,vd.DriverLicenceNumber as [DriverLicenceNumber]
 FROM [cabs_dvl].[VehicleDriver] vd
 JOIN CTEDL on CTEDL.IndustryUserId = vd.IndustryUserId and CTEDL.DLLicenceNumber = vd.DriverLicenceNumber
 JOIN CTEVL on CTEVL.VLLicenceNumber = vd.VehicleLicenseNumber
 WHERE IsActive = 1
GO


