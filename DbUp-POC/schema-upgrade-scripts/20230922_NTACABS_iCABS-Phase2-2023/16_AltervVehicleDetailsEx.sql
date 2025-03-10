USE [cabs_production]
GO

/****** Object:  View [cabs_enf].[vVehicleDetailsEx]    Script Date: 25/10/2023 10:37:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [cabs_enf].[vVehicleDetailsEx]
AS

SELECT DISTINCT
		lm.PlateNumber,
		lm.LicenceNumber AS VehicleLicenceNumber,
		lm.LicenceHolderId,
		lm.LicenceTypeId,
		lt.LicenceType,
		lt.LicenceTypeShortCode,
		--lh.FirstName AS HolderFirstName, lh.LastName AS HolderLastName, lh.CompanyName as HolderCompanyName,
		LTRIM(CONCAT(lh.FirstName, ' ', lh.LastName, lh.CompanyName)) AS [HolderName],
		--RTRIM(CONCAT(lh.PhoneNo1, ' ', lh.PhoneNo1, ' ', lh.ContactNumberFax)) AS [Phone],
		ISNULL(lh.PhoneNo1, lh.PhoneNo2) AS [Phone],
		dc.CountyName as Area,
		lh.AddressLine1, lh.AddressLine2, lh.AddressLine3,
		vm.RegistrationNumber AS VehicleRegistrationNumber,
		make.Make, model.Model, colour.Colour,
		lm.LicenceExpiryDate,
		vm.NumberSeats,
		vm.NumberPassengers,
		ra.IsActive AS IsRentalAgreementActive,
		ra.Name AS RentedTo,
		ra.DriverLicenceNo as RentalDL,
		ra.StartDate,
		ls.LicenceStateMaster as [Status], 
		p.PersonId as LicenceHolderPersonId
FROM
		dbo.VehicleMaster AS vm
		LEFT JOIN dbo.LicenceMasterVL AS lm ON lm.RegistrationNumber = vm.RegistrationNumber
		LEFT JOIN dbo.LicenceHolderMaster AS lh ON lh.LicenceHolderId = lm.LicenceHolderId
		LEFT JOIN dbo.County AS dc ON lh.CountyID = dc.CountyId
		LEFT JOIN dbo.LicenceStateMaster AS ls ON lm.LicenceStateMasterID = ls.LicenceStateMasterID
		LEFT JOIN (
			SELECT top 1 * FROM cabs_rta.RentalAgreement rag 
			WHERE 
				rag.StartDate <= GetDate() and (rag.EndDate >= GetDate() or rag.EndDate is null)
				and (rag.IsActive = 1 or rag.IsActive is null)
				order by CreatedOn desc
			) AS ra ON ra.VehicleLicenceNo = lm.LicenceNumber
		LEFT JOIN dbo.VehicleMake AS make ON vm.MakeId = make.MakeId
		LEFT JOIN dbo.VehicleModel AS model ON vm.ModelId = model.ModelId
		LEFT JOIN dbo.VehicleColour AS colour ON vm.ColourId = colour.ColourId
		LEFT JOIN dbo.LicenceType AS lt ON lt.LicenceTypeId = lm.LicenceTypeId
		LEFT JOIN person.Person as p on lh.Ppsn = p.PPSN
GO