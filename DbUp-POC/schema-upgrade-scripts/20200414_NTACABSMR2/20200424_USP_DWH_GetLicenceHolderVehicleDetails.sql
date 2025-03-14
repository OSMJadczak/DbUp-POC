USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_GetLicenceHolderVehicleDetails]    Script Date: 4/24/2020 2:51:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*

=============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_DWH_GetLicenceHolderVehicleDetails 'BRENDAN SPEARING', 'PRIVATE', 'ACTIVE'

=============================================
*/
ALTER Procedure [dbo].[USP_DWH_GetLicenceHolderVehicleDetails] 
				@OwnerName VarChar(60)
				, @OwnerType NChar (7)
				, @Status NVarChar (50)
As

Set NoCount On;

Declare @FirstName NVarChar (30)
		, @SurName NVarChar(30)

Create Table #Vehicles 
	(
		Reg_Nbr NVarChar (50)
		, Plate_Nbr NVarChar (50)
		, Licence_Nbr NVarChar (50)
		, Old_Plate_Nbr NVarChar (50)
		, First_Nm NVarChar (50)
		, Last_Nm NVarChar (50)
		, Addr_1 NVarChar (50)
		, Addr_2 NVarChar (50)
		, Town NVarChar (50)
		, Company NVarChar (250)
		, Status NVarChar (50)
		, Authority NVarChar (50)
		, County NVarChar (50)
		, ExpiryDate NVarChar (50)
		, Make NVarChar (50)
		, Model NVarChar (50)
		, Colour NVarChar (50)
		, PhoneNumber NVarChar (50)
		, MobileNumber NVarChar (50)
		, Pps_Number NVarChar (50)
		, Company_Number NVarChar (50)
		, Refused_Mobile_No NVarChar (50)
		, VIN NVarChar (50)
		, DateFirstReg NVarChar (50)
		, EngineCC NVarChar (50)
		, LicenceLetter NVarChar (50)
		, NbrPassengers NVarChar (50)
		, IssueDate NVarChar (50)
		, TestCentre NVarChar (50)
		, TaxClearanceNumber NVarChar (50)
		, TaxClearanceExpiryDate NVarChar (50)
		, InsuranceCertNumber NVarChar (50)
		, InsuranceCertExpiryDate NVarChar (50)
		, VehicleAge SmallInt
	)

Set @OwnerName = LTrim(RTrim(Upper(@OwnerName)))

If Upper(@OwnerType) = 'COMPANY'
Begin
	Insert Into #Vehicles 
	(
		Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm
		, Addr_1, Addr_2, Town, Company, Status, Authority, County, ExpiryDate
		, Make, Model, Colour, PhoneNumber, MobileNumber, Pps_Number, Company_Number
		, Refused_Mobile_No, VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers 
		, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate
		, InsuranceCertNumber, InsuranceCertExpiryDate, VehicleAge
	)
	
	Select 
		VM.RegistrationNumber, LM.PlateNumber, LM.LicenceNUmber, '' As OldPlateNumber, LHM.FirstName, LHM.LastName, LHM.AddressLine1, LHM.AddressLine2
		, LHM.Town, LHM.CompanyName, LSM.LicenceStateMaster, '' As Authority, c.CountyName, LM.LicenceExpiryDate, vma.Make, vmo.Model, vc.Colour, LHM.PhoneNo1
		, LHM.PhoneNo2, LHM.PPSN, LHM.CompanyNumber, '' As Refused_Mobile_No, VM.VIN, VM.RegistrationDate, VM.EngineCapacity
		, LT.LicenceTypeShortCode As LicenceLetter, VM.NumberPassengers, LM.LicenceIssueDate, '' As TestCentre, LHM.TaxClearanceNumber
		, LHM.TaxClearanceExpiryDate, '' As InsuranceCertNumber, '' As InsuranceCertExpiryDate
		, Case IsNumeric(Left(VM.RegistrationNumber, 2))
			When 1 Then 
				Case 
					When IsNumeric(Left(VM.RegistrationNumber, 3)) = 1 Then 30
					When Cast(Left(VM.RegistrationNumber, 2) As SmallInt) > 49 Then Year(GetDate()) - (1900 + Cast(Left(VM.RegistrationNumber, 2) As SmallInt))
					Else (Right(Year(GetDate()), 2) - Cast(Left(VM.RegistrationNumber, 2) As SmallInt))
				End
			Else 30
		  End
	From 
		dbo.LicenceMasterVL As LM 
		Inner Join dbo.LicenceHolderMaster As LHM  On LM.LicenceHolderId = LHM.LicenceHolderId 
		Inner Join dbo.VehicleMaster As VM On LM.RegistrationNumber = VM.RegistrationNumber
		join VehicleMake vma On VM.MakeId=vma.MakeId
		join VehicleModel vmo On VM.ModelId=vmo.ModelId
		join VehicleColour vc On VM.ColourId=vc.ColourId
		Left Outer Join dbo.LicenceType	LT On LM.LicenceTypeId = LT.LicenceTypeId
		left outer join LicenceStateMaster LSM ON LM.LicenceStateMasterId=LSM.LicenceStateMasterId
		left outer join County c On LHM.CountyId=c.CountyId

	Where 
		LSM.LicenceStateMaster = @Status And Replace(LTrim(RTrim(LHM.CompanyName)), '¿', '') like '%' +@OwnerName+'%'		
	
End
Else
Begin
	Set @FirstName = LTrim(RTrim(SubString(@OwnerName, 1, CharIndex(' ', @OwnerName))))
	Set @SurName = LTrim(RTrim(SubString(@OwnerName, CharIndex(' ', @OwnerName), (Len(@OwnerName) - CharIndex(' ', @OwnerName) + 1))))
	
	Insert Into #Vehicles 
	(
		Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm
		, Addr_1, Addr_2, Town, Company, Status, Authority, County, ExpiryDate
		, Make, Model, Colour, PhoneNumber, MobileNumber, Pps_Number, Company_Number
		, Refused_Mobile_No, VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers 
		, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate
		, InsuranceCertNumber, InsuranceCertExpiryDate, VehicleAge
	)
	
	Select 
		VM.RegistrationNumber, LM.PlateNumber, LM.LicenceNUmber, '' As OldPlateNumber, LHM.FirstName, LHM.LastName, LHM.AddressLine1, LHM.AddressLine2
		, LHM.Town, LHM.CompanyName, LSM.LicenceStateMaster, '' As Authority, c.CountyName, LM.LicenceExpiryDate, vma.Make, vmo.Model, vc.Colour, LHM.PhoneNo1
		, LHM.PhoneNo2, LHM.PPSN, LHM.CompanyNumber, '' As Refused_Mobile_No, VM.VIN, VM.RegistrationDate, VM.EngineCapacity
		, LT.LicenceTypeShortCode As LicenceLetter, VM.NumberPassengers, LM.LicenceIssueDate, '' As TestCentre, LHM.TaxClearanceNumber
		, LHM.TaxClearanceExpiryDate, '' As InsuranceCertNumber, '' As InsuranceCertExpiryDate
		, Case IsNumeric(Left(VM.RegistrationNumber, 2))
			When 1 Then 
				Case 
					When IsNumeric(Left(VM.RegistrationNumber, 3)) = 1 Then 30
					When Cast(Left(VM.RegistrationNumber, 2) As SmallInt) > 49 Then Year(GetDate()) - (1900 + Cast(Left(VM.RegistrationNumber, 2) As SmallInt))
					Else (Right(Year(GetDate()), 2) - Cast(Left(VM.RegistrationNumber, 2) As SmallInt))
				End
			Else 30
		  End
	From 
		dbo.LicenceMasterVL As LM 
		Join dbo.VehicleMaster As VM On LM.RegistrationNumber = VM.RegistrationNumber
		Join dbo.LicenceHolderMaster As LHM  On LM.LicenceHolderId = LHM.LicenceHolderId 
		join County c On LHM.CountyId=c.CountyId		
		Join dbo.LicenceType LT On LM.LicenceTypeId = LT.LicenceTypeId
		join LicenceStateMaster LSM ON LM.LicenceStateMasterId=LSM.LicenceStateMasterId
		join VehicleMake vma On VM.MakeId=vma.MakeId
		join VehicleModel vmo On VM.ModelId=vmo.ModelId
		join VehicleColour vc On VM.ColourId=vc.ColourId		
	Where 
		LSM.LicenceStateMaster = @Status And LHM.HolderName like '%' +@OwnerName+ '%'
	
End

Set NoCount Off;

Select * From #Vehicles Order By Licence_Nbr

Set NoCount On;
Drop Table #Vehicles
Set NoCount Off;



GO


