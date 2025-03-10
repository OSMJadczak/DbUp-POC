USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_GetLicenceHolderInfo]    Script Date: 5/14/2020 3:59:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible USP_DWH_GetLicenceHolderInfo
-- Exec USP_DWH_GetLicenceHolderInfo '54321', '', '', ''
-- =============================================
ALTER PROCEDURE [dbo].[USP_DWH_GetLicenceHolderInfo]
				@LicenceNumber NVarChar (50)
				, @LicenceHolderName NVarChar (101)
				, @RegNumber  NVarChar (50)
				, @PPSN NVarChar (50)
As

Set NoCount On;

If IsNull(@LicenceNumber, '') = '' And IsNull(@LicenceHolderName, '') = '' And IsNull(@RegNumber, '') = '' And IsNull(@PPSN, '') = ''
	 Return
	 
If IsNull(@LicenceNumber, '') = ''
	 Set @LicenceNumber = '%'
	 
If IsNull(@LicenceHolderName, '') = ''
	 Set @LicenceHolderName = '%'
	 
If IsNull(@RegNumber, '') = ''
	 Set @RegNumber = '%'
	 
If IsNull(@PPSN, '') = ''
	 Set @PPSN = '%'

	Select 
		Left(VM.Reg_Nbr, 2) + '-' + dbo.Fn_DWH_GetAlphaNumeric(Right(Left(VM.Reg_Nbr, 4), 2)) + '-' + Right(VM.Reg_Nbr, Len(VM.Reg_Nbr) - 2 - Len(dbo.Fn_DWH_GetAlphaNumeric(Right(Left(VM.Reg_Nbr, 4), 2)))) As RegistrationNumber, LM.Licence_Nbr As LicenceNumber, 
			dbo.Fn_DWH_ProperCase(Case 
				When IsNull(LHM.Company, '') = '' Then 
					Case
						When IsNull(LTrim(RTrim(LHM.Title_Cd)), '') = '' Then LTrim(RTrim(LHM.First_Nm)) + ' ' + LTrim(RTrim(LHM.Last_Nm))
						Else LTrim(RTrim(LHM.Title_Cd)) + ' ' + LTrim(RTrim(LHM.First_Nm)) + ' ' + LTrim(RTrim(LHM.Last_Nm))
					End
				Else LHM.Company
			  End) As HolderName, dbo.Fn_DWH_ProperCase(LHM.Addr_1) As Address1, dbo.Fn_DWH_ProperCase(LHM.Addr_2) As Address2, dbo.Fn_DWH_ProperCase(LHM.Town) As Town, dbo.Fn_DWH_ProperCase(LHM.County) As County, 
			LM.LicenceState As LicenceStatus, LM.ExpiryDate, LM.Plate_Nbr As PlateNumber, LTrim(RTrim(LHM.MobileNumber)) As MobileNumber, 
			LHM.PhoneNumber, dbo.Fn_DWH_ProperCase(VM.Make) As Make, dbo.Fn_DWH_ProperCase(VM.Model) As Model, dbo.Fn_DWH_ProperCase(VM.Colour) As Colour, VM.NbrPassengers As NbrSeats 
	From 
		dbo.DWH_VehicleMaster As VM With (NoLock) Left Outer Join dbo.DWH_LicenceMaster As LM With (NoLock) On VM.Reg_Nbr = LM.Reg_Nbr 
		Left Outer Join dbo.DWH_LicenceHolderMaster As LHM With (NoLock) On LM.CCSN = LHM.CCSN
	Where 
		LM.Reg_Nbr Like @RegNumber And 
		LM.Plate_Nbr Like @LicenceNumber And 
		LHM.First_Nm + ' ' + LHM.Last_Nm Like '%' + @LicenceHolderName + '%' And 
		LHM.PPS_Number Like @PPSN

Set NoCount Off;
GO


