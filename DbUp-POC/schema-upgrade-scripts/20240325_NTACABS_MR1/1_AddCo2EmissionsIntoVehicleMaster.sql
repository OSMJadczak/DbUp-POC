USE [cabs_production]
GO

alter table [dbo].[VehicleMaster] add WltpCo2Emission int null
alter table [dbo].[VehicleMaster] add NedcCo2Emission int null
  
alter table [dbo].[VehicleMasterAudit] add WltpCo2Emission int null
alter table [dbo].[VehicleMasterAudit] add NedcCo2Emission int null
  
GO