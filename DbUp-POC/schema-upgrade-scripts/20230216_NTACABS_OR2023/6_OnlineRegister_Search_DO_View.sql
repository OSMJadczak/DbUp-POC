BEGIN TRANSACTION;
GO

CREATE VIEW [or].[vDispatchOperatorLicenceSearch] AS
	SELECT
		ROW_NUMBER() OVER (ORDER BY (SELECT [LicenceNumber])) AS ID,
		*
	FROM (SELECT
	    lm.[LicenceNumber],
	    p.[PersonTypeId] AS [LicenceHolderType],
	    i.[FirstName] AS [LicenceHolderFirstName],
	    i.[LastName] AS [LicenceHolderLastName],
	    c.[CompanyNumber] AS [LicenceHolderCompanyNumber],
	    c.[CompanyName] AS [LicenceHolderCompanyName],
	    p.[PPSN] AS [LicenceHolderPpsn],
	    lm.[CountyId] AS [AreaId],
	    lm.[IssueDate] AS [LicenceIssueDate],
	    lm.[ExpiryDate] AS [LicenceExpiryDate],
	    lm.[LicenceStateId],
		ls.[Name] AS [LicenceState],
		lm.[LicenceStateMasterId],
		lsm.[Name] AS [LicenceStateMaster],
		lm.[Website],
		lm.[BookingApplication]
    FROM [do].[LicenceMaster] lm
    INNER JOIN [do].[LicenceHolderMaster] lhm on lm.[Id] = lhm.[LicenceId]
	INNER JOIN [do].[LicenceStateMaster] lsm on lm.[LicenceStateMasterId] = lsm.[Id]
    INNER JOIN [person].[Person] p on lhm.[PersonId] = p.[PersonId]
	LEFT OUTER JOIN [do].[LicenceState] ls on lm.[LicenceStateId] = ls.[Id]
    LEFT OUTER JOIN [person].[Individual] i on p.[PersonId] = i.[PersonId]
    LEFT OUTER JOIN [person].[Company] c on p.[PersonId] = c.[PersonId]) q
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230315094544_OnlineRegister_Search_DO_View', N'6.0.14');
GO

COMMIT;
GO

