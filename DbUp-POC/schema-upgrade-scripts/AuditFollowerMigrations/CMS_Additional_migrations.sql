BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240617111012_AddRemovedProcessTypes'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (168,'Grant Details Removed'),
                    (169,'Case Vehicle Details Removed'),
                    (170,'Audit Details Removed'),
                    (171,'Journey Details Removed')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240617111012_AddRemovedProcessTypes'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240617111012_AddRemovedProcessTypes', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240705105043_DeleteCmsTaxClearanceProcessType'
)
BEGIN
    DELETE FROM audit.Process WHERE ProcessTypeId = 125
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240705105043_DeleteCmsTaxClearanceProcessType'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId = 125
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240705105043_DeleteCmsTaxClearanceProcessType'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240705105043_DeleteCmsTaxClearanceProcessType', N'8.0.4');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240808141635_DeleteStatementTemplateIssuedProcessType'
)
BEGIN
    DELETE FROM audit.Process WHERE ProcessTypeId = 122
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240808141635_DeleteStatementTemplateIssuedProcessType'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId = 122
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240808141635_DeleteStatementTemplateIssuedProcessType'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240808141635_DeleteStatementTemplateIssuedProcessType', N'8.0.4');
END;
GO

COMMIT;
GO