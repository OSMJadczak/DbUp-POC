USE [cabs_production]
GO


IF NOT EXISTS(SELECT * FROM [dbo].[aspnet_Roles] where [RoleName] = 'CMS Manager')
BEGIN
INSERT INTO [dbo].[aspnet_Roles]
           ([ApplicationId]
           ,[RoleId]
           ,[RoleName]
           ,[LoweredRoleName]
           ,[Description])
     VALUES
           ('FA1EB1E6-5292-4A2B-A755-73DCD82CE8BF'
           ,'40066B11-80A8-4EE9-B46B-905D55602421'
           ,'CMS Manager'
           ,'cms manager'
           ,NULL)
END
GO

UPDATE [cabs_production].[dbo].[aspnet_Roles]
SET RoleName = 
    CASE 
        WHEN RoleName = 'Case Management' THEN 'CMS User'
        WHEN RoleName = 'CMS_Admin' THEN 'CMS Admin'
        ELSE RoleName -- If no changes needed, keep the same role name
    END,
    LoweredRoleName = 
    CASE 
        WHEN RoleName = 'Case Management' THEN 'cms user'
        WHEN RoleName = 'CMS_Admin' THEN 'cms admin'
        ELSE LoweredRoleName -- If no changes needed, keep the same lowered role name
    END
WHERE RoleName IN ('Case Management', 'CMS_Admin');
