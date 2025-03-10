USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

insert into [CABS_ENF].[FineNote] select Comments, Id, iif(ModifiedBy is null, CreatedBy, ModifiedBy), COALESCE(ModifiedDate, CreatedDate, GETDATE()) from [CABS_ENF].[Fines] 
where Comments is not NULL
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[CABS_ENF].[Fines]') AND [c].[name] = N'Comments');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [CABS_ENF].[Fines] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [CABS_ENF].[Fines] DROP COLUMN [Comments];
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240109150831_DeleteFineComments', N'6.0.0');
GO

COMMIT;
GO