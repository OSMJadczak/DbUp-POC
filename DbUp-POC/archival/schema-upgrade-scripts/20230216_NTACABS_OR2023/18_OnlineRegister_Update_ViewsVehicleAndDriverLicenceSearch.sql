BEGIN TRANSACTION;
GO

ALTER VIEW [or].[vDriverLicenceSearch] AS
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
                    -- just active links (no future links)
					and vd.IsActive = 1 and (vd.EndDate >= GETDATE() or vd.EndDate is null)
	            LEFT OUTER JOIN [dl].[AdditionalArea] aa ON lm.[LicenceMasterId] = aa.[LicenceMasterId]
                ) q
GO

ALTER VIEW [or].[vVehicleLicenceSearch] AS
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
                    -- just active links (no future links)
					and vd.IsActive = 1 and (vd.EndDate >= GETDATE() or vd.EndDate is null)
	            LEFT OUTER JOIN [cabs_rta].[RentalAgreement] ra ON lm.[LicenceNumber] = ra.[VehicleLicenceNo]
                    -- just active rentails
                    and ra.StartDate <= GETDATE() and (ra.EndDate >= GETDATE() or ra.EndDate is null)
                ) q
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230525070302_OnlineRegister_Update_ViewsVehicleAndDriverLicenceSearch', N'7.0.5');
GO

COMMIT;
GO

