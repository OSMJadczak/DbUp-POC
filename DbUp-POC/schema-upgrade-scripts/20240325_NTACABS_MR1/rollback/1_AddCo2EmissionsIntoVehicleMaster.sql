USE [cabs_production]
GO

alter table [dbo].[VehicleMaster] drop column WltpCo2Emission
alter table [dbo].[VehicleMaster] drop column NedcCo2Emission
  
alter table [dbo].[VehicleMasterAudit] drop column WltpCo2Emission
alter table [dbo].[VehicleMasterAudit] drop column NedcCo2Emission
  
GO  