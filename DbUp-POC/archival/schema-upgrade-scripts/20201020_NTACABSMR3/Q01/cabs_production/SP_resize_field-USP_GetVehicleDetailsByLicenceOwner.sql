USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[USP_GetVehicleDetailsByLicenceOwner]    Script Date: 5/14/2020 1:58:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*

=============================================
-- Author:		Sumayya Sayed
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_GetVehicleDetailsByLicenceOwner_Summary 'Mary clarke',NULL,NULL  
--PPSN for Rental exple 5397221E
Exec USP_GetVehicleDetailsByLicenceOwner 'Mary clarke',NULL,NULL
Exec USP_GetVehicleDetailsByLicenceOwner '','6828144S',''   -- rental

=============================================
*/
ALTER Procedure [dbo].[USP_GetVehicleDetailsByLicenceOwner] 
				@OwnerName VarChar(101),
				@PPSN  VarChar(50),
				@CCSN VarChar(50)

As

Set NoCount On;

Create Table #Vehicles 
	(
		Licence_Nbr NVarChar (50)		
		,Reg_Nbr NVarChar (50)
		,Licence_Status NVarChar (50)
		, ExpiryDate NVarChar (50)
		, IssueDate NVarChar (50)
		, Make NVarChar (50)
		, Model NVarChar (50)
		, Colour NVarChar (50)
		, Vehicle_Rental NVarChar (50)
		, Rental_Status NVarChar (50)
		, Rental_StartDate NVarChar (50)
		, Rental_EndDate NVarChar (50)
		, DriverLicence_Nbr NVarChar (50)
		, Driver_Nm NVarChar (100)
		, Pps_Number NVarChar (50)
		, Ccs_Number NVarChar (50)


	)

Set @OwnerName = NULLIF(LTrim(RTrim(Upper(@OwnerName))),'')
set @PPSN=NULLIF(LTrim(RTrim(Upper(@PPSN))),'')
set @CCSN=NULLIF(LTrim(RTrim(Upper(@CCSN))),'')


Begin
	
	Insert Into #Vehicles 
	(
		  Licence_Nbr, Reg_Nbr, Licence_Status, ExpiryDate, IssueDate ,Make, Model, Colour
		  , Vehicle_Rental, Rental_Status ,Rental_StartDate, Rental_EndDate
		  ,DriverLicence_Nbr, Driver_Nm, Pps_Number, Ccs_Number

   )
	
	Select 
		LM.LicenceNUmber, VM.RegistrationNumber,LSM.LicenceStateMaster,
		ISNULL(CONVERT(VARCHAR(10), LM.LicenceExpiryDate, 103),'') AS LicenceExpiryDate,
		ISNULL(CONVERT(VARCHAR(10), LM.LicenceIssueDate, 103),'') AS LicenceIssueDate,
		 vma.Make, vmo.Model, vc.Colour,
		CASE WHEN ra.DriverLicenceNo is null THEN 'NO' ELSE 'YES' END AS IsVehicleRental
		
		,CASE  WHEN ra.EndDate > GETDATE() OR ra.EndDate = GETDATE()  THEN 'Active' 
		 WHEN ra.EndDate < GETDATE()  THEN 'Historical'
		 ELSE ' ' END as RentalStatus

		,ISNULL(CONVERT(VARCHAR(10), ra.StartDate, 103),'') AS RentalStartDate
		,ISNULL(CONVERT(VARCHAR(10), ra.EndDate, 103),'') AS RentalEndDate
		,ISNULL(ra.DriverLicenceNo,''),ISNULL(ra.Name,''), LHM.PPSN, LHM.Ccsn

	From 
		dbo.LicenceMasterVL As LM 
		Join dbo.VehicleMaster As VM On LM.RegistrationNumber = VM.RegistrationNumber
		inner Join dbo.LicenceHolderMaster As LHM  On LM.LicenceHolderId = LHM.LicenceHolderId 
		join County c On LHM.CountyId=c.CountyId		
		Join dbo.LicenceType LT On LM.LicenceTypeId = LT.LicenceTypeId
		inner join LicenceStateMaster LSM ON LM.LicenceStateMasterId=LSM.LicenceStateMasterId
		join VehicleMake vma On VM.MakeId=vma.MakeId
		join VehicleModel vmo On VM.ModelId=vmo.ModelId
		join VehicleColour vc On VM.ColourId=vc.ColourId		
		left outer join [cabs_production].[cabs_rta].[RentalAgreement] ra on ra.VehicleLicenceNo = LM.LicenceNumber --AND ra.IsActive = 1
	Where 
		--(Replace(LTrim(RTrim(LHM.HolderName)), '¿', '') like '%' +@OwnerName+'%')
		(Replace(LTrim(RTrim(LHM.HolderName)), '¿', '') like '%' + ISNULL(@OwnerName,Replace(LTrim(RTrim(LHM.HolderName)), '¿', ''))+ '%')
		AND LHM.PPSN = ISNULL(@PPSN,LHM.PPSN)
		AND LHM.CCSN = ISNULL(@CCSN,LHM.CCSN)
	
	
End

Set NoCount Off;

Select * From #Vehicles Order By Licence_Nbr,ExpiryDate DESC

Set NoCount On;
Drop Table #Vehicles
Set NoCount Off;



GO


