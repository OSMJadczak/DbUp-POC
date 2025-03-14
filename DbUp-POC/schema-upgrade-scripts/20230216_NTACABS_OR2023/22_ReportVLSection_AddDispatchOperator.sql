BEGIN TRAN
SET IDENTITY_INSERT [cabs_production].[dbo].[ReportVLSection] ON

INSERT INTO [cabs_production].[dbo].[ReportVLSection] (ReportVLSectionId, ReportVLSectionName) VALUES (9, 'Dispatch Operator')

INSERT INTO [cabs_production].[dbo].[ReportsVL] (ReportName, ReportPath, AllowedRoles, ReportSection, [Order]) VALUES (
'DO Proof of Deletion', '/Data Retention/DR11 - Dispatch Operators', '*', 9, null)

SET IDENTITY_INSERT [cabs_production].[dbo].[ReportVLSection] OFF

COMMIT