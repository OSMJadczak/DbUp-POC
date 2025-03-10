BEGIN TRANSACTION;
GO

ALTER TABLE [CABS_ENF].[Fines] ADD [StreetAddress] nvarchar(max) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240918104521_AddStreetAddressToFine', N'6.0.0');
GO

COMMIT;
GO

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
    , [StreetAddress]
      FROM [cabs_enf].[Fines]
GO

