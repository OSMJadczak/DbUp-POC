
IF NOT EXISTS (
    SELECT * FROM [cabs_production].[dbo].[ReportVLSection]
    WHERE [ReportVLSectionId] = 10
)
BEGIN

    SET IDENTITY_INSERT [cabs_production].[dbo].[ReportVLSection] ON

    INSERT INTO [cabs_production].[dbo].[ReportVLSection]
    ([ReportVLSectionId],[ReportVLSectionName])
    VALUES (10, 'Case Management')

    SET IDENTITY_INSERT [cabs_production].[dbo].[ReportVLSection] OFF

    INSERT INTO [cabs_production].[dbo].[ReportsVL] (ReportName, ReportPath, AllowedRoles, ReportSection, [Order]) 
    VALUES ('All Cases', '/CMS/All Cases', 'GLOBAL_ADMIN,CMS Admin,CMS Manager', 10, 33)
    INSERT INTO [cabs_production].[dbo].[ReportsVL] (ReportName, ReportPath, AllowedRoles, ReportSection, [Order]) 
    VALUES ('Case Handling', '/CMS/Case Handling', 'GLOBAL_ADMIN,CMS Admin,CMS Manager', 10, 34)
    INSERT INTO [cabs_production].[dbo].[ReportsVL] (ReportName, ReportPath, AllowedRoles, ReportSection, [Order]) 
    VALUES ('Case Visibility', '/CMS/Case Visibility', 'GLOBAL_ADMIN,CMS Admin', 10, 35)
    INSERT INTO [cabs_production].[dbo].[ReportsVL] (ReportName, ReportPath, AllowedRoles, ReportSection, [Order]) 
    VALUES ('Special Category Data', '/CMS/Special Category Data', 'GLOBAL_ADMIN,CMS Admin', 10, 36)
END