USE [cabs_production]
GO

INSERT INTO [dbo].[SystemPermission]
           ([PermissionName]
           ,[PageId]
           ,[AllowedRoles])
     VALUES
           ('OR_ADMIN_ACCESS'
           ,1
           ,'online register admin')
GO