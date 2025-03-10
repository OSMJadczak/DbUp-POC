BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240705105043_DeleteCmsTaxClearanceProcessType'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES (125,'CMS Tax Clearance Check')
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240705105043_DeleteCmsTaxClearanceProcessType'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240705105043_DeleteCmsTaxClearanceProcessType';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240617111012_AddRemovedProcessTypes'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId IN
                    (168,
                    169,
                    171,
                    170)
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240617111012_AddRemovedProcessTypes'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240617111012_AddRemovedProcessTypes';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240808141635_DeleteStatementTemplateIssuedProcessType'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES (122,'Statement Template Issued')
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240808141635_DeleteStatementTemplateIssuedProcessType'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240808141635_DeleteStatementTemplateIssuedProcessType';
END;
GO

COMMIT;
GO
