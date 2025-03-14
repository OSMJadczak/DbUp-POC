BEGIN TRANSACTION;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20241002090557_AddModuleType')
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[letters].[Letter]') AND [c].[name] = N'ModuleType');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [letters].[Letter] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [letters].[Letter] DROP COLUMN [ModuleType];
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20241002090557_AddModuleType')
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20241002090557_AddModuleType';
END;
GO

COMMIT;
GO