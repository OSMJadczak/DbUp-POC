USE [cabs_production]
GO

/****** Object:  View [dbo].[vLicenceMasterVLAudit]    Script Date: 2021-05-18 14:21:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER VIEW [dbo].[vLicenceMasterVLAudit]
AS

SELECT	
		
L.PlateNumber, L.LicenceNumber, L.LicenceExpiryDate,
L.LicenceIssueDate, L.CoExpiryDate, L.CoIssueDate, 
L.RenewalDate, L.TransferedFromReg, L.RemainingTransfers, 
L.TransferDate, L.OldPlateNumber, L.OldLicenceAuthority, 
L.CreatedBy, L.CreatedDate, L.ModifiedBy, L.ModifiedDate, 
L.LicenceHolderId, L.RegistrationNumber, L.AuditDate,L.LAHArea,L.LAHDriverLicenceNumber,

T.LicenceTypeId as T_LicenceTypeId, T.LicenceType as T_LicenceType, 
T.MaxVehicleAgeYears as T_MaxVehicleAgeYears,
S.LicenceStateId as S_LicenceStateId, S.LicenceStateMasterId as S_LicenceStateMasterId, 
S.LicenceState as S_LicenceState,
SM.LicenceStateMasterId as SM_LicenceStateMasterId, SM.LicenceStateMaster as SM_LicenceStateMaster, 
				
TC.TestCentreId as TC_TestCentreId, TC.TestCentreName as TC_TestCentreName, 
TC.AddressLine1 as TC_AddressLine1, TC.AddressLine2 as TC_AddressLine2,
TC.AddressLine3 as TC_AddressLine3, TC.Town as TC_Town, TC.PostCode as TC_PostCode,
TC.ContactName as TC_ContactName, 
TC.ContactNumberPrimary as TC_ContactNumberPrimary, 
TC.ContactNumberSecondary as TC_ContactNumberSecondary, 
TC.ContactNumberFax as TC_ContactNumberFax, TC.Email as TC_Email,
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

HCT.HistoryChangeId as HCT_HistoryChangeId, HCT.HistoryChangeType as HCT_HistoryChangeType,
		
L.Ccsn, L.Ppsn, 
(case when isnull(L.[CompanyName],'')='' then ([FirstName]+' ')+[LastName] else L.[CompanyName] end) as HolderName,
L.FirstName, L.LastName, L.DateOfBirth, 
L.CompanyNumber, L.CompanyName, L.TradingAs,
L.AddressLine1, L.AddressLine2, L.AddressLine3,
L.Town, L.PostCode, L.PhoneNo1, L.PhoneNo2,
L.Email, 
L.TaxClearanceNumber, L.TaxClearanceCertExists, L.TaxClearanceStatus,
L.TaxClearanceVisual, L.TaxClearanceName,

	
HC.CountyId as HC_CountyId, HC.CountyName as HC_CountyName, HC.HasPostcode as HC_HasPostcode, 
HCR.CountryId as HCR_CountryId, HCR.CountryName as HCR_CountryName
, L.Director1Name
, L.Director2Name
, L.Director3Name
, L.Director1Address
, L.Director2Address
, L.Director3Address
, L.EVGrantStatusId
, L.EVGrantExpiryDate
, EV.Description as EVGrantStatusDescription
, L.WAVGrantStatusId
, L.WAVGrantExpiryDate
, WAV.Description as WAVGrantStatusDescription
, DO.CompanyOwnerName as AffiliatedDO
, L.EmailAddressForBooking as WavEmail
, L.NumberForBookings
, L.WebSite
, L.AreaOfOpperations
, SGS.Id as ScrappageGrantStatusId
, SGS.Description as ScrappageGrantStatusDescription
FROM LicenceMasterVLAudit L

LEFT OUTER JOIN dbo.LicenceType T on L.LicenceTypeId = T.LicenceTypeId
LEFT OUTER JOIN dbo.LicenceState S on L.LicenceStateId = S.LicenceStateId
LEFT OUTER JOIN dbo.LicenceStateMaster SM on L.LicenceStateMasterId = SM.LicenceStateMasterId
LEFT OUTER JOIN dbo.HistoryChangeType HCT on L.HistoryChangeId = HCT.HistoryChangeId
LEFT OUTER JOIN dbo.TestCentre TC on L.TestCenterId = TC.TestCentreId
LEFT OUTER JOIN dbo.County TCC on TC.CountyId = TCC.CountyId	
LEFT OUTER JOIN dbo.Country TCCR on TC.CountryId = TCCR.CountryId	
LEFT OUTER JOIN dbo.Region TCR on TC.RegionId = TCR.RegionId	
LEFT OUTER JOIN dbo.Company TCCO on TC.CompanyId = TCCO.CompanyId
LEFT OUTER JOIN dbo.County TCCOC on TC.CountyId = TCCOC.CountyId	
LEFT OUTER JOIN dbo.Country TCCOCR on TC.CountryId = TCCOCR.CountryId	
LEFT OUTER JOIN dbo.County HC on L.CountyId = HC.CountyId
LEFT OUTER JOIN dbo.Country HCR on L.CountryId = HCR.CountryId 
LEFT OUTER JOIN dbo.WavGrantStatus WAV on L.WAVGrantStatusId = WAV.WavGrantStatusId
LEFT OUTER JOIN dbo.EVGrantStatus EV on L.EVGrantStatusId = EV.EVGrantStatusId
LEFT OUTER JOIN dbo.DispatchOperatorMaster DO on L.DispatchOperatorId = DO.LicenceHolderId
LEFT OUTER JOIN dbo.ScrappageGrantStatuses SGS on L.ScrappageGrantStatusId = SGS.Id

GO


