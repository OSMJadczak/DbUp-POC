USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[RPT_All_Licences]    Script Date: 4/24/2020 2:21:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER    PROCEDURE [dbo].[RPT_All_Licences]
@LicenceStatus varchar(max),
@LicenceType varchar(max) 

AS
BEGIN
	SET NOCOUNT ON;

SELECT 
	LHM.Email,
	LHM.CCSN,
	LMVL.LicenceNumber,
	LT.LicenceType,
	LMVL.RegistrationNumber,
	LSM.LicenceStateMaster As LicenceStatus,
	LS.LicenceState As LicenceSubStatus,
	LMVL.LicenceExpiryDate,
	LMVL.LicenceIssueDate,
	LMVL.RenewalDate,
	LMVL.FinalOperationDate,
	LMVL.Exchanged,
	LHM.CompanyNumber,
	LHM.FirstName,
	LHM.LastName,
	LHM.CompanyName,
	LHM.TradingAs,
	LHM.Ppsn,
	LHM.DeceasedYn,
	LHM.AddressLine1,
	LHM.AddressLine2,
	LHM.AddressLine3,
	LHM.Town,
	LHM.PostCode,
	LHM.PhoneNo1,
	LHM.PhoneNo2,
	CTR.CountryName,
	C.CountyName,
	VMK.Make,
	VMD.Model,
	ISNULL(FT.FuelType, 'Unknown') AS 'FuelType',
	VBT.BodyType,
	VM.EngineCapacity,
	VC.Colour,
	VM.VIN,
	VM.YearOfManufacture,
	VM.RegistrationDateIreland,
	VM.RegistrationDateOrigin,
	VM.VehicleAge,
	VM.NumberPassengers,
	VM.NumberSeats,
	VM.NumberDoors,
	VM.TypeApprovalNumber,
	VM.TypeApprovalCategory,
	VM.VrtVehicleCategory,
	VM.SimiCode,
	VM.MileageReading,
	VM.InsuranceExpiryDate,
	VM.InsuranceClassCorrect,
	VM.ExcessWindowTint,
	VM.NctSerialNumber,
	VM.NctExpiryDate,
	VM.NctIssueDate,
	SignageAppliedDate=(Select CreatedON from cabs_tds.SignageInstallation 
					where VehicleLicenceNumber=LMVL.LicenceNumber AND RegistrationNumber=LMVL.RegistrationNumber
				AND IsActive=1),
	SupplierRef =	(Select tdsAU.SupplierId from cabs_tds.SignageInstallation s
					join cabs_tds.AuthorizedSupplier tdsAU ON s.AuthorizedSupplierId = tdsAU.Id
					where s.VehicleLicenceNumber=LMVL.LicenceNumber AND s.RegistrationNumber=LMVL.RegistrationNumber
					AND s.IsActive=1),
	case when (LT.LicenceType = 'TAXI' OR LT.LicenceType = 'HACKNEY') then
			(select  [dbo].[VehicleAssociatedOnV2]    ('2013-01-01', LMVL.LicenceNumber))
		else NULL
	END AS Associated_On_2013_01_01,
	case when  (LT.LicenceType = 'WHEELCHAIR ACCESSIBLE TAXI' OR LT.LicenceType = 'WHEELCHAIR ACCESSIBLE HACKNEY') THEN
			(select  [dbo].[VehicleAssociatedOnV2]    ('2014-04-01', LMVL.LicenceNumber))
	else NULL
	END AS Associated_On_2014_04_01
FROM dbo.LicenceMasterVL LMVL
	INNER JOIN dbo.LicenceType LT on LT.LicenceTypeId = LMVL.LicenceTypeId
	INNER JOIN dbo.LicenceHolderMaster LHM on LHM.LicenceHolderId = LMVL.LicenceHolderId
	INNER JOIN dbo.VehicleMaster VM on VM.RegistrationNumber = LMVL.RegistrationNumber
	LEFT JOIN dbo.VehicleFuelType FT on FT.FuelTypeId=VM.FuelTypeId
	LEFT OUTER JOIN dbo.County C on C.CountyId = LHM.CountyId
	INNER JOIN dbo.VehicleMake VMK on VMK.MakeId = VM.MakeId
	LEFT OUTER JOIN dbo.VehicleModel VMD on VMD.ModelId = VM.ModelId
	INNER JOIN dbo.VehicleColour VC on VC.ColourId = VM.ColourId
	INNER JOIN dbo.VehicleBodyType VBT on VBT.BodyTypeId = VM.BodyTypeId
	LEFT OUTER JOIN dbo.LicenceStateMaster LSM on LSM.LicenceStateMasterId = LMVL.LicenceStateMasterId
	LEFT OUTER JOIN dbo.LicenceState LS on LS.LicenceStateId = LMVL.LicenceStateId
	LEFT OUTER JOIN dbo.Country CTR on CTR.CountryId = LHM.CountryId
WHERE 1=1
	AND LT.LicenceTypeId  in (select Element from dbo.func_Split(@LicenceType,','))
	AND concat(LSM.LicenceStateMasterId,LS.LicenceStateId) in (select Element from dbo.func_Split(@LicenceStatus,','))
ORDER BY LMVL.LicenceNumber ASC

END
GO


