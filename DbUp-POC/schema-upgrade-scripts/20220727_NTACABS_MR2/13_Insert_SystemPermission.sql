USE [cabs_production]
GO

INSERT INTO [dbo].[SystemPermission]
           ([PermissionName]
           ,[PageId]
           ,[AllowedRoles])
     VALUES
           ('VL_RETURN_LICENCE_DOCUMENTATION'
           ,20
           ,'global_admin')
GO


