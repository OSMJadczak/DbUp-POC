USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[RPT_All_Licences_Temp]    Script Date: 4/24/2020 2:23:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Andrew Snook
-- Create date: 14-Apr-2011
-- =============================================
ALTER PROCEDURE [dbo].[RPT_All_Licences_Temp]

@LicenceType int = null

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
LHM.CompanyNumber,
LHM.FirstName,
LHM.LastName,
LHM.CompanyName,
LHM.TradingAs,
C.CountyName,
VMK.Make,
VMD.Model,
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
				AND s.IsActive=1)
FROM dbo.LicenceMasterVL LMVL
INNER JOIN dbo.LicenceType LT on LT.LicenceTypeId = LMVL.LicenceTypeId
INNER JOIN dbo.LicenceHolderMaster LHM on LHM.LicenceHolderId = LMVL.LicenceHolderId
INNER JOIN dbo.VehicleMaster VM on VM.RegistrationNumber = LMVL.RegistrationNumber
LEFT OUTER JOIN dbo.County C on C.CountyId = LHM.CountyId
INNER JOIN dbo.VehicleMake VMK on VMK.MakeId = VM.MakeId
LEFT OUTER JOIN dbo.VehicleModel VMD on VMD.ModelId = VM.ModelId
INNER JOIN dbo.VehicleColour VC on VC.ColourId = VM.ColourId
INNER JOIN dbo.VehicleBodyType VBT on VBT.BodyTypeId = VM.BodyTypeId
LEFT OUTER JOIN dbo.LicenceStateMaster LSM on LSM.LicenceStateMasterId = LMVL.LicenceStateMasterId
LEFT OUTER JOIN dbo.LicenceState LS on LS.LicenceStateId = LMVL.LicenceStateId
LEFT OUTER JOIN cabs_tds.SignageInstallation tds On LMVL.RegistrationNumber=tds.[RegistrationNumber]
LEFT JOIN cabs_tds.AuthorizedSupplier tdsAU ON tds.AuthorizedSupplierId = tdsAU.Id
WHERE (LT.LicenceTypeId = @LicenceType)
ORDER BY LMVL.LicenceNumber ASC

END
GO


