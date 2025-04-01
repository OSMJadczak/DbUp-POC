USE [cabs_production]
GO

/****** Object:  View [dbo].[AllData]    Script Date: 4/24/2020 10:46:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[AllData]
AS
SELECT     l.LicenceNumber, l.LicenceHolderId AS lh_licenceholderid, l.RegistrationNumber, l.LicenceTypeId, l.LicenceStateId, l.LicenceIssueDate, l.LicenceExpiryDate, 
                      l.LicenceStateMasterId, l.CoExpiryDate, l.CoIssueDate, l.RenewalDate, l.TransferedFromReg, l.RemainingTransfers, l.TransferDate, l.OldPlateNumber, 
                      l.OldLicenceAuthority, dbo.LicenceState.LicenceState, dbo.LicenceStateMaster.LicenceStateMaster, dbo.LicenceType.LicenceType, c.CountyName, lh.LicenceHolderId, 
                      lh.Ccsn, lh.Ppsn, lh.HolderName, lh.LastName, lh.FirstName, lh.DateOfBirth, lh.CompanyNumber, lh.CompanyName, lh.TradingAs, lh.AddressLine1, 
                      lh.AddressLine2, lh.AddressLine3, lh.Town, lh.CountyId, lh.PostCode, lh.CountryId, lh.IrishLanguageAddress, lh.PhoneNo1, lh.PhoneNo2, 
                      lh.Email, lh.EmailOptIn, lh.TaxClearanceNumber, lh.TaxClearanceExpiryDate, lh.TaxClearanceStatus, lh.TaxClearanceVisual, lh.TaxClearanceName, 
                      lh.LastDocumentationCheckDate, lh.TaxHead, lh._6DigitCode, lh.Comments, lh.DeceasedYn, lh.GardaDivisionID, l.PlateNumber, vbt.BodyType, vc.Colour, vmo.Model, 
                      dbo.VehicleMake.Make, vf.FuelType, v.RegistrationNumber AS Expr2, v.VehicleAge, v.RegistrationDate, v.VIN, v.EngineCapacity, v.TurboDieselYn, v.ModifiedYn, 
                      v.NumberPassengers, v.NumberSeats, v.NumberDoors, v.YearOfManufacture, v.RegistrationDateOrigin, v.VrtVehicleCategory, v.NctSerialNumber, 
                      v.RegistrationDateIreland, v.NctIssueDate, v.NctExpiryDate, v.LastDocumentationCheckDate AS Expr3, v.InsuranceExpiryDate, v.InsuranceClassCorrect, 
                      v.TypeApprovalNumber, v.TypeApprovalCategory, v.PermissibleMassGvw, v.SimiCode, v.MileageReading, v.DataCheckedDate, v.ExcessWindowTint, 
                      v.RoofSignSticker, v.MeterSealed
FROM         dbo.LicenceMasterVL AS l INNER JOIN
                      dbo.LicenceHolderMaster AS lh ON lh.LicenceHolderId = l.LicenceHolderId INNER JOIN
                      dbo.VehicleMaster AS v ON l.RegistrationNumber = v.RegistrationNumber INNER JOIN
                      dbo.VehicleModel AS vmo ON vmo.ModelId = v.ModelId INNER JOIN
                      dbo.VehicleMake ON v.MakeId = dbo.VehicleMake.MakeId INNER JOIN
                      dbo.VehicleBodyType AS vbt ON vbt.BodyTypeId = v.BodyTypeId INNER JOIN
                      dbo.County AS c ON c.CountyId = lh.CountyId LEFT OUTER JOIN
                      dbo.LicenceState ON l.LicenceStateId = dbo.LicenceState.LicenceStateId INNER JOIN
                      dbo.LicenceStateMaster ON l.LicenceStateMasterId = dbo.LicenceStateMaster.LicenceStateMasterId INNER JOIN
                      dbo.LicenceType ON l.LicenceTypeId = dbo.LicenceType.LicenceTypeId INNER JOIN
                      dbo.VehicleColour AS vc ON vc.ColourId = v.ColourId INNER JOIN
                      dbo.VehicleFuelType AS vf ON vf.FuelTypeId = v.FuelTypeId
GO


