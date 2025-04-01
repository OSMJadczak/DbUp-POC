USE [cabs_production]
GO

UPDATE [dbo].[aspnet_SiteMap]
   SET 
      [Roles] = 'global_admin,vl_admin,spsvadmin,online register admin'

 WHERE [dbo].[aspnet_SiteMap].Id = 5
GO

