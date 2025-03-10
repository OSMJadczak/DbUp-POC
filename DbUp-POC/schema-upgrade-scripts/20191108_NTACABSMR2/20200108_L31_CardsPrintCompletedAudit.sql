USE [cabs_production]
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($40, 'Print Request Completed')

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20191217121013_CardsPrintCompletedAudit', N'2.2.2-servicing-10034');

GO

