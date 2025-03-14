USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceHolderMaster_SelectByLicenceHolderId]    Script Date: 2022-04-22 16:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceHolderMaster_SelectByLicenceHolderId]

(
@LicenceHolderId int
)

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

-- Insert statements for procedure here
SELECT H.LicenceHolderId
	 , H.Ccsn
	 , H.Ppsn
	 , H.HolderName
	 , H.FirstName
	 , H.LastName
	 , H.DateOfBirth
	 , H.CompanyNumber
	 , H.CompanyName
	 , H.TradingAs
	 , H.AddressLine1
	 , H.AddressLine2
	 , H.AddressLine3
	 , H.Town
	 , H.PostCode
	 , H.PhoneNo1
	 , H.PhoneNo2
	 , H.Email
	 , H.EmailOptIn
	 , H.MailOptIn
	 , H.TaxClearanceNumber
	 , H.TaxClearanceCertExists	 
	 , H.TaxClearanceName
	 , H.DeceasedYn
	 , H.CreatedBy
	 , H.CreatedDate
	 , H.ModifiedBy
	 , H.ModifiedDate
	 , H.IrishLanguageAddress
	 , H.LastDocumentationCheckDate
	 , HC.CountyId AS HC_CountyId
	 , HC.CountyName AS HC_CountyName
	 , HC.HasPostcode AS HC_HasPostcode
	 , HCR.CountryId AS HCR_CountryId
	 , HCR.CountryName AS HCR_CountryName
	 , CD1.CompanyId AS C_CompanyName
	 , CD1.CompanyDirectorName AS CD1_DirectorName
	 , TRIM(', ' FROM REPLACE(CONCAT(CD1.AddressLine1, ', ', CD1.AddressLine2, ', ', CD1.AddressLine3, ', ', CD1.Town, ', ', CD1_County.CountyName, ', ', CD1.PostCode, ', ', CD1.Eircode, ', ', CD1_Country.CountryName), ' ,', '')) AS CD1_DirectorAddress
     , CD2.CompanyDirectorName AS CD2_DirectorName
	 , TRIM(', ' FROM REPLACE(CONCAT(CD2.AddressLine1, ', ', CD2.AddressLine2, ', ', CD2.AddressLine3, ', ', CD2.Town, ', ', CD2_County.CountyName, ', ', CD2.PostCode, ', ', CD2.Eircode, ', ', CD2_Country.CountryName), ' ,', '')) AS CD2_DirectorAddress
     , CD3.CompanyDirectorName AS CD3_DirectorName
	 , TRIM(', ' FROM REPLACE(CONCAT(CD3.AddressLine1, ', ', CD3.AddressLine2, ', ', CD3.AddressLine3, ', ', CD3.Town, ', ', CD3_County.CountyName, ', ', CD3.PostCode, ', ', CD3.Eircode, ', ', CD3_Country.CountryName), ' ,', '')) AS CD3_DirectorAddress

FROM
	dbo.LicenceHolderMaster H

	LEFT OUTER JOIN dbo.County HC
		ON H.CountyId = HC.CountyId
	LEFT OUTER JOIN dbo.Country HCR
		ON H.CountryId = HCR.CountryId

	LEFT OUTER JOIN [cabs_production].[person].[DataSource] DS 
		ON H.LicenceHolderId = DS.SourceSystemId and DS.SourceSystemName = 'VLS'
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

WHERE
	LicenceHolderId = @LicenceHolderId

END

GO


