SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [cabs_enf].[vFine]
AS
      select [Id]
      , [Amount]
      , [DatePaid]
      , [DocketNumber]
      , [DriverLicenceNumber]
      , [DueForPayment]
      , [FineAreaId]
      , [FineStatusId]
      , [FineTypeId]
      , [IncidentDate]
      , [InfoLicenceNumber]
      , [IsPaid]
      , [IssueDate]
      , [IssueOfficerName]
      , [RegistrationNumber]
      , [VehicleLicenceNumber]
      , [IssueOfficerId]
      , [InfoRegistrationNumber]
	, [CreatedBy]
	, [CreatedDate]
	, [DriverLicenceId]
	, [FineCreationType]
      FROM [cabs_enf].[Fines]
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[CABS_ENF].[Fines]') AND [c].[name] = N'StreetAddress');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [CABS_ENF].[Fines] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [CABS_ENF].[Fines] DROP COLUMN [StreetAddress];
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20240918104521_AddStreetAddressToFine';
GO

COMMIT;
GO
