USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceHolderMasterAudit_SelectByLicenceHolderId]    Script Date: 4/21/2020 1:36:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Andrew Snook
-- Create date: 9/11/2010
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceHolderMasterAudit_SelectByLicenceHolderId]

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
	 , (CASE
			WHEN isnull([CompanyName], '') = '' THEN
				([FirstName] + ' ') + [LastName]
			ELSE
				[CompanyName]
		END) AS HolderName
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
	 , NULL AS DeceasedYn
	 , H.CreatedBy
	 , H.CreatedDate
	 , H.ModifiedBy
	 , H.ModifiedDate
	 , H.AuditDate
	 , H.IrishLanguageAddress
	 , H.LastDocumentationCheckDate
	 , H.Director1Name
	 , H.Director2Name
	 , H.Director3Name
	 , H.Director1Address
	 , H.Director2Address
	 , H.Director3Address
	 , HC.CountyId AS HC_CountyId
	 , HC.CountyName AS HC_CountyName
	 , HC.HasPostcode AS HC_HasPostcode
	 , HCR.CountryId AS HCR_CountryId
	 , HCR.CountryName AS HCR_CountryName
	 , HCT.HistoryChangeID AS HCT_HistoryChangeID
	 , HCT.HistoryChangeType AS HCT_HistoryChangeType

FROM
	dbo.LicenceHolderAudit H

	LEFT OUTER JOIN dbo.County HC
		ON H.CountyId = HC.CountyId
	LEFT OUTER JOIN dbo.Country HCR
		ON H.CountryId = HCR.CountryId
	LEFT OUTER JOIN dbo.HistoryChangeType HCT
		ON H.ChangeReasonId = HCT.HistoryChangeID

WHERE
	LicenceHolderId = @LicenceHolderId

END

GO


