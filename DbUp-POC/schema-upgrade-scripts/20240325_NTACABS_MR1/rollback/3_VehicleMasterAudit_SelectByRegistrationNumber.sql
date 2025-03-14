SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VehicleMasterAudit_SelectByRegistrationNumber]

(
@RegistrationNumber varchar(50)
)

AS
BEGIN

	SET NOCOUNT ON;

SELECT  

V.RegistrationNumber, (datediff(year,[RegistrationDateIreland],getdate())) as VehicleAge, 
V.VIN, V.EngineCapacity, V.TurboDieselYn,
V.NumberPassengers, V.OccupancyWithWheelchair, V.NumberSeats, V.NumberDoors,
V.YearOfManufacture, V.RegistrationDateOrigin, V.RegistrationDateIreland,
V.VrtVehicleCategory, V.NctSerialNumber, V.NctIssueDate, V.NctExpiryDate,
V.InsuranceExpiryDate, V.InsuranceClassCorrect, V.TypeApprovalNumber,
V.TypeApprovalCategory, V.PermissibleMassGvw, V.SimiCode, 
V.MileageReading, V.ExcessWindowTint, V.DataCheckedDate,
V.CreatedBy, V.CreatedDate, V.ModifiedBy, V.ModifiedDate,V.AuditDate,
V.LastDocumentationCheckDate, 
MA.MakeId as MA_MakeId, MA.Make as MA_MakeName,
MO.ModelId as MO_ModelId, MO.Model as MO_ModelName, 
BT.BodyTypeId as BT_BodyTypeId, BT.BodyType as BT_BodyType,
FT.FuelTypeId as FT_FuelTypeId, FT.FuelType as FT_FuelType,
CL.ColourId as CL_ColourId, CL.Colour as CL_Colour,

TC.TestCentreId as TC_TestCentreId, TC.TestCentreName as TC_TestCentreName, 
TC.AddressLine1 as TC_AddressLine1, TC.AddressLine2 as TC_AddressLine2,
TC.AddressLine3 as TC_AddressLine3, TC.Town as TC_Town, TC.PostCode as TC_PostCode, TC.Eircode as TC_Eircode,
TC.ContactName as TC_ContactName, 
TC.ContactNumberPrimary as TC_ContactNumberPrimary, 
TC.ContactNumberSecondary as TC_ContactNumberSecondary, 
TC.Email as TC_Email,
TC.CreatedBy as TC_CreatedBy, TC.CreatedDate as TC_CreatedDate, 
TC.ModifiedBy as TC_ModifiedBy, TC.ModifiedDate as TC_ModifiedDate,

TCC.CountyId as TCC_CountyId, TCC.CountyName as TCC_CountyName,				
TCCR.CountryId as TCCR_CountryId, TCCR.CountryName as TCCR_CountryName,	
TCR.RegionId as TCR_RegionId, TCR.RegionName as TCR_RegionName,
		
TCCO.CompanyId as TCCO_CompanyId, TCCO.CompanyName as TCCO_CompanyName, 
TCCO.CompanyNumber as TCCO_CompanyNumber, TCCO.VatNumber as TCCO_VatNumber, 
TCCO.AddressLine1 as TCCO_AddressLine1, TCCO.AddressLine2 as TCCO_AddressLine2,
TCCO.AddressLine3 as TCCO_AddressLine3, TCCO.Town as TCCO_Town,  
TCCO.PostCode as TCCO_PostCode, TCCO.ContactName as TCCO_ContactName,
TCCO.ContactNumberPrimary as TCCO_ContactNumberPrimary, TCCO.ContactNumberSecondary as TCCO_ContactNumberSecondary, 
TCCO.ContactNumberFax as TCCO_ContactNumberFax, TCCO.Email as TCCO_Email,
TCCO.CreatedBy as TCCO_CreatedBy, TCCO.CreatedDate as TCCO_CreatedDate, 
TCCO.ModifiedBy as TCCO_ModifiedBy, TCCO.ModifiedDate as TCCO_ModifiedDate,
		
TCCOC.CountyId as TCCOC_CountyId, TCCOC.CountyName as TCCOC_CountyName,				
TCCOCR.CountryId as TCCOCR_CountryId, TCCOCR.CountryName as TCCOCR_CountryName,

HCT.HistoryChangeId as HCT_HistoryChangeId, HCT.HistoryChangeType as HCT_HistoryChangeType

FROM dbo.VehicleMasterAudit V

LEFT OUTER JOIN dbo.VehicleMake MA on MA.MakeId = V.MakeId
LEFT OUTER JOIN dbo.VehicleBodyType BT on BT.BodyTypeId = V.BodyTypeId
LEFT OUTER JOIN dbo.VehicleFuelType FT on FT.FuelTypeId = V.FuelTypeId
LEFT OUTER JOIN dbo.VehicleColour CL on CL.ColourId = V.ColourId
LEFT OUTER JOIN dbo.VehicleModel MO on MO.ModelId = V.ModelId
LEFT OUTER JOIN dbo.TestCentre TC on TC.TestCentreId = V.TestCenterId
LEFT OUTER JOIN dbo.County TCC on TC.CountyId = TCC.CountyId	
LEFT OUTER JOIN dbo.Country TCCR on TC.CountryId = TCCR.CountryId	
LEFT OUTER JOIN dbo.Region TCR on TC.RegionId = TCR.RegionId	
LEFT OUTER JOIN dbo.Company TCCO on TC.CompanyId = TCCO.CompanyId
LEFT OUTER JOIN dbo.County TCCOC on TC.CountyId = TCCOC.CountyId	
LEFT OUTER JOIN dbo.Country TCCOCR on TC.CountryId = TCCOCR.CountryId	
LEFT OUTER JOIN dbo.HistoryChangeType HCT on V.HistoryChangeId = HCT.HistoryChangeId

WHERE V.RegistrationNumber = @RegistrationNumber

END

GO
