
use authService;
BEGIN TRANSACTION;
GO

CREATE TABLE [jwtauth].[Permissions] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_Permissions] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [jwtauth].[CredentialsPermissions] (
    [CredentialsId] uniqueidentifier NOT NULL,
    [PermissionsId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_CredentialsPermissions] PRIMARY KEY ([CredentialsId], [PermissionsId]),
    CONSTRAINT [FK_CredentialsPermissions_Credentials_CredentialsId] FOREIGN KEY ([CredentialsId]) REFERENCES [jwtauth].[Credentials] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CredentialsPermissions_Permissions_PermissionsId] FOREIGN KEY ([PermissionsId]) REFERENCES [jwtauth].[Permissions] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_CredentialsPermissions_PermissionsId] ON [jwtauth].[CredentialsPermissions] ([PermissionsId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250203111200_AddPermissions', N'8.0.5');
GO

COMMIT;
GO

