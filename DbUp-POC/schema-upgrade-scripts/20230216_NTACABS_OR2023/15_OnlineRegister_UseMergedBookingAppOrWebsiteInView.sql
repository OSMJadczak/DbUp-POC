BEGIN TRANSACTION;
GO

DROP VIEW [or].[vDispatchOperatorLicenceSearch]
GO

CREATE OR ALTER VIEW [or].[vDispatchOperatorLicenceSearch] AS
	            SELECT
		            ROW_NUMBER() OVER (ORDER BY (SELECT [LicenceNumber])) AS ID,
		            *
	            FROM (SELECT
                    lm.Id as LicenceId,
	                lm.[LicenceNumber],
	                p.[PersonTypeId] AS [LicenceHolderType],
	                i.[FirstName] AS [LicenceHolderFirstName],
	                i.[LastName] AS [LicenceHolderLastName],
	                c.[CompanyNumber] AS [LicenceHolderCompanyNumber],
	                c.[CompanyName] AS [LicenceHolderCompanyName],
	                p.[PPSN] AS [LicenceHolderPpsn],
	                lm.[IssueDate] AS [LicenceIssueDate],
	                lm.[ExpiryDate] AS [LicenceExpiryDate],
	                lm.[LicenceStateId],
		            ls.[Name] AS [LicenceState],
		            lm.[LicenceStateMasterId],
		            lsm.[Name] AS [LicenceStateMaster],
		            lm.[BookingAppOrWebsite]
                FROM [do].[LicenceMaster] lm
                INNER JOIN [do].[LicenceHolderMaster] lhm on lm.[Id] = lhm.[LicenceId]
	            INNER JOIN [do].[LicenceStateMaster] lsm on lm.[LicenceStateMasterId] = lsm.[Id]
                INNER JOIN [person].[Person] p on lhm.[PersonId] = p.[PersonId]
	            LEFT OUTER JOIN [do].[LicenceState] ls on lm.[LicenceStateId] = ls.[Id]
                LEFT OUTER JOIN [person].[Individual] i on p.[PersonId] = i.[PersonId]
                LEFT OUTER JOIN [person].[Company] c on p.[PersonId] = c.[PersonId]) q
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230425105623_DispatchOperator_MergeBookingAppAndWebsite', N'7.0.5');
GO

COMMIT;
GO

