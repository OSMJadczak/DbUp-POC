BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240308120704_AddCMSProcessTypes'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (100,'Case Created'),
                    (101,'Case Viewed'),
                    (102,'Case Details Updated'),
                    (103,'Case Contact Details Created'),
                    (104,'Case Contact Details Updated'),
                    (105,'Case Link Added'),
                    (106,'Case Link Updated'),
                    (107,'Case Link Removed'),
                    (108,'Journey Details Updated'),
                    (109,'Witness Details Updated'),
                    (110,'Witness Consent Withdrawn'),
                    (111,'Audit Details Updated'),
                    (112,'Grant Details Updated'),
                    (113,'Case Document Uploaded'),
                    (114,'Document Removed'),
                    (115,'Case Reopened'),
                    (116,'Case Resolved'),
                    (117,'Case Resolved Pending'),
                    (118,'Case Placed On Hold'),
                    (119,'Case PDF Created'),                
                    (121,'Case Shared'),
                    (122,'Statement Template Issued'),
                    (123,'Response Request Issued'),
                    (124,'NVDF Check'),
                    (125,'CMS Tax Clearance Check'),
                    (126,'Grant Offer Letter Issued'),
                    (127,'Grant Approved'),
                    (128,'Grant Rejected'),
                    (129,'Grant Withdrawn'),
                    (130,'Grant Extended'),
                    (131,'eSPSV GOL Issued'),
                    (132,'Tag Added'),
                    (133,'Tag Removed'),
                    (134,'Category Created'),
                    (135,'Category Updated'),
                    (136,'Category Activated'),
                    (137,'Category Deactivated'),
                    (138,'Team Created'),
                    (139,'Team Updated'),
                    (140,'Team Activated'),
                    (141,'Team Deactivated'),
                    (142,'Case Note Created'),
                    (143,'Case Note Updated'),
                    (144,'Case Note Document Created'),
                    (145,'Case Note Document Updated'),
                    (146,'Case Note Document Removed'),
                    (147,'Mention Notification Closed'),
                    (148,'Case Type Created'),
                    (149,'Case Type Updated'),
                    (150,'Case Type Activated'),
                    (151,'Case Type Deactivated')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240308120704_AddCMSProcessTypes'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240308120704_AddCMSProcessTypes', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240410074624_AddEmailTemplateProcessTypes'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (152,'Email Template Created'),
                    (153,'Email Template Update'),
                    (154,'Email Template Approved'),
                    (155,'Email Template Activated'),
                    (156,'Email Template Retired')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240410074624_AddEmailTemplateProcessTypes'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240410074624_AddEmailTemplateProcessTypes', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240424143243_AddCaseVehicleDetails'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (157,'Case Vehicle Details Created'),
                    (158,'Case Vehicle Details Updated')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240424143243_AddCaseVehicleDetails'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240424143243_AddCaseVehicleDetails', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240425092157_AddJourneyDetails'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (159,'Journey Details Created')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240425092157_AddJourneyDetails'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240425092157_AddJourneyDetails', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240430141045_AddWitnessDetails'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (160,'Witness Details Created'),
                    (161,'Witness Details Removed')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240430141045_AddWitnessDetails'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240430141045_AddWitnessDetails', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240506135529_AddCaseGrantAndAuditDetails'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (162,'Grant Details Created'),
                    (163,'Audit Details Created')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240506135529_AddCaseGrantAndAuditDetails'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240506135529_AddCaseGrantAndAuditDetails', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240513101534_AddGrantLimitsAndProcessParentObjectId'
)
BEGIN
    ALTER TABLE [audit].[Process] ADD [ParentObjectId] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240513101534_AddGrantLimitsAndProcessParentObjectId'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (164,'Grant Limit Created'),
                    (165,'Grant Limit Updated'),
                    (166,'Grant Limit Activated'),
                    (167,'Grant Limit Deactivated')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240513101534_AddGrantLimitsAndProcessParentObjectId'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240513101534_AddGrantLimitsAndProcessParentObjectId', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    DELETE FROM audit.Process WHERE ProcessTypeId = 155
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId = 155
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Template Created' WHERE ProcessTypeId = $152
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Template Updated' WHERE ProcessTypeId = $153
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Template Approved' WHERE ProcessTypeId = $154
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Template Retired' WHERE ProcessTypeId = $156
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240523125616_FixEmailTemplateTypes', N'8.0.4');
END;
GO

COMMIT;
GO