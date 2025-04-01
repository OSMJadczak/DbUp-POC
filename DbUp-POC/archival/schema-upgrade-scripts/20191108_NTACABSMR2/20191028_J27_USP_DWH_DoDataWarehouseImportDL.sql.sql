USE [TRDWH]
GO
/****** Object:  StoredProcedure [dbo].[USP_DWH_DoDataWarehouseImportDL]    Script Date: 10/28/2019 11:50:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[USP_DWH_DoDataWarehouseImportDL] 
As
Set NoCount On;
Set DateFormat DMY;

Begin Try
	Begin Transaction DWHDLUpdate
		
		-- Those imports are used in the online register and other systems that are using 
		If Exists (Select * From sys.objects Where Object_Id = Object_Id(N'dbo.LAHLink') And Type In (N'U'))
			Drop Table dbo.LAHLink
		Select * Into dbo.LAHLink From [NTA-CABUT1-DB1].cabs_production.dbo.LAHLink With (NoLock)
			
		If Exists (Select * From sys.objects Where Object_Id = Object_Id(N'dbo.LicenceMaster') And Type In (N'U'))
			Drop Table dbo.LicenceMaster
		Select * Into dbo.LicenceMaster From [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.vLicenceMaster With (NoLock)
		
		If Exists (Select * From sys.objects Where Object_Id = Object_Id(N'dbo.GardaDivision') And Type In (N'U'))
			Drop Table dbo.GardaDivision
		Select * Into dbo.GardaDivision From [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.vGardaDivision With (NoLock)

		If Exists (Select * From sys.objects Where Object_Id = Object_Id(N'dbo.County') And Type In (N'U'))
			Drop Table dbo.County
		Select * Into dbo.County From [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.vCountyForOnlineRegisterCompat With (NoLock)
		
		If Exists (Select * From sys.objects Where Object_Id = Object_Id(N'dbo.DriverImages') And Type In (N'U'))
			Drop Table dbo.DriverImages
		Select * Into dbo.DriverImages From [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.vDriverImages With (NoLock)		
		
		If Exists (Select * From sys.objects Where Object_Id = Object_Id(N'dbo.DriverCounty') And Type In (N'U'))
			Drop Table dbo.DriverCounty
		Select * Into dbo.DriverCounty From [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.vDriverCounty With (NoLock)		
		


		--If Exists (Select * From sys.objects Where Object_Id = Object_Id(N'dbo.rcs') And Type In (N'U'))
		--	Drop Table dbo.rcs
		--Select * Into dbo.rcs From PMRes.dbo.rcs With (NoLock)		
	
		truncate Table dbo.LicenceHolderMaster
		insert into dbo.LicenceHolderMaster exec [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.SPLicenceHolderMaster

		-- Those imports are used in SSRS reports 
		--TRDWH_PROC_USP_DWH_MonthlyLicensesByPrimaryArea
		--TRDWH_PROC_USP_DWH_MonthlyLicensesByCountyNew
		--
		truncate table dbo.Area
		insert into dbo.Area (AreaId, AreaName)
			select AreaId, UPPER(Name) from [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.Area

		truncate table dbo.AdditionalArea
		insert into dbo.AdditionalArea (LicenceMasterId, AdditionalAreaId)
			select LicenceMasterId, AdditionalAreaId from [NTA-CABUT1-DB1].[CABS_PRODUCTION].dl.AdditionalArea

		truncate table dbo.Person_County 
		insert into dbo.Person_County (CountyId, CountryName, CountyName, CountyIrishName, HasPostCode)
			select ct.CountyId, CountryName, CountyName, CountyIrishName, HasPostCode from [NTA-CABUT1-DB1].[CABS_PRODUCTION].person.county ct with (nolock) inner join [NTA-CABUT1-DB1].[CABS_PRODUCTION].person.country cr with (nolock) on ct.CountryId=cr.CountryId


	Commit Transaction DWHDLUpdate
End Try		

Begin Catch
	--print 'fail'
	RollBack Transaction DWHDLUpdate
SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage;

End Catch

Set NoCount Off;
