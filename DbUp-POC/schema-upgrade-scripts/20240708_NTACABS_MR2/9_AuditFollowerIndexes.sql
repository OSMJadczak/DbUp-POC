BEGIN TRANSACTION;
GO

IF NOT EXISTS (
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
    ALTER TABLE [audit].[Process] ALTER COLUMN [ParentObjectId] varchar(40) NULL;
END;
GO

IF NOT EXISTS (
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
    EXEC(N'UPDATE [audit].[Process] SET [ObjectId] = '''' WHERE [ObjectId] IS NULL');
    ALTER TABLE [audit].[Process] ALTER COLUMN [ObjectId] varchar(40) NOT NULL;
    ALTER TABLE [audit].[Process] ADD DEFAULT '' FOR [ObjectId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250102135515_AddIndexAdjustTypeOfProcessProperties'
)
BEGIN
    CREATE INDEX [IX_Process_ObjectId_ChangeDate] ON [audit].[Process] ([ObjectId], [ChangeDate]) INCLUDE ([OwnerModuleId], [ProcessTypeId], [ModuleId], [ParentObjectId], [ChangeBy], [ProcessId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250102135515_AddIndexAdjustTypeOfProcessProperties'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20250102135515_AddIndexAdjustTypeOfProcessProperties', N'8.0.4');
END;
GO

COMMIT;
GO

