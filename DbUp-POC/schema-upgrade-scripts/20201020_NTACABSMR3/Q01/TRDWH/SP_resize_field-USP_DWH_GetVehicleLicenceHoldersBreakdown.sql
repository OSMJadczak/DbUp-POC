USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_GetVehicleLicenceHoldersBreakdown]    Script Date: 5/14/2020 4:12:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
=============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_DWH_GetVehicleLicenceHoldersBreakdown 'ACTIVE'

=============================================
*/
ALTER PROCEDURE [dbo].[USP_DWH_GetVehicleLicenceHoldersBreakdown] 
				@Status NVarChar(20)
AS

SET NOCOUNT ON;

Begin

	Select * Into #LEA From dbo.LICENCES_EXTRACT_ARCHIVE_ALL Where impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)

	Create Table #Owners 
	(
			[Owner] NVarChar (101)
			, OwnerType NChar (7)
			, PPSN NVarChar (50)
			, Addr_1 NVarChar (100)
			, Addr_2 NVarChar (100)
			, Town NVarChar (50)
			, County NVarChar (50)
			, LicenceCount SmallInt
	)
	
	--Insert Into #Owners ([Owner], OwnerType, PPSN, Addr_1, Addr_2, Town, County, LicenceCount)
	Insert Into #Owners (OwnerType, PPSN, LicenceCount)
	Select 
		--Company As [Owner], 'Company' As OwnerType, Pps_Number, Addr_1, Addr_2, Town, County, Count(*) As LicenceCount
		'Company' As OwnerType, Pps_Number, Count(*) As LicenceCount
	From 
		dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock)
	Where 
		impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
		And Company <> '' And Status = @Status
	Group By 
		--Company, Pps_Number, Addr_1, Addr_2, Town, County
		Pps_Number

	Union All

	Select
		--First_nm + ' ' + Last_nm As [Owner], 'Private' As OwnerType, Pps_Number, Addr_1, Addr_2, Town, County, Count(*) AS LicenceCount
		'Private' As OwnerType, Pps_Number, Count(*) AS LicenceCount
	From 
		dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock)
	Where 
		impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
		And Company = '' And Status = @Status
	Group By 
		--First_nm + ' ' + Last_nm, Pps_Number, Addr_1, Addr_2, Town, County
		Pps_Number

	--Insert corresponding name + address details for each PPSN

	Update #Owners Set 
			[Owner] = (Select Top 1 LTrim(RTrim(First_nm + ' ' + Last_nm)) From #LEA Where Pps_Number = #Owners.PPSN Order By First_nm Desc)
			, Addr_1 = (Select Top 1 Addr_1 From #LEA Where Pps_Number = #Owners.PPSN Order By First_nm Desc)
			, Addr_2 = (Select Top 1 Addr_2 From #LEA Where Pps_Number = #Owners.PPSN Order By First_nm Desc)
			, Town = (Select Top 1 Town From #LEA Where Pps_Number = #Owners.PPSN Order By First_nm Desc)
			, County = (Select Top 1 County From #LEA Where Pps_Number = #Owners.PPSN Order By First_nm Desc)
	Where OwnerType = 'Private'

	Update #Owners Set 
			[Owner] = (Select Top 1 Replace(LTrim(RTrim(Company)), '¿', '') From #LEA Where Pps_Number = #Owners.PPSN Order By Company Desc)
			, Addr_1 = (Select Top 1 Addr_1 From #LEA Where Pps_Number = #Owners.PPSN Order By Company Desc)
			, Addr_2 = (Select Top 1 Addr_2 From #LEA Where Pps_Number = #Owners.PPSN Order By Company Desc)
			, Town = (Select Top 1 Town From #LEA Where Pps_Number = #Owners.PPSN Order By Company Desc)
			, County = (Select Top 1 County From #LEA Where Pps_Number = #Owners.PPSN Order By Company Desc)
	Where OwnerType = 'Company'

	Update #Owners Set 
			[Owner] = (Select Top 1 First_nm + ' ' + Last_nm From #LEA Where Pps_Number = '4601770M')
			, Addr_1 = (Select Top 1 Addr_1 From #LEA Where Pps_Number = '4601770M')
			, Addr_2 = (Select Top 1 Addr_2 From #LEA Where Pps_Number = '4601770M')
			, Town = (Select Top 1 Town From #LEA Where Pps_Number = '4601770M')
			, County = (Select Top 1 County From #LEA Where Pps_Number = '4601770M')
	Where PPSN = '4601770M'

/*
	Create Table #Owners 
	(
			Owner NVarChar (60)
			, OwnerType NChar (7)
			, Addr_1 NVarChar (50)
			, Addr_2 NVarChar (50)
			, Town NVarChar (50)
			, County NVarChar (50)
			, LicenceCount SmallInt
	)
	
	Insert Into #Owners (Owner, OwnerType, Addr_1, Addr_2, Town, County, LicenceCount)
	Select 
		--LEFT(Company, 5) + '_' + LEFT(Addr_1, 5) + '_' + LEFT(County, 5) As Owner
		Company As Owner, 'Company' As OwnerType, Addr_1, Addr_2, Town, County, Count(*) As LicenceCount
	From 
		dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock)
	Where 
		impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
		And Company <> '' And Status = @Status --And 1 = -1
	Group By 
		--LEFT(Company, 5) + '_' + LEFT(Addr_1, 5) + '_' + LEFT(County, 5), 
		Company, Addr_1, Addr_2, Town, County

	Union All

	Select
		--LEFT(First_nm, 5) + '_' + LEFT(Last_nm, 5) + '_' + LEFT(Addr_1, 5) + '_' + LEFT(County, 5) As Owner
		First_nm + ' ' + Last_nm As Owner, 'Private' As OwnerType, Addr_1, Addr_2, Town, County, Count(*) AS LicenceCount
	From 
		dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock)
	Where 
		impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
		And Company = '' And Status = @Status --And First_nm + ' ' + Last_nm = 'BRENDAN SPEARING'
	Group By 
		--LEFT(First_nm, 5) + '_' + LEFT(Last_nm, 5) + '_' + LEFT(Addr_1, 5) + '_' + LEFT(County, 5), 
		First_nm + ' ' + Last_nm, Addr_1, Addr_2, Town, County

	Order By LicenceCount Desc, Owner

--Where dbo.LICENCES_EXTRACT_ARCHIVE_ALL.impFileDate = DateAdd(dd, 0, DateDiff(dd, 0, GetDate()));
*/
Set NoCount Off;

	Select 
		LicenceCount, Count(*) As HoldersOfThisAmountOfLicences
	From 
		#Owners 
	Group By 
		LicenceCount
	Order by 
		LicenceCount

Drop Table #Owners
Drop Table #Lea

End
GO


