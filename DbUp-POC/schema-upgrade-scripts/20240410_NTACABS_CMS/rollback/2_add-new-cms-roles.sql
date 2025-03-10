USE [cabs_production]
GO

-- Rollback the INSERT operation
DELETE FROM [dbo].[aspnet_Roles]
WHERE RoleName = 'CMS Manager';

-- Rollback the UPDATE operation
UPDATE [dbo].[aspnet_Roles]
SET RoleName = 
    CASE 
        WHEN RoleName = 'CMS User' THEN 'Case Management'
        WHEN RoleName = 'CMS Admin' THEN 'CMS_Admin'
        ELSE RoleName -- If no changes needed, keep the same role name
    END,
    LoweredRoleName = 
    CASE 
        WHEN RoleName = 'CMS User' THEN 'case management'
        WHEN RoleName = 'CMS Admin' THEN 'cms_admin'
        ELSE LoweredRoleName -- If no changes needed, keep the same lowered role name
    END
WHERE RoleName IN ('CMS User', 'CMS Admin');

GO
