USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[iCabs_GetVehicleEnforcementInfoInterim]    Script Date: 4/24/2020 2:10:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
=============================================
-- Author:		Dan Rusu
-- Create date: 25-Nov-2011
-- Description:	Returns all possible Status codes present in status table



=============================================
*/
ALTER PROCEDURE [dbo].[iCabs_GetVehicleEnforcementInfoInterim] 
				@LicenceNumber NVarChar (50) = ''
				, @RegistrationNumber NVarChar (50) = ''
As



If IsNull(@LicenceNumber, '') <> ''
	set @LicenceNumber = replace(replace(replace(replace(@LicenceNumber,'T',''),'H',''),'W',''),'L','')
		
Set NoCount On;

If IsNull(@LicenceNumber, '') = ''
Select  top(50)
	VM.RegistrationNumber As RegistrationNumber, LM.LicenceNumber As LicenceNumber, 
		HolderName As HolderName, LHM.AddressLine1 As Address1, LHM.AddressLine2 As Address2, 
		LHM.Town, c.CountyName as County, 
		lsm.LicenceStateMaster + ' ' + ls.LicenceState As LicenceStatus, 
		convert(nvarchar,LM.LicenceExpiryDate,105) as ExpiryDate, 
		LM.LicenceNumber As PlateNumber, LTrim(RTrim(LHM.PhoneNo2)) as MobileNumber, 
		LHM.PhoneNo1 as PhoneNumber, vma.Make, vmo.Model, vc.Colour, VM.NumberPassengers As NbrSeats , 
dli.LicenceNumber as [DriverLicence], 
isnull(LHM.AddressLine1,'') + isnull(' ' + LHM.AddressLine2,'') + isnull(' ' + LHM.Town,'') + isnull(' ' + c.CountyName,'')  as [Address]
From 
	dbo.VehicleMaster As VM With (NoLock) Left Outer Join dbo.LicenceMasterVL As LM With (NoLock) On VM.RegistrationNumber = LM.RegistrationNumber 	
	Left Outer Join dbo.LicenceHolderMaster As LHM With (NoLock) On LM.LicenceHolderId = LHM.LicenceHolderId
	left outer join dbo.County c on c.CountyId = LHM.CountyId
	left join dbo.LicenceStateMaster lsm on lsm.LicenceStateMasterId = LM.LicenceStateMasterId
	left join dbo.LicenceState ls on ls.LicenceStateId = LM.LicenceStateId
	left outer join dbo.VehicleMake vma on vma.MakeId = vm.MakeId
	left outer join dbo.VehicleModel vmo on vmo.ModelId = vm.ModelId
	left outer join dbo.VehicleColour vc on vc.ColourId = vm.ColourId
	left outer join dbo.DriverLicensesInterim as dli With (NoLock) On dli.Ppsn = lhm.Ppsn
Where 
	IsNull(VM.RegistrationNumber, '') Like '%' + @RegistrationNumber + '%'
Order By 
	LicenceState Desc
	
	
If IsNull(@RegistrationNumber, '') = ''	
Set NoCount On;

If IsNull(@LicenceNumber, '') = ''
Select  top(50)
	VM.RegistrationNumber As RegistrationNumber, LM.LicenceNumber As LicenceNumber, 
		HolderName As HolderName, LHM.AddressLine1 As Address1, LHM.AddressLine2 As Address2, 
		LHM.Town, c.CountyName as County, 
		lsm.LicenceStateMaster + ' ' + ls.LicenceState As LicenceStatus, 
		convert(nvarchar,LM.LicenceExpiryDate,105) as ExpiryDate, 
		LM.LicenceNumber As PlateNumber, LTrim(RTrim(LHM.PhoneNo2)) as MobileNumber, 
		LHM.PhoneNo1 as PhoneNumber, vma.Make, vmo.Model, vc.Colour, VM.NumberPassengers As NbrSeats , 
dli.LicenceNumber as [DriverLicence], 
isnull(LHM.AddressLine1,'') + isnull(' ' + LHM.AddressLine2,'') + isnull(' ' + LHM.Town,'') + isnull(' ' + c.CountyName,'')  as [Address]
From 
	dbo.VehicleMaster As VM With (NoLock) Left Outer Join dbo.LicenceMasterVL As LM With (NoLock) On VM.RegistrationNumber = LM.RegistrationNumber 	
	Left Outer Join dbo.LicenceHolderMaster As LHM With (NoLock) On LM.LicenceHolderId = LHM.LicenceHolderId
	left outer join dbo.County c on c.CountyId = LHM.CountyId
	left join dbo.LicenceStateMaster lsm on lsm.LicenceStateMasterId = LM.LicenceStateMasterId
	left join dbo.LicenceState ls on ls.LicenceStateId = LM.LicenceStateId
	left outer join dbo.VehicleMake vma on vma.MakeId = vm.MakeId
	left outer join dbo.VehicleModel vmo on vmo.ModelId = vm.ModelId
	left outer join dbo.VehicleColour vc on vc.ColourId = vm.ColourId
	left outer join dbo.DriverLicensesInterim as dli With (NoLock) On dli.Ppsn = lhm.Ppsn
Where 
	IsNull(LM.LicenceNumber, '') Like '%' + @LicenceNumber + '%'
Order By 
	LicenceState Desc

Option (MaxDop 1)
GO


