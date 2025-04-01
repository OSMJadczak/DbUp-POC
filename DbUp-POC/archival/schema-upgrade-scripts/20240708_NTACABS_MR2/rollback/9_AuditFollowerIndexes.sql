BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250102135515_AddIndexAdjustTypeOfProcessProperties'
)
BEGIN
    DROP INDEX [IX_Process_ObjectId_ChangeDate] ON [audit].[Process];
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250102135515_AddIndexAdjustTypeOfProcessProperties'
)
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[audit].[Process]') AND [c].[name] = N'ParentObjectId');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [audit].[Process] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [audit].[Process] ALTER COLUMN [ParentObjectId] nvarchar(max) NULL;
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250102135515_AddIndexAdjustTypeOfProcessProperties'
)
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[audit].[Process]') AND [c].[name] = N'ObjectId');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [audit].[Process] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [audit].[Process] ALTER COLUMN [ObjectId] nvarchar(max) NULL;
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250102135515_AddIndexAdjustTypeOfProcessProperties'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250102135515_AddIndexAdjustTypeOfProcessProperties';
END;
GO

COMMIT;
GO

