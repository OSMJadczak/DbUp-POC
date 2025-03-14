USE [TRDWH]
GO
/****** Object:  StoredProcedure [dbo].[USP_DWH_GetVehicleAgeBreakdownBiYearlyNEW]    Script Date: 03/03/2021 09:25:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
=============================================
-- Author:		Adam Nosal
-- Create date: 28-Feb-2021
-- Description:	

Exec USP_DWH_GetVehicleAgeBreakdownBiYearly  '31/Dec/2008'

=============================================
*/
create or ALTER PROCEDURE [dbo].[USP_DWH_GetLicenceStatusBreakdown]
				--@Status NVarChar(20), 
				@ExtractDate DateTime
As

BEGIN 

Set NoCount On;

Create Table #Licences 
	(
		 Licence_Nbr NVarChar (50)
		, FullStatus NVarChar (50)
		, LicenceLetter NVarChar (50)
		, SPSVCategory NVarChar (50)
	)


Insert Into #Licences 
(
	 Licence_Nbr, FullStatus, LicenceLetter, SPSVCategory
)

Select 
	E.Reg_Nbr, FullStatus,  LicenceLetter
	, IsNull(dbo.DWH_SPSVCategory.CategoryDescription, 'Not Categorised')
From 
	dbo.LICENCES_EXTRACT_ARCHIVE_ALL E With (NoLock) Left Outer Join dbo.DWH_SPSVCategory With (NoLock) 
			On Left(E.Licence_Nbr, 1) = dbo.DWH_SPSVCategory.CategoryId
	left outer join dbo.DWH_VehicleMaster With (NoLock) 
			On E.Reg_Nbr = dbo.DWH_VehicleMaster.Reg_Nbr
Where 
	impFileDate = @ExtractDate--(Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
	--And Status = @Status

Set NoCount Off;

Select 0 As RankOrder, 'Active' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Active' Group By SPSVCategory
Union All
Select 1 As RankOrder, 'Inactive Expired' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Inactive Expired'  Group By SPSVCategory
Union All
Select 2 As RankOrder, 'Inactive Deferred' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Inactive Deferred'  Group By SPSVCategory
Union All
Select 3 As RankOrder, 'Inactive Conditional Offer' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus ='Inactive Conditional Offer'  Group By SPSVCategory
Union All
Select 4 As RankOrder, 'Inactive Suspended' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Inactive Suspended' Group By SPSVCategory
Union All
Select 5 As RankOrder, 'Dead Revoked' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus =  'Dead Revoked'  Group By SPSVCategory
Union All
Select 6 As RankOrder, 'Dead Timed Out' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Dead Timed Out' Group By SPSVCategory
Union All
Select 7 As RankOrder, 'Dead Surrendered' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus =  'Dead Surrendered' Group By SPSVCategory
Union All
Select 8 As RankOrder, 'Dead Conditional Offer ' As Status, SPSVCategory, Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Dead Conditional Offer' Group By SPSVCategory

--change this to Status table import 

Set NoCount On;
Drop Table #Licences
Set NoCount Off;

END 