USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_GetLicenceHolderVehicleDetails]    Script Date: 5/14/2020 4:01:10 PM ******/
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
				@OwnerName VarChar(101)
				, @OwnerType NChar (7)
				, @Status NVarChar (50)
As

Set NoCount On;

Declare @FirstName NVarChar (50)
		, @SurName NVarChar(50)

Create Table #Vehicles 
	(
		Reg_Nbr NVarChar (50)
		, Plate_Nbr NVarChar (50)
		, Licence_Nbr NVarChar (50)
		, Old_Plate_Nbr NVarChar (50)
		, First_Nm NVarChar (50)
		, Last_Nm NVarChar (50)
		, Title_Cd NVarChar (50)
		, Addr_1 NVarChar (100)
		, Addr_2 NVarChar (100)
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
		Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd
		, Addr_1, Addr_2, Town, Company, Status, Authority, County, ExpiryDate
		, Make, Model, Colour, PhoneNumber, MobileNumber, Pps_Number, Company_Number
		, Refused_Mobile_No, VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers 
		, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate
		, InsuranceCertNumber, InsuranceCertExpiryDate, VehicleAge
	)
	
	Select 
		VM.Reg_Nbr, LM.Plate_Nbr, LM.Licence_Nbr, '' As Old_Plate_Nbr, LHM.First_Nm, LHM.Last_Nm, LHM.Title_Cd, LHM.Addr_1, LHM.Addr_2
		, LHM.Town, LHM.Company, LM.LicenceState, '' As Authority, LHM.County, LM.ExpiryDate, VM.Make, VM.Model, VM.Colour, LHM.PhoneNumber
		, LHM.MobileNumber, LHM.Pps_Number, LHM.Company_Number, '' As Refused_Mobile_No, VM.VIN, VM.DateFirstReg, VM.EngineCC
		, LM.SPSVCategoryId As LicenceLetter, VM.NbrPassengers, LM.IssueDate, '' As TestCentre, LHM.TaxClearanceNumber
		, LHM.TaxClearanceExpiryDate, '' As InsuranceCertNumber, '' As InsuranceCertExpiryDate
		, Case IsNumeric(Left(VM.Reg_Nbr, 2))
			When 1 Then 
				Case 
					When IsNumeric(Left(VM.Reg_Nbr, 3)) = 1 Then 30
					When Cast(Left(VM.Reg_Nbr, 2) As SmallInt) > 49 Then Year(GetDate()) - (1900 + Cast(Left(VM.Reg_Nbr, 2) As SmallInt))
					Else (Right(Year(GetDate()), 2) - Cast(Left(VM.Reg_Nbr, 2) As SmallInt))
				End
			Else 30
		  End
	From 
		dbo.DWH_LicenceHolderMaster As LHM With (NoLock) Inner Join dbo.DWH_LicenceMaster As LM With (NoLock) On LHM.CCSN = LM.CCSN Inner Join dbo.DWH_VehicleMaster As VM With (NoLock) On LM.Reg_Nbr = VM.Reg_Nbr Left Outer Join dbo.DWH_SPSVCategory With (NoLock) 
		On LM.SPSVCategoryId = dbo.DWH_SPSVCategory.CategoryId
	Where 
		LicenceState = @Status And Replace(LTrim(RTrim(LHM.Company)), '¿', '') = @OwnerName
		
	/*
	Select 
		Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd, Addr_1, Addr_2
		, Town, Company, Status, Authority, County, ExpiryDate, Make, Model, Colour, PhoneNumber
		, MobileNumber, Pps_Number, Company_Number, Refused_Mobile_No, VIN, DateFirstReg, EngineCC
		, LicenceLetter, NbrPassengers, IssueDate, TestCentre, TaxClearanceNumber
		, TaxClearanceExpiryDate, InsuranceCertNumber, InsuranceCertExpiryDate
		, Case IsNumeric(Left(Reg_Nbr, 2))
			When 1 Then 
				Case 
					When IsNumeric(Left(Reg_Nbr, 3)) = 1 Then 30
					When Cast(Left(Reg_Nbr, 2) As SmallInt) > 49 Then Year(GetDate()) - (1900 + Cast(Left(Reg_Nbr, 2) As SmallInt))
					Else (Right(Year(GetDate()), 2) - Cast(Left(Reg_Nbr, 2) As SmallInt))
				End
			Else 30
		  End
	From 
		dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock)
	Where 
		impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
		And Status = @Status And Replace(LTrim(RTrim(Company)), '¿', '') = @OwnerName
	*/
End
Else
Begin
	Set @FirstName = LTrim(RTrim(SubString(@OwnerName, 1, CharIndex(' ', @OwnerName))))
	Set @SurName = LTrim(RTrim(SubString(@OwnerName, CharIndex(' ', @OwnerName), (Len(@OwnerName) - CharIndex(' ', @OwnerName) + 1))))

	Insert Into #Vehicles 
	(
		Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd
		, Addr_1, Addr_2, Town, Company, Status, Authority, County, ExpiryDate
		, Make, Model, Colour, PhoneNumber, MobileNumber, Pps_Number, Company_Number
		, Refused_Mobile_No, VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers 
		, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate
		, InsuranceCertNumber, InsuranceCertExpiryDate, VehicleAge
	)
	
	Select 
		VM.Reg_Nbr, LM.Plate_Nbr, LM.Licence_Nbr, '' As Old_Plate_Nbr, LHM.First_Nm, LHM.Last_Nm, LHM.Title_Cd, LHM.Addr_1, LHM.Addr_2
		, LHM.Town, LHM.Company, LM.LicenceState, '' As Authority, LHM.County, LM.ExpiryDate, VM.Make, VM.Model, VM.Colour, LHM.PhoneNumber
		, LHM.MobileNumber, LHM.Pps_Number, LHM.Company_Number, '' As Refused_Mobile_No, VM.VIN, VM.DateFirstReg, VM.EngineCC
		, LM.SPSVCategoryId As LicenceLetter, VM.NbrPassengers, LM.IssueDate, '' As TestCentre, LHM.TaxClearanceNumber
		, LHM.TaxClearanceExpiryDate, '' As InsuranceCertNumber, '' As InsuranceCertExpiryDate
		, Case IsNumeric(Left(VM.Reg_Nbr, 2))
			When 1 Then 
				Case 
					When IsNumeric(Left(VM.Reg_Nbr, 3)) = 1 Then 30
					When Cast(Left(VM.Reg_Nbr, 2) As SmallInt) > 49 Then Year(GetDate()) - (1900 + Cast(Left(VM.Reg_Nbr, 2) As SmallInt))
					Else (Right(Year(GetDate()), 2) - Cast(Left(VM.Reg_Nbr, 2) As SmallInt))
				End
			Else 30
		  End
	From 
		dbo.DWH_LicenceHolderMaster As LHM With (NoLock) Inner Join dbo.DWH_LicenceMaster As LM With (NoLock) On LHM.CCSN = LM.CCSN Inner Join dbo.DWH_VehicleMaster As VM With (NoLock) On LM.Reg_Nbr = VM.Reg_Nbr Left Outer Join dbo.DWH_SPSVCategory With (NoLock) 
		On LM.SPSVCategoryId = dbo.DWH_SPSVCategory.CategoryId
	Where 
		LicenceState = @Status And First_Nm = @FirstName And Last_Nm = @SurName
	/*
	Select
		Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd, Addr_1, Addr_2
		, Town, Company, Status, Authority, County, ExpiryDate, Make, Model, Colour, PhoneNumber
		, MobileNumber, Pps_Number, Company_Number, Refused_Mobile_No, VIN, DateFirstReg, EngineCC
		, LicenceLetter, NbrPassengers, IssueDate, TestCentre, TaxClearanceNumber
		, TaxClearanceExpiryDate, InsuranceCertNumber, InsuranceCertExpiryDate
		, Case IsNumeric(Left(Reg_Nbr, 2))
			When 1 Then 
				Case 
					When IsNumeric(Left(Reg_Nbr, 3)) = 1 Then 30
					When Cast(Left(Reg_Nbr, 2) As TinyInt) > 49 Then Year(GetDate()) - (1900 + Cast(Left(Reg_Nbr, 2) As TinyInt))
					Else (Right(Year(GetDate()), 2) - Cast(Left(Reg_Nbr, 2) As TinyInt))
				End
			Else 30
		  End
	From 
		dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock)
	Where 
		impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
		And Status = @Status And First_Nm = @FirstName And Last_Nm = @SurName
		*/
End

Set NoCount Off;

Select * From #Vehicles Order By Licence_Nbr

Set NoCount On;
Drop Table #Vehicles
Set NoCount Off;
GO


