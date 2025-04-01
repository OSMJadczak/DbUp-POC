USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceMasterVL_ExchangeLicence]    Script Date: 05.02.2020 15:37:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[LicenceMasterVL_ExchangeLicence]
    @oldLN varchar(50),
	@newLN varchar(50),
	@newType int
AS
BEGIN

DECLARE @newTypeDescription nvarchar(50) = (SELECT TOP(1) LicenceType FROM cabs_production.dbo.LicenceType WHERE LicenceTypeId = @newType)

BEGIN TRY
    BEGIN TRANSACTION 
ALTER TABLE cabs_production.dbo.LicenceMasterVL NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.cabs_dvl.VehicleDriver NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.cabs_tds.SignageInstallation NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.Booking NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.BookingAudit NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.VehicleInspections NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.cabs_insp.VehicleInspectionsDraft NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.LicenceNominee NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.LicenceRepresentative NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.PaymentRefundVL NOCHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.PaymentVL NOCHECK CONSTRAINT ALL

UPDATE	cabs_production.cabs_dvl.VehicleDriver
SET		VehicleLicenseNumber = @newLN
WHERE	VehicleLicenseNumber = @oldLN

UPDATE	cabs_production.cabs_tds.SignageInstallation
SET		VehicleLicenceNumber = @newLN
WHERE	VehicleLicenceNumber = @oldLN

UPDATE	cabs_production.dbo.Booking
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.BookingAudit
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.VehicleInspections
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.cabs_insp.VehicleInspectionsDraft
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.LicenceNominee
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.LicenceRepresentative
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.PaymentRefundVL
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.PaymentVL
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

-- MAIN TABLE
	
UPDATE	cabs_production.dbo.LicenceMasterVL
SET		LicenceNumber = @newLN,
		LicenceTypeId = @newType,
		Exchanged = 1
WHERE	LicenceNumber = @oldLN
	
ALTER TABLE cabs_production.cabs_dvl.VehicleDriver WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.cabs_tds.SignageInstallation WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.Booking WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.BookingAudit WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.VehicleInspections WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.cabs_insp.VehicleInspectionsDraft WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.LicenceNominee WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.LicenceRepresentative WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.PaymentRefundVL WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.PaymentVL WITH CHECK CHECK CONSTRAINT ALL
ALTER TABLE cabs_production.dbo.LicenceMasterVL WITH CHECK CHECK CONSTRAINT ALL


UPDATE	cabs_production.[cabs_dck].[DriverCheckReport]
SET		VehicleLicenceNumber = @newLN
WHERE	VehicleLicenceNumber = @oldLN

UPDATE	cabs_production.[cabs_dck].[DriverCheckSearchResult]
SET		VehicleLicenceNumber = @newLN
WHERE	VehicleLicenceNumber = @oldLN

UPDATE	cabs_production.cabs_dck.DriverCheckLog
SET		SearchTerm = @newLN
WHERE	SearchTerm = @oldLN

UPDATE	cabs_production.cabs_enf.Audit
SET		VehicleLicenceNumber = @newLN
WHERE	VehicleLicenceNumber = @oldLN

UPDATE	cabs_production.cabs_enf.CaseNotes
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.cabs_rta.RentalAgreement
SET		VehicleLicenceNo = @newLN
WHERE	VehicleLicenceNo = @oldLN

UPDATE	cabs_production.[cabs_tds].[ImportSignage]
SET		[Licence No] = @newLN
WHERE	[Licence No] = @oldLN

UPDATE	cabs_production.dbo.LicenceMasterVLAudit
SET		LicenceNumber = @newLN
		--,LicenceTypeId = 4
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.PrintRequestMasterVL
SET		LicenceNumber = @newLN,
		LicenceType = @newTypeDescription
WHERE	LicenceNumber = @oldLN

UPDATE	cabs_production.dbo.SystemProcessInstanceVL
SET		LicenceNumber = @newLN
WHERE	LicenceNumber = @oldLN

-- CABS_LIVE

UPDATE	cabs_live.dbo.Cases
SET		vehicle_licenceno = @newLN
WHERE	vehicle_licenceno = @oldLN

UPDATE	cabs_live.dbo.Cases
SET		field1 = @newLN
WHERE	field1 = @oldLN


UPDATE	cabs_live.dbo.[DWH_LicenceMaster]
SET		Licence_Nbr = @newLN
WHERE	Licence_Nbr = @oldLN

UPDATE  [cabs_production].[cabs_enf].[Fines]
SET		[VehicleLicenceNumber] = @newLN
WHERE	[VehicleLicenceNumber] = @oldLN

UPDATE  [cabs_production].[cabs_enf].[Fines]
SET		[InfoLicenceNumber] = @newLN
WHERE	[InfoLicenceNumber] = @oldLN

-- ====================================================================================
-- Create [WatRegister] entry
-- ====================================================================================

DECLARE @email nvarchar(255)
DECLARE @contactNumberBookings nvarchar(255)
DECLARE @contactNumberMobile nvarchar(255)
DECLARE @comments nvarchar(max)
--DECLARE @webSite nvarchar(255)

SELECT @email = LHM.Email
	  ,@contactNumberBookings = LHM.PhoneNo1
	  ,@contactNumberMobile = LHM.PhoneNo2
	  ,@comments = LHM.Comments
	  --,@webSite = LHM.?
FROM cabs_production.dbo.LicenceMasterVL AS VLM
JOIN cabs_production.dbo.LicenceHolderMaster AS LHM ON VLM.LicenceHolderId = LHM.LicenceHolderId
WHERE VLM.LicenceNumber = @newLN

--PRINT @email
--PRINT @contactNumberBookings
--PRINT @contactNumberMobile
--PRINT @comments


--fix for NTACQR1701-147 - 138 - Inspection disapearing during exchange process 
declare @licenceExist int;
set @licenceExist = (select count(*) from [cabs_production].[dbo].[WatRegister] 
where LicenceNumber = @newLN);

IF @newType = 4 and @licenceExist = 0
BEGIN
	INSERT INTO [cabs_production].[dbo].[WatRegister]
           ([LicenceNumber]
           ,[DispatchOperatorId]
           ,[Email]
           ,[ContactNumberBookings]
           ,[ContactNumberMobile]
           ,[WebSite]
           ,[Comments]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[WavGrantStatusID]
           ,[WavGrantExpiryDate])
     VALUES
           (
            @newLN		--<LicenceNumber, nvarchar(20),>
           ,NULL		--<DispatchOperatorId, int,>
           ,@email		--<Email, nvarchar(255),>
           ,@contactNumberBookings		--<ContactNumberBookings, nvarchar(255),>
           ,@contactNumberMobile		--<ContactNumberMobile, nvarchar(255),>
           ,NULL		--<WebSite, nvarchar(255),>
           ,@comments	--<Comments, nvarchar(max),>
           ,'system'	--<CreatedBy, nvarchar(20),>
           ,GETDATE()	--<CreatedDate, datetime,>
           ,'system'	--<ModifiedBy, nvarchar(20),>
           ,GETDATE()	--<ModifiedDate, datetime,>
           ,1			--<WavGrantStatusID, int,>
           ,NULL		--<WavGrantExpiryDate, smalldatetime,>
           )
END

	COMMIT
END TRY
BEGIN CATCH
-- throw exact error
DECLARE @ErrorMessage NVARCHAR(max) = 'Error: ' + ERROR_MESSAGE();
		DECLARE @ErrSeverity INT,@ErrState INT;

		SELECT @ErrSeverity = error_severity()
			,@ErrState = error_state();

		RAISERROR (
				@ErrorMessage
				,@ErrSeverity
				,@ErrState);
				
    --PRINT 'Error: ' + ERROR_MESSAGE();
    IF @@TRANCOUNT > 0
        ROLLBACK
    RETURN 0
END CATCH

RETURN 1

END

GO
