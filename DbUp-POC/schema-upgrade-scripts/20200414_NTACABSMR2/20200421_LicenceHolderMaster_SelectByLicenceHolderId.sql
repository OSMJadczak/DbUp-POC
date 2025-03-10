USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceHolderMaster_SelectByLicenceHolderId]    Script Date: 4/21/2020 12:53:20 PM ******/
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
	 , H.Director1Name
	 , H.Director2Name
	 , H.Director3Name
	 , H.Director1Address
	 , H.Director2Address
	 , H.Director3Address
	 , H.LastDocumentationCheckDate
	 , HC.CountyId AS HC_CountyId
	 , HC.CountyName AS HC_CountyName
	 , HC.HasPostcode AS HC_HasPostcode
	 , HCR.CountryId AS HCR_CountryId
	 , HCR.CountryName AS HCR_CountryName

FROM
	dbo.LicenceHolderMaster H

	LEFT OUTER JOIN dbo.County HC
		ON H.CountyId = HC.CountyId
	LEFT OUTER JOIN dbo.Country HCR
		ON H.CountryId = HCR.CountryId

WHERE
	LicenceHolderId = @LicenceHolderId

END

GO


