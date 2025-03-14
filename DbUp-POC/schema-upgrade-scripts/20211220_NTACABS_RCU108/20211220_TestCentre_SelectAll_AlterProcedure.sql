USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[TestCentre_SelectAll]    Script Date: 2021-12-20 13:59:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[TestCentre_SelectAll]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	SELECT	
		T.TestCentreId, T.TestCentreName, T.RegionId, T.AddressLine1, T.AddressLine2,
		T.AddressLine3,	T.Town, T.PostCode, T.CountryId, T.ContactName,
		T.ContactNumberPrimary, T.ContactNumberSecondary, T.Email,
		T.Active, T.CICapability,
		T.Eircode,
		T.CreatedBy, T.CreatedDate, T.ModifiedBy, T.ModifiedDate,
		
		C.CountyId as C_CountyId, C.CountyName as C_CountyName,				
		CR.CountryId as CR_CountryId, CR.CountryName as CR_CountryName,	
		R.RegionId as R_RegionId, R.RegionName as R_RegionName,
		
		CO.CompanyId as CO_CompanyId, CO.CompanyName as CO_CompanyName, CO.CompanyNumber as CO_CompanyNumber, CO.VatNumber as CO_VatNumber, 
		CO.AddressLine1 as CO_AddressLine1, CO.AddressLine2 as CO_AddressLine2, CO.AddressLine3 as CO_AddressLine3, CO.Town as CO_Town,  
		CO.PostCode as CO_PostCode,CO.ContactName as CO_ContactName,
		CO.ContactNumberPrimary as CO_ContactNumberPrimary, CO.ContactNumberSecondary as CO_ContactNumberSecondary, 
		CO.ContactNumberFax as CO_ContactNumberFax, CO.Email as CO_Email,
		CO.CreatedBy as CO_CreatedBy, CO.CreatedDate as CO_CreatedDate, 
		CO.ModifiedBy as CO_ModifiedBy, CO.ModifiedDate as CO_ModifiedDate,
		
		COC.CountyId as COC_CountyId, COC.CountyName as COC_CountyName,				
		COCR.CountryId as COCR_CountryId, COCR.CountryName as COCR_CountryName
		
	FROM TestCentre T

	LEFT OUTER JOIN dbo.County C on T.CountyId = C.CountyId	
	LEFT OUTER JOIN dbo.Country CR on T.CountryId = CR.CountryId	
	LEFT OUTER JOIN dbo.Region R on T.RegionId = R.RegionId	
	LEFT OUTER JOIN dbo.Company CO on CO.CompanyId = T.CompanyId
	LEFT OUTER JOIN dbo.County COC on CO.CountyId = COC.CountyId	
	LEFT OUTER JOIN dbo.Country COCR on CO.CountryId = COCR.CountryId	
	
END

GO


