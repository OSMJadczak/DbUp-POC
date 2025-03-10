use cabs_production
go

BEGIN TRANSACTION;
GO

CREATE VIEW [or].[vDriverLicenceSearch] AS
	SELECT
		ROW_NUMBER() OVER (ORDER BY (SELECT [LicenceNumber])) AS Id,
		*
	FROM (SELECT
		lm.[LicenceNumber],
		pin.[FirstName] AS [LicenceHolderFirstName],
		pin.[LastName] AS [LicenceHolderLastName],
		pin.[DateOfBirth] AS [LicenceHolderDateOfBirth],
		p.[PPSN] AS [LicenceHolderPpsn],
		lm.[PrimaryAreaId],
		aa.[AdditionalAreaId],
		lm.[GardaAreaId],
		lm.[LicenceStateMasterId],
		lsm.[Name] AS [LicenceStateMaster],
		lm.[LicenceStateId],
		ls.[Name] AS [LicenceState],
		lm.[ExpiryDate] AS [LicenceExpiryDate],
		vd.[StartDate] AS [LinkStartDate],
		lm.[IssueDate] AS [LicenceIssueDate]
	FROM [dl].[LicenceMaster] lm
	INNER JOIN [dl].[LicenceHolderMaster] lhm ON lm.[LicenceMasterId] = lhm.[LicenceMasterId]
	INNER JOIN [person].[Person] p ON lhm.[PersonId] = p.[PersonId]
	INNER JOIN [person].[Individual] pin ON lhm.[PersonId] = pin.[PersonId]
	INNER JOIN [dl].[LicenceStateMaster] lsm ON lm.[LicenceStateMasterId] = lsm.[LicenceStateMasterId]
	LEFT OUTER JOIN [dl].[LicenceState] ls ON lm.[LicenceStateId] = ls.[LicenceStateId]
	LEFT OUTER JOIN [cabs_dvl].[VehicleDriver] vd ON lm.[LicenceNumber] = vd.[DriverLicenceNumber]
	LEFT OUTER JOIN [dl].[AdditionalArea] aa ON lm.[LicenceMasterId] = aa.[LicenceMasterId]) q
GO

CREATE VIEW [or].[vVehicleLicenceSearch] AS
	SELECT
		ROW_NUMBER() OVER (order by (select [LicenceNumber])) AS Id,
		*
	FROM (SELECT
		lm.[LicenceNumber],
		lm.[RegistrationNumber] AS [VehicleRegistrationNumber],
		p.[PersonTypeId] AS [LicenceHolderType],
		pin.[FirstName] AS [LicenceHolderFirstName],
		pin.[LastName] AS [LicenceHolderLastName],
		pc.[CompanyNumber] AS [LicenceHolderCompanyNumber],
		pc.[CompanyName] AS [LicenceHolderCompanyName],
		p.[PPSN] AS [LicenceHolderPpsn],
		lm.[LicenceTypeId],
		lt.[LicenceType],
		vm.[MakeId] AS [VehicleMakeId],
		vm.[ModelId] AS [VehicleModelId],
		vd.[StartDate] AS [LinkStartDate],
		ra.[StartDate] AS [RentalStartDate],
		lm.[LicenceIssueDate],
		lm.[LicenceExpiryDate],
		lm.[LicenceStateMasterId],
		lsm.[LicenceStateMaster],
		lm.[LicenceStateId],
		ls.[LicenceState]
	FROM [dbo].[LicenceMasterVL] lm
	INNER JOIN [dbo].[LicenceType] lt ON lm.[LicenceTypeId] = lt.[LicenceTypeId]
	INNER JOIN [dbo].[VehicleMaster] vm ON lm.[RegistrationNumber] = vm.[RegistrationNumber]
	INNER JOIN [dbo].[LicenceStateMaster] lsm ON lm.[LicenceStateMasterId] = lsm.[LicenceStateMasterId]
	INNER JOIN [person].[DataSource] pds ON lm.[LicenceHolderId] = pds.[SourceSystemId] and pds.[SourceSystemName] = 'vls'
	INNER JOIN [person].[Person] p ON pds.[PersonId] = p.[PersonId]
	LEFT OUTER JOIN [dbo].[LicenceState] ls ON lm.[LicenceStateId] = ls.[LicenceStateId]
	LEFT OUTER JOIN [person].[Individual] pin ON p.[PersonId] = pin.[PersonId]
	LEFT OUTER JOIN [person].[Company] pc ON p.[PersonId] = pc.[PersonId]
	LEFT OUTER JOIN [cabs_dvl].[VehicleDriver] vd ON lm.[LicenceNumber] = vd.[VehicleLicenseNumber]
	LEFT OUTER JOIN [cabs_rta].[RentalAgreement] ra ON lm.[LicenceNumber] = ra.[VehicleLicenceNo]) q
GO

CREATE VIEW [or].[vSkillsTestResultsSearch] AS
	SELECT
		b.[ID] AS [BookingId],
		p.[PPSN] AS [Ppsn],
		b.[ConfirmationNumber],
		p.[FirstName],
		p.[LastName],
		p.[DateOfBirth]
	FROM [cabs_sk].[Booking] b
	INNER JOIN [cabs_sk].[Candidate] c on b.[CandidateID] = c.[ID]
	INNER JOIN [cabs_cmo].[Person] p on c.[PersonID] = p.[ID]
	INNER JOIN [cabs_sk].[CandidateTest] ct on b.[ID] = ct.[BookingID]
	INNER JOIN [cabs_sk].Test t on b.TestID = t.ID and t.Code in ('SPSV', 'SPSVx2', 'RET_IK', 'RET_AK', 'RET_IKx2', 'RET_AKx2')
	where ct.[ResultID] = 2
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230308080627_OnlineRegister_Search_VL_DL_Skills_Views', N'6.0.14');
GO

COMMIT;
GO

