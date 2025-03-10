USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceMasterVL_SelectByLicenceNumber]    Script Date: 2022-04-15 18:18:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceMasterVL_SelectByLicenceNumber]
(
@LicenceNumber varchar(50)
)

AS


BEGIN

SET NOCOUNT ON;
    
    IF CHARINDEX('#', @LicenceNumber) > 0
BEGIN
SELECT @LicenceNumber = left(@LicenceNumber, CHARINDEX('#', @LicenceNumber) - 1)
END

DECLARE @RegistrationNumber VARCHAR(10),
        @LicenceHolderId INT

SELECT L.PlateNumber AS L_PlateNumber
     , L.LicenceNumber AS L_LicenceNumber
     , L.LicenceExpiryDate AS L_LicenceExpiryDate
     , L.LicenceIssueDate AS L_LicenceIssueDate
     , L.CoExpiryDate AS L_CoExpiryDate
     , L.CoIssueDate AS L_CoIssueDate
     , L.RenewalDate AS L_RenewalDate
     , L.TransferedFromReg AS L_TransferedFromReg
     , L.RemainingTransfers AS L_RemainingTransfers
     , L.TransferDate AS L_TransferDate
     , L.OldPlateNumber AS L_OldPlateNumber
     , L.OldLicenceAuthority AS L_OldLicenceAuthority
     , L.CreatedBy AS L_CreatedBy
     , L.CreatedDate AS L_CreatedDate
     , L.ModifiedBy AS L_ModifiedBy
     , L.ModifiedDate AS L_ModifiedDate
     , L.LicenceHolderId AS L_LicenceHolderId
     , L.RegistrationNumber AS L_RegistrationNumber
	 , L.MotorTaxRebateStatusId as L_MotorTaxRebateStatusId
	 , L.MotorTaxRebateDate as L_MotorTaxRebateDate
     , L_T.LicenceTypeId AS L_T_LicenceTypeId
     , L_T.LicenceType AS L_T_LicenceType
     , L_T.NewLicenceFeeId AS L_T_NewLicenceFeeId
     , L_T.MaxVehicleAgeYears AS L_T_MaxVehicleAgeYears
     , L_T.MaxVehicleAgeYears1 AS L_T_MaxVehicleAgeYears1
     , L_S.LicenceStateId AS L_S_LicenceStateId
     , L_S.LicenceStateMasterId AS L_S_LicenceStateMasterId
     , L_S.LicenceState AS L_S_LicenceState
     , L_SM.LicenceStateMasterId AS L_SM_LicenceStateMasterId
     , L_SM.LicenceStateMaster AS L_SM_LicenceStateMaster
     , L_TC.TestCentreId AS L_TC_TestCentreId
     , L_TC.TestCentreName AS L_TC_TestCentreName
     , L_TC.AddressLine1 AS L_TC_AddressLine1
     , L_TC.AddressLine2 AS L_TC_AddressLine2
     , L_TC.AddressLine3 AS L_TC_AddressLine3
     , L_TC.Town AS L_TC_Town
     , L_TC.PostCode AS L_TC_PostCode
     , L_TC.Eircode AS L_TC_Eircode
     , L_TC.ContactName AS L_TC_ContactName
     , L_TC.ContactNumberPrimary AS L_TC_ContactNumberPrimary
     , L_TC.ContactNumberSecondary AS L_TC_ContactNumberSecondary
     , L_TC.Email AS L_TC_Email
     , L_TC.CreatedBy AS L_TC_CreatedBy
     , L_TC.CreatedDate AS L_TC_CreatedDate
     , L_TC.ModifiedBy AS L_TC_ModifiedBy
     , L_TC.ModifiedDate AS L_TC_ModifiedDate
     , L_TCC.CountyId AS L_TCC_CountyId
     , L_TCC.CountyName AS L_TCC_CountyName
     , L_TCCR.CountryId AS L_TCCR_CountryId
     , L_TCCR.CountryName AS L_TCCR_CountryName
     , L_TCR.RegionId AS L_TCR_RegionId
     , L_TCR.RegionName AS L_TCR_RegionName
     , L_TCCO.CompanyId AS L_TCCO_CompanyId
     , L_TCCO.CompanyName AS L_TCCO_CompanyName
     , L_TCCO.CompanyNumber AS L_TCCO_CompanyNumber
     , L_TCCO.VatNumber AS L_TCCO_VatNumber
     , L_TCCO.AddressLine1 AS L_TCCO_AddressLine1
     , L_TCCO.AddressLine2 AS L_TCCO_AddressLine2
     , L_TCCO.AddressLine3 AS L_TCCO_AddressLine3
     , L_TCCO.Town AS L_TCCO_Town
     , L_TCCO.PostCode AS L_TCCO_PostCode
     , L_TCCO.ContactName AS L_TCCO_ContactName
     , L_TCCO.ContactNumberPrimary AS L_TCCO_ContactNumberPrimary
     , L_TCCO.ContactNumberSecondary AS L_TCCO_ContactNumberSecondary
     , L_TCCO.ContactNumberFax AS L_TCCO_ContactNumberFax
     , L_TCCO.Email AS L_TCCO_Email
     , L_TCCO.CreatedBy AS L_TCCO_CreatedBy
     , L_TCCO.CreatedDate AS L_TCCO_CreatedDate
     , L_TCCO.ModifiedBy AS L_TCCO_ModifiedBy
     , L_TCCO.ModifiedDate AS L_TCCO_ModifiedDate
     , L_TCCOC.CountyId AS L_TCCOC_CountyId
     , L_TCCOC.CountyName AS L_TCCOC_CountyName
     , L_TCCOCR.CountryId AS L_TCCOCR_CountryId
     , L_TCCOCR.CountryName AS L_TCCOCR_CountryName
     , L_HCT.HistoryChangeId AS L_HCT_HistoryChangeId
     , L_HCT.HistoryChangeType AS L_HCT_HistoryChangeType
     , V.RegistrationNumber AS V_RegistrationNumber
     , V.VehicleAge AS V_VehicleAge
     , V.VIN AS V_VIN
     , V.EngineCapacity AS V_EngineCapacity
     , V.TurboDieselYn AS V_TurboDieselYn
     , V.NumberPassengers AS V_NumberPassengers
     , V.OccupancyWithWheelchair AS V_OccupancyWithWheelchair
     , V.NumberSeats AS V_NumberSeats
     , V.NumberDoors AS V_NumberDoors
     , V.YearOfManufacture AS V_YearOfManufacture
     , V.RegistrationDateOrigin AS V_RegistrationDateOrigin
     , V.RegistrationDateIreland AS V_RegistrationDateIreland
     , V.RegistrationDate AS V_RegistrationDate
     , V.LastDocumentationCheckDate AS V_LastDocumentationCheckDate
     , V.VrtVehicleCategory AS V_VrtVehicleCategory
     , V.NctSerialNumber AS V_NctSerialNumber
     , V.NctIssueDate AS V_NctIssueDate
     , V.NctExpiryDate AS V_NctExpiryDate
     , V.InsuranceExpiryDate AS V_InsuranceExpiryDate
     , V.InsuranceClassCorrect AS V_InsuranceClassCorrect
     , V.TypeApprovalNumber AS V_TypeApprovalNumber
     , V.TypeApprovalCategory AS V_TypeApprovalCategory
     , V.PermissibleMassGvw AS V_PermissibleMassGvw
     , V.SimiCode AS V_SimiCode
     , V.MileageReading AS V_MileageReading
     , V.ExcessWindowTint AS V_ExcessWindowTint
     , V.DataCheckedDate AS V_DataCheckedDate
     , V.CreatedBy AS V_CreatedBy
     , V.CreatedDate AS V_CreatedDate
     , V.ModifiedBy AS V_ModifiedBy
     , V.ModifiedDate AS V_ModifiedDate
     , V_MA.MakeId AS V_MA_MakeId
     , V_MA.Make AS V_MA_MakeName
     , V_MO.ModelId AS V_MO_ModelId
     , V_MO.Model AS V_MO_ModelName
     , V_BT.BodyTypeId AS V_BT_BodyTypeId
     , V_BT.BodyType AS V_BT_BodyType
     , V_FT.FuelTypeId AS V_FT_FuelTypeId
     , V_FT.FuelType AS V_FT_FuelType
     , V_CL.ColourId AS V_CL_ColourId
     , V_CL.Colour AS V_CL_Colour
     , V_TC.TestCentreId AS V_TC_TestCentreId
     , V_TC.TestCentreName AS V_TC_TestCentreName
     , V_TC.AddressLine1 AS V_TC_AddressLine1
     , V_TC.AddressLine2 AS V_TC_AddressLine2
     , V_TC.AddressLine3 AS V_TC_AddressLine3
     , V_TC.Town AS V_TC_Town
     , V_TC.PostCode AS V_TC_PostCode
     , V_TC.Eircode AS V_TC_Eircode
     , V_TC.ContactName AS V_TC_ContactName
     , V_TC.ContactNumberPrimary AS V_TC_ContactNumberPrimary
     , V_TC.ContactNumberSecondary AS V_TC_ContactNumberSecondary
     , V_TC.Email AS V_TC_Email
     , V_TC.CreatedBy AS V_TC_CreatedBy
     , V_TC.CreatedDate AS V_TC_CreatedDate
     , V_TC.ModifiedBy AS V_TC_ModifiedBy
     , V_TC.ModifiedDate AS V_TC_ModifiedDate
     , V_TCC.CountyId AS V_TCC_CountyId
     , V_TCC.CountyName AS V_TCC_CountyName
     , V_TCCR.CountryId AS V_TCCR_CountryId
     , V_TCCR.CountryName AS V_TCCR_CountryName
     , V_TCR.RegionId AS V_TCR_RegionId
     , V_TCR.RegionName AS V_TCR_RegionName
     , V_TCCO.CompanyId AS V_TCCO_CompanyId
     , V_TCCO.CompanyName AS V_TCCO_CompanyName
     , V_TCCO.CompanyNumber AS V_TCCO_CompanyNumber
     , V_TCCO.VatNumber AS V_TCCO_VatNumber
     , V_TCCO.AddressLine1 AS V_TCCO_AddressLine1
     , V_TCCO.AddressLine2 AS V_TCCO_AddressLine2
     , V_TCCO.AddressLine3 AS V_TCCO_AddressLine3
     , V_TCCO.Town AS V_TCCO_Town
     , V_TCCO.PostCode AS V_TCCO_PostCode
     , V_TCCO.ContactName AS V_TCCO_ContactName
     , V_TCCO.ContactNumberPrimary AS V_TCCO_ContactNumberPrimary
     , V_TCCO.ContactNumberSecondary AS V_TCCO_ContactNumberSecondary
     , V_TCCO.ContactNumberFax AS V_TCCO_ContactNumberFax
     , V_TCCO.Email AS V_TCCO_Email
     , V_TCCO.CreatedBy AS V_TCCO_CreatedBy
     , V_TCCO.CreatedDate AS V_TCCO_CreatedDate
     , V_TCCO.ModifiedBy AS V_TCCO_ModifiedBy
     , V_TCCO.ModifiedDate AS V_TCCO_ModifiedDate
     , V_TCCOC.CountyId AS V_TCCOC_CountyId
     , V_TCCOC.CountyName AS V_TCCOC_CountyName
     , V_TCCOCR.CountryId AS V_TCCOCR_CountryId
     , V_TCCOCR.CountryName AS V_TCCOCR_CountryName
     , V_HCT.HistoryChangeId AS V_HCT_HistoryChangeId
     , V_HCT.HistoryChangeType AS V_HCT_HistoryChangeType
     , H.LicenceHolderId AS H_LicenceHolderId
     , H.Ccsn AS H_Ccsn
     , H.Ppsn AS H_Ppsn
     , H.HolderName AS H_HolderName
     , H.FirstName AS H_FirstName
     , H.LastName AS H_LastName
     , H.DateOfBirth AS H_DateOfBirth
     , H.CompanyNumber AS H_CompanyNumber
     , H.CompanyName AS H_CompanyName
     , H.TradingAs AS H_TradingAs
     , H.AddressLine1 AS H_AddressLine1
     , H.AddressLine2 AS H_AddressLine2
     , H.AddressLine3 AS H_AddressLine3
     , H.Town AS H_Town
     , H.PostCode AS H_PostCode
     , H.PhoneNo1 AS H_PhoneNo1
     , H.PhoneNo2 AS H_PhoneNo2
     , H.Email AS H_Email
     , H.EmailOptIn AS H_EmailOptIn
     , H.MailOptIn AS H_MailOptIn
     , H.TaxClearanceNumber AS H_TaxClearanceNumber
     , H.TaxClearanceExpiryDate AS H_TaxClearanceExpiryDate
	 , H.TaxClearanceCertExists AS H_TaxClearanceCertExists
     , H.TaxClearanceStatus AS H_TaxClearanceStatus
     , H.TaxClearanceVisual AS H_TaxClearanceVisual
     , H.TaxClearanceName AS H_TaxClearanceName
     , H.DeceasedYn AS H_DeceasedYn
     , H.CreatedBy AS H_CreatedBy
     , H.CreatedDate AS H_CreatedDate
     , H.ModifiedBy AS H_ModifiedBy
     , H.ModifiedDate AS H_ModifiedDate
     , H.IrishLanguageAddress AS H_IrishLanguageAddress
     , H.LastDocumentationCheckDate AS H_LastDocumentationCheckDate
     , HC.CountyId AS H_C_CountyId
     , HC.CountyName AS H_C_CountyName
     , HC.HasPostcode AS H_C_HasPostcode
     , HCR.CountryId AS H_CR_CountryId
     , HCR.CountryName AS H_CR_CountryName
     , L.FinalOperationDate
     , isnull(WGS.Description, 'No') AS 'WGS_Description'
     , WR.WavGrantExpiryDate AS WR_WavGrantExpiryDate
	 , WR.WavGrantStatusID as WR_WavGrantStatusId
     , L.Exchanged
     , LAH.Area as LAHArea
     , LAH.DriverLicenceNumber as LAHDriverLicenceNumber
	 , L.SuspensionStartDate
	 , L.SuspensionEndDate
	 , EVS.Description AS 'EVGrantStatusDescription'
	 , EVS.EVGrantStatusId AS 'EVGrantStatusId'
	 , EVR.EVGrantExpiryDate
	 , MTS.Description as 'MTRebateStatusDescription'
	 , SGS.Id as 'ScrappageGrantStatusId'
	 , SGS.Description as 'ScrappageGrantStatusDescription'
	 , SGS.Active as 'ScrappageGrantStatusActive'
	 , CD1.CompanyDirectorName AS CD1_DirectorName
	 , TRIM(', ' FROM REPLACE(CONCAT(CD1.AddressLine1, ', ', CD1.AddressLine2, ', ', CD1.AddressLine3, ', ', CD1.Town, ', ', CD1_County.CountyName, ', ', CD1.PostCode, ', ', CD1.Eircode, ', ', CD1_Country.CountryName), ' ,', '')) AS CD1_DirectorAddress
     , CD2.CompanyDirectorName AS CD2_DirectorName
	 , TRIM(', ' FROM REPLACE(CONCAT(CD2.AddressLine1, ', ', CD2.AddressLine2, ', ', CD2.AddressLine3, ', ', CD2.Town, ', ', CD2_County.CountyName, ', ', CD2.PostCode, ', ', CD2.Eircode, ', ', CD2_Country.CountryName), ' ,', '')) AS CD2_DirectorAddress
     , CD3.CompanyDirectorName AS CD3_DirectorName
	 , TRIM(', ' FROM REPLACE(CONCAT(CD3.AddressLine1, ', ', CD3.AddressLine2, ', ', CD3.AddressLine3, ', ', CD3.Town, ', ', CD3_County.CountyName, ', ', CD3.PostCode, ', ', CD3.Eircode, ', ', CD3_Country.CountryName), ' ,', '')) AS CD3_DirectorAddress
FROM
    LicenceMasterVL L

    INNER JOIN dbo.LicenceType L_T
        ON L.LicenceTypeId = L_T.LicenceTypeId
    INNER JOIN dbo.VehicleMaster V
        ON L.RegistrationNumber = V.RegistrationNumber
    INNER JOIN dbo.LicenceHolderMaster H
        ON L.LicenceHolderId = H.LicenceHolderId
    LEFT OUTER JOIN dbo.LicenceState L_S
        ON L.LicenceStateId = L_S.LicenceStateId
    LEFT OUTER JOIN dbo.LicenceStateMaster L_SM
        ON L.LicenceStateMasterId = L_SM.LicenceStateMasterId
    LEFT OUTER JOIN dbo.HistoryChangeType L_HCT
        ON L.HistoryChangeId = L_HCT.HistoryChangeId
    LEFT OUTER JOIN dbo.TestCentre L_TC
        ON L.TestCenterId = L_TC.TestCentreId
    LEFT OUTER JOIN dbo.County L_TCC
        ON L_TC.CountyId = L_TCC.CountyId
    LEFT OUTER JOIN dbo.Country L_TCCR
        ON L_TC.CountryId = L_TCCR.CountryId
    LEFT OUTER JOIN dbo.Region L_TCR
        ON L_TC.RegionId = L_TCR.RegionId
    LEFT OUTER JOIN dbo.Company L_TCCO
        ON L_TC.CompanyId = L_TCCO.CompanyId
    LEFT OUTER JOIN dbo.County L_TCCOC
        ON L_TC.CountyId = L_TCCOC.CountyId
    LEFT OUTER JOIN dbo.Country L_TCCOCR
        ON L_TC.CountryId = L_TCCOCR.CountryId

    LEFT OUTER JOIN dbo.VehicleMake V_MA
        ON V.MakeId = V_MA.MakeId
    LEFT OUTER JOIN dbo.VehicleModel V_MO
        ON V.ModelId = V_MO.ModelId
    LEFT OUTER JOIN dbo.VehicleBodyType V_BT
        ON V.BodyTypeId = V_BT.BodyTypeId
    LEFT OUTER JOIN dbo.VehicleFuelType V_FT
        ON V.FuelTypeId = V_FT.FuelTypeId
    LEFT OUTER JOIN dbo.VehicleColour V_CL
        ON V.ColourId = V_CL.ColourId
    LEFT OUTER JOIN dbo.TestCentre V_TC
        ON V_TC.TestCentreId = V.TestCenterId
    LEFT OUTER JOIN dbo.County V_TCC
        ON V_TC.CountyId = V_TCC.CountyId
    LEFT OUTER JOIN dbo.Country V_TCCR
        ON V_TC.CountryId = V_TCCR.CountryId
    LEFT OUTER JOIN dbo.Region V_TCR
        ON V_TC.RegionId = V_TCR.RegionId
    LEFT OUTER JOIN dbo.Company V_TCCO
        ON V_TC.CompanyId = V_TCCO.CompanyId
    LEFT OUTER JOIN dbo.County V_TCCOC
        ON V_TC.CountyId = V_TCCOC.CountyId
    LEFT OUTER JOIN dbo.Country V_TCCOCR
        ON V_TC.CountryId = V_TCCOCR.CountryId
    LEFT OUTER JOIN dbo.HistoryChangeType V_HCT
        ON V.HistoryChangeId = V_HCT.HistoryChangeId

	LEFT OUTER JOIN [cabs_production].[person].[DataSource] DS 
		ON L.LicenceHolderId = DS.SourceSystemId and DS.SourceSystemName = 'VLS'
	LEFT OUTER JOIN [cabs_production].[person].[Company] C 
		ON C.PersonId = DS.PersonId

	LEFT OUTER JOIN (SELECT *, ROW_NUMBER() OVER (PARTITION BY CompanyId ORDER BY CompanyDirectorId ASC) AS RN from [cabs_production].[person].[CompanyDirector]) CD1
		ON CD1.CompanyId = C.CompanyId AND CD1.RN = 1
	LEFT OUTER JOIN [cabs_production].[person].[County] CD1_County 
		ON CD1.CountyId = CD1_County.CountyId
	LEFT OUTER JOIN [cabs_production].[person].[Country] CD1_Country
		ON CD1_County.CountryId = CD1_Country.CountryId

	LEFT OUTER JOIN (SELECT *, ROW_NUMBER() OVER (PARTITION BY CompanyId ORDER BY CompanyDirectorId ASC) AS RN from [cabs_production].[person].[CompanyDirector]) CD2
		ON CD2.CompanyId = C.CompanyId  AND CD2.RN = 2
	LEFT OUTER JOIN [cabs_production].[person].[County] CD2_County 
		ON CD2.CountyId = CD2_County.CountyId
	LEFT OUTER JOIN [cabs_production].[person].[Country] CD2_Country
		ON CD2_County.CountryId = CD2_Country.CountryId

	LEFT OUTER JOIN (SELECT *, ROW_NUMBER() OVER (PARTITION BY CompanyId ORDER BY CompanyDirectorId ASC) AS RN from [cabs_production].[person].[CompanyDirector]) CD3
		ON CD3.CompanyId = C.CompanyId  AND CD3.RN = 3
	LEFT OUTER JOIN [cabs_production].[person].[County] CD3_County 
		ON CD3.CountyId = CD3_County.CountyId
	LEFT OUTER JOIN [cabs_production].[person].[Country] CD3_Country
		ON CD3_County.CountryId = CD3_Country.CountryId

    LEFT OUTER JOIN dbo.County HC
        ON H.CountyId = HC.CountyId
    LEFT OUTER JOIN dbo.Country HCR
        ON H.CountryId = HCR.CountryId

    LEFT OUTER JOIN dbo.WatRegister WR
        ON WR.LicenceNumber = L.LicenceNumber
    LEFT OUTER JOIN dbo.WavGrantStatus WGS
        ON WGS.WavGrantStatusId = WR.WavGrantStatusId
	LEFT OUTER JOIN dbo.LAHLink LAH
		ON L.LicenceNumber = LAH.VehicleLicenceNumber

	LEFT OUTER JOIN dbo.EVGrantRegister EVR
		ON EVR.LicenceNumber = L.LicenceNumber
	LEFT OUTER JOIN dbo.EVGrantStatus EVS
        ON EVR.EVGrantStatusId = EVS.EVGrantStatusId
	LEFT OUTER JOIN dbo.MTRebateStatus MTS
        ON L.MotorTaxRebateStatusId = MTS.MTRebateStatusId

	LEFT OUTER JOIN dbo.ScrappageGrantStatuses SGS
		ON L.ScrappageGrantStatusId = SGS.Id


WHERE
    @LicenceNumber = L.LicenceNumber


END





GO


