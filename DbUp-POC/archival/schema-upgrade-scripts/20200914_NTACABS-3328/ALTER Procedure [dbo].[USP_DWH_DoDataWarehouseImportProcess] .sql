ALTER Procedure [dbo].[USP_DWH_DoDataWarehouseImportProcess] 

As

Set NoCount On;
Set DateFormat DMY;

Begin Try
	Begin Transaction DWHUpdate

		
		--need to denormalise the data into the driver master table & photo table		
		--driver master
		Truncate Table dbo.DWH_DriverMasterHistory
		Truncate Table dbo.DWH_DriverMaster
		
		Insert Into dbo.DWH_DriverMaster ([CCSN],[licNum],[ID],[Book],[fname],[sname],[add1],[add2],[add3],[add4],[dateatadd],[padd1],[padd2],[padd3],[padd4],[dateatpadd]
           ,[dob],[oldbadge1],[oldbadge2],[issueDate],[ExpDate],[PrimLicenseArea],[SecLicenseArea],[RSINum],[photoRef],[GardaArea],[DateOfEntry],[SerialNum],[LicenseStatus]
           ,[stopUntil],[cardIssue],[A6Issue],[stopReason],[warnings],[whochangedstatus],[reasonforchange],[dateofchange],[comment1],[comment2],[IssueStatus],[fileonly]
           ,[batchName],[mobile],[phone],[year],[recordid],[repDate],[licchanged],[AnotCol],[ACol],[ASurrend],[ANotSurrend],[BCol],[BnotCol],[Surrend],[Deceased],[Revoked]
           ,[aTickBox],[bTickBox],[cardretreason],[photopresent],[driverManReceived],[manual6Digit])
		Select 
			Lhm.Ccsn, Lm.licenceNumber, Null, Null, Lhm.FirstName, Lhm.LastName, Lhm.AddressLine1, Lhm.AddressLine2, Lhm.Town, C.CountyName, Null, Null, Null, Null, Null, Null
			, Convert(nvarchar,Lhm.DateOfBirth,105), Null, Null, Convert(nvarchar,Lm.LicenceIssueDate,105), Convert(nvarchar,Lm.LicenceExpiryDate,105)
			, pa.AreaName
			, stuff((select ';' + a.AreaName from dbo.AdditionalArea aa inner join dbo.Area a on aa.AdditionalAreaId=a.AreaId where aa.LicenceMasterId=lhm.LicenceHolderId	 for xml path ('') ), 1, 1, '') 'AdditionalAreas'
			, Lhm.Ppsn, Null, Gd.GardaDivisionName, Null, Null, Case When Lm.LicenceStateMasterId = 1 Then 1 Else 0 End, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null
			, Null, Null, Null, Lhm.PhoneNo1, Lhm.PhoneNo2, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, Lhm.DeceasedYn, Null, Null, Null, Null, Null
			, Case When IsNull(_6DigitCode, '') = '' Then 'N' Else 'Y' End, _6DigitCode
		From 
			dbo.LicenceHolderMaster As Lhm With (NoLock) Inner Join dbo.LicenceMaster As Lm With (NoLock) On Lhm.LicenceHolderId = Lm.LicenceHolderId 
			Inner Join dbo.GardaDivision As Gd With (NoLock) On Lhm.GardaDivisionID = Gd.GardaDivisionID 
			left Join dbo.Person_County As C On Lhm.CountyID = C.CountyID
			left join dbo.Area pa on pa.AreaId=lhm.PrimaryAreaId			
--			
--		-- pictures
		Truncate Table dbo.photoTable
		
		Insert Into dbo.photoTable (licnum, photoData)
		Select 
			LicenceMaster.LicenceNumber, ImageContent
		From 
			dbo.LicenceHolderMaster With (NoLock) Inner Join dbo.LicenceMaster With (NoLock) 
			On dbo.LicenceHolderMaster.LicenceHolderId = dbo.LicenceMaster.LicenceHolderId 
			Inner Join dbo.DriverImages With (NoLock) On dbo.LicenceHolderMaster.Ppsn = dbo.DriverImages.PPSN 
--		
--		
--		 --fines
		DELETE dbo.DWH_FINES_BU

		INSERT dbo.DWH_FINES_BU
		SELECT * FROM dbo.FINES With (NoLock)
--
		EXEC dbo.SP_DWH_BUILD_COUNTY
		EXEC dbo.SP_DWH_BUILD_EXPIRE
		EXEC dbo.SP_DWH_BUILD_ISSUE
		EXEC dbo.SP_DWH_BUILD_FINES_MONTHLY
--		
	Commit Transaction DWHUpdate		
	
End Try		

Begin Catch
	--print 'fail'


	RollBack Transaction DWHUpdate

INSERT INTO [TRDWH].[dbo].[tempErrors]
           ([ErrorNumber]
           ,[ErrorSeverity]
           ,[ErrorState]
           ,[ErrorProcedure]
           ,[ErrorLine]
           ,[ErrorMessage])
SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage;

DECLARE @ErrorMessage NVARCHAR(4000);
 DECLARE @ErrorSeverity INT;
 DECLARE @ErrorState INT;


 SELECT
 @ErrorMessage = ERROR_MESSAGE(),
 @ErrorSeverity = ERROR_SEVERITY(),
 @ErrorState = ERROR_STATE();


 RAISERROR (@ErrorMessage, -- Message text.
 @ErrorSeverity, -- Severity.
 @ErrorState -- State.
 );

End Catch

Set NoCount Off;