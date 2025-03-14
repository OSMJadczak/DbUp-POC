BEGIN TRANSACTION;
GO

DROP TABLE [jwtauth].[CredentialsPermissions];
GO

DROP TABLE [PermissionsEntity];
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20250203104823_AddPermissions';
GO

COMMIT;
GO

