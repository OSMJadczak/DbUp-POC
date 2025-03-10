USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[USP_GetVehicleDetailsByLicenceOwner_Summary]    Script Date: 5/14/2020 1:58:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*

=============================================
-- Author:		Sumayya Sayed
-- Create date: 27-Jun-2016
-- Description:	Returns the given details for given Licence Owner

Exec USP_GetVehicleDetailsByLicenceOwner_Summary 'MARY CLARKE','',''
Exec USP_GetVehicleDetailsByLicenceOwner_Summary '','8274859U',''
Exec USP_GetVehicleDetailsByLicenceOwner_Summary '','6828144S',''   -- rental



=============================================
*/
ALTER Procedure [dbo].[USP_GetVehicleDetailsByLicenceOwner_Summary] 
				@OwnerName VarChar(101),
				@PPSN  VarChar(50),
				@CCSN VarChar(50)

As

Set NoCount On;

Create Table #Vehicles 
	(
		  Date_stamp Datetime 
		, Holder_Nm NVarChar (100)
		, Holder_Addr NVarChar(2000)
		, PhoneNumber NVarChar (50)
		, MobileNumber NVarChar (50)
		, Email_Id NVarChar (50)
		, Pps_Number NVarChar (50)
		, Ccs_Number NVarChar (50)
		, NoOf_Licence Numeric
		--, Licence_Nbr NVarChar (50)
	
	)

Set @OwnerName = NULLIF(LTrim(RTrim(Upper(@OwnerName))),'')
set @PPSN=NULLIF(LTrim(RTrim(Upper(@PPSN))),'')
set @CCSN=NULLIF(LTrim(RTrim(Upper(@CCSN))),'')

Begin
	
	Insert Into #Vehicles 
	(
		Date_stamp, Holder_Nm, Holder_Addr, PhoneNumber, MobileNumber,Email_Id, Pps_Number, Ccs_Number, NoOf_Licence
	)
	
	Select 
		GETDATE(), LHM.HolderName,
		(ISNULL(LHM.AddressLine1,'') + '  ' + ISNULL(LHM.AddressLine2,'') + ' ' + ISNULL(LHM.AddressLine3,'') + ' ' + ISNULL(LHM.Town,'') + ' ' + ISNULL(C.CountyName,'')) As HolderAddress
		,ISNULL(LHM.PhoneNo1,''),ISNULL(LHM.PhoneNo2,''),ISNULL(LHM.Email,''),LHM.PPSN, LHM.Ccsn
		,Count(*) AS NoOf_Licence
	From  dbo.LicenceHolderMaster As LHM 	
	inner join LicenceMasterVL LM on LM.LicenceHolderID  = LHM.LicenceHolderID
	left join dbo.County C on C.CountyId = LHM.CountyId 
	Where 
		--LHM.HolderName like '%' +@OwnerName+ '%'  
		(Replace(LTrim(RTrim(LHM.HolderName)), '¿', '') like '%' + ISNULL(@OwnerName,Replace(LTrim(RTrim(LHM.HolderName)), '¿', ''))+ '%')
		AND LHM.PPSN = ISNULL(@PPSN,LHM.PPSN)
		AND LHM.CCSN = ISNULL(@CCSN,LHM.CCSN)

    Group by 
		 LHM.HolderName,
		 LHM.AddressLine1,
		 LHM.AddressLine2,
		 LHM.AddressLine3,
		 LHM.Town,
		 C.CountyName,
		 LHM.PhoneNo1,
		 LHM.PhoneNo2,
		 LHM.Email,
		 LHM.PPSN, 
		 LHM.Ccsn





--;WITH GroupedData AS
--(
--Select count(*) As CountLicence,LHM.PPSN from LicenceHolderMaster LHM
--inner join LicenceMasterVL LM on LM.LicenceHolderID  = LHM.LicenceHolderID
--where LHM.PPSN = ISNULL(@PPSN,LHM.PPSN)
--Group by LHM.PPSN

--)

	
End

Set NoCount Off;

Select * From #Vehicles Order By Pps_Number

Set NoCount On;
Drop Table #Vehicles
Set NoCount Off;




GO


