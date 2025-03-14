BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES (155,'Email Template Activated')
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Email Template Created' WHERE ProcessTypeId = $152
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Email Template Update' WHERE ProcessTypeId = $153
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Email Template Approved' WHERE ProcessTypeId = $154
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    UPDATE [audit].[ProcessType] SET [Name] = 'Email Template Retired' WHERE ProcessTypeId = $156
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240523125616_FixEmailTemplateTypes'
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240513101534_AddGrantLimitsAndProcessParentObjectId'
)
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[audit].[Process]') AND [c].[name] = N'ParentObjectId');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [audit].[Process] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [audit].[Process] DROP COLUMN [ParentObjectId];
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240513101534_AddGrantLimitsAndProcessParentObjectId'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId IN (
                    164,
                    165,
                    166,
                    167)
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240513101534_AddGrantLimitsAndProcessParentObjectId'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240513101534_AddGrantLimitsAndProcessParentObjectId';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240506135529_AddCaseGrantAndAuditDetails'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId IN (162,163)
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240506135529_AddCaseGrantAndAuditDetails'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240506135529_AddCaseGrantAndAuditDetails';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240430141045_AddWitnessDetails'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId IN (160,161)
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240430141045_AddWitnessDetails'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240430141045_AddWitnessDetails';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240425092157_AddJourneyDetails'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId = 159
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240425092157_AddJourneyDetails'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240425092157_AddJourneyDetails';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240424143243_AddCaseVehicleDetails'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId IN (157,158)
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240424143243_AddCaseVehicleDetails'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240424143243_AddCaseVehicleDetails';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240410074624_AddEmailTemplateProcessTypes'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId BETWEEN 152 AND 156
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240410074624_AddEmailTemplateProcessTypes'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240410074624_AddEmailTemplateProcessTypes';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240308120704_AddCMSProcessTypes'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId BETWEEN 100 AND 151
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240308120704_AddCMSProcessTypes'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240308120704_AddCMSProcessTypes';
END;
GO

COMMIT;
GO

