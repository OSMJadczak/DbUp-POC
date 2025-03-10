USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[sch_CancellationLetters]    Script Date: 6/23/2020 2:37:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:        Syed
-- Create date: 21-June-2012
-- Description:   Send a cancellation letter for all cancelled bookings
-- Modified  BY : Jakub
-- Modified Date : 17/11/2016
-- Added condition if cancellation letter already has been printed so need to stop duplicate letters
-- One letter per Booking Reference
-- No cancellation letter should happen for a transaction that wasn't completed as there is no booking to cancel
--
-- Modified  BY : Adam Nosal
-- Modified Date : 05/12/2018
-- No Cannceleteion letters should be generated when there is noShow letter in the system already
-- =============================================

ALTER PROCEDURE [dbo].[sch_CancellationLetters] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @cancellationLetterStartDateSystem datetime
	DECLARE @lastBatchRan datetime 
	DECLARE @LetterRequestType int
	DECLARE @LetterRequestTypeAuditId int
	DECLARE @InError int
	
	SET @cancellationLetterStartDateSystem = (SELECT ParameterValue FROM SystemParameter WHERE ParameterName = 'sch_cancellationLetter_StartDate')
	SET @LetterRequestTypeAuditId =(
								SELECT MAX(A.LetterRequestTypeAuditId) 
								FROM LetterRequestTypeVLAudit A
								JOIN LetterRequestTypeVL L ON L.LetterRequestTypeId = A.LetterRequestTypeId 
								WHERE L.LetterRequestTypeId = 25
							)
	SET @LetterRequestType =(
							SELECT LetterRequestTypeId
							FROM LetterRequestTypeVL
							WHERE LetterRequestTypeId = 25
						)
	SET @InError = 0 
	
	-- Ensure that the system parameter last start date exists
	IF(@cancellationLetterStartDateSystem IS NULL )
	BEGIN
		SET @InError = 1 
		Raiserror ('sch_cancellationLetter_StartDate parameter is not present. This most be there before this procedure can run.', 16, 1);
	END
	
	-- Ensure that the cancellation letter template exists
	IF(@LetterRequestType IS NULL)
	BEGIN
		SET @InError = 1 
		Raiserror ('No cancellation letter is present', 16, 1);
	END

	IF @InError = 0
	BEGIN
		-- Get the date this schedule was last run
		SET @lastBatchRan = ISNULL((SELECT MAX(CreatedDate) FROM PrintRequestMasterVL WHERE LetterRequestTypeAuditId = @LetterRequestTypeAuditId), @cancellationLetterStartDateSystem)

	
	    create table CancelledBookingIDs (BookingId int);
		
--------Gather all the booking IDS ------------------------------------------------
		insert into CancelledBookingIDs (BookingId)
		SELECT B.BookingId  FROM 
                   Booking B
                   JOIN BookingPayment BP ON BP.BookingId = B.BookingId
                   JOIN PaymentVL P ON P.PaymentId = BP.PaymentId
                   WHERE 
                    (P.[PaymentReference] IS NOT NULL AND B.BookingStatusId = 5)
					AND B.ModifiedDate > getdate()-1
					AND B.SystemProcessId <> 22 -- Don't send cancellation letters for Measurement Inspections
				   Group BY
                   B.BookingId
				UNION 
				SELECT B.BookingId  FROM 
					Booking B                 
					WHERE 
					(B.BookingStatusId = 5 AND B.SystemProcessId = 11)
					AND B.ModifiedDate > getdate()-1
					Group BY
					B.BookingId
				 UNION 
				SELECT B.BookingId  FROM 
					Booking B                 
					WHERE 
					(B.BookingStatusId IN (3,5))  -- For Open-Failed Booking and Cancelled-Failed, A Booking Cancellation letter should be generated overnight
					AND B.ModifiedDate > getdate()-1
					AND B.BookingId IN (Select BookingId from dbo.VehicleInspections
										Where TestResultId = 6)   -----TestResultId = 6 = Fail (Closed)
					Group BY
					B.BookingId
				Order By B.BookingId desc;

----------------No Canncelation letters if there is already Noshow letter for this booking-----------------------------
			
			--delete from CancelledBookingIDs 
			--	where BookingId in (
			--		Select PRM.BookingId
			--		from PrintRequestMasterVL PRM 
			--		where PRM.BookingId = CancelledBookingIDs.BookingId 
			--		and PRM.LetterRequestTypeAuditId = @NoShowLetterRequestTypeId
			--		and 
			--		(
			--		select count(*)from PrintRequestMasterVL  
			--		where PrintRequestMasterVL.BookingId = PRM.BookingId 
			--		and PrintRequestMasterVL.LetterRequestTypeAuditId = @NoShowLetterRequestTypeId 
			--		)>0
			--	)
		
		
			 
		-- Get all of the values for the cancellation letters
		-- put them into a temp table and call the USP_DWH_PrintRequestVL_Insert
		DECLARE @cursorbookingId int
		DECLARE booking_cursor CURSOR FOR  select BookingID from CancelledBookingIDs
				
		-- run the USP_DWH_PrintRequestVL_Insert
		DECLARE @RC int
		DECLARE @PrintRequestId int
		DECLARE @LicenceNumber varchar(50)
		DECLARE @LicenceHolderId int
		DECLARE @NewLicenceHolderId int
		DECLARE @PreviousLicenceHolderId int
		DECLARE @VehicleRegistrationNumber varchar(10)
		DECLARE @NewVehicleRegistrationNumber varchar(10)
		DECLARE @PreviousVehicleRegistrationNumber varchar(10)
		DECLARE @BookingId int
		DECLARE @PaymentId int
		DECLARE @PrintRequestReasonId int
		--DECLARE @LetterRequestTypeId int
		DECLARE @CreatedBy nvarchar(50)
		DECLARE @LetterDate datetime
		DECLARE @BookingCancellationReasonId int
		
		OPEN booking_cursor 
		FETCH NEXT FROM booking_cursor INTO @cursorbookingId  

		WHILE @@FETCH_STATUS = 0  
		BEGIN   

			-- TODO: Set parameter values here.
			SET @BookingId = @cursorbookingId
					
			SELECT 
				@LicenceNumber = B.LicenceNumber,
				@VehicleRegistrationNumber = B.RegistrationNumber,
				@LicenceHolderId = H.LicenceHolderId,
				@NewLicenceHolderId = B.NewLicenceHolderId,
				@BookingCancellationReasonId = B.BookingCancellationReasonId
			FROM 
				Booking B
			LEFT JOIN LicenceMasterVL L ON L.LicenceNumber = B.LicenceNumber
			LEFT JOIN LicenceHolderMaster H ON H.LicenceHolderId = L.LicenceHolderId 
			WHERE 
				BookingId = @BookingId 
	
	-- Modified  BY : Syed
	-- Added condition if cancellation letter already has been printed so need to stop duplicate letters
	-- One letter per Booking Reference
	-- IF this is a print request for a booking cancelation then make
	-- sure that a cancellation letter has not already been generated for
	-- this booking id. There may be an issue with jobs that use this procedure running simultaneously hence this check
	DECLARE @PerformInsert int
	SET @PerformInsert = 1
	IF(@BookingId IS NOT NULL AND @BookingCancellationReasonId IS NOT NULL)
	BEGIN
		IF(SELECT  COUNT(1)  FROM PrintRequestMasterVL AS p INNER JOIN  LetterRequestTypeVLAudit AS a ON p.LetterRequestTypeAuditId = a.LetterRequestTypeAuditId
		WHERE (p.BookingId = @BookingId) AND (p.BookingCancellationReason IS NOT NULL) AND (LetterRequestTypeId=25)) > 0
		BEGIN
			SET @PerformInsert = 0
		END
	END

	declare  @NoShowLetterRequestTypeId int =( select [LetterRequestTypeId]
				FROM [dbo].[LetterRequestTypeVL]
				WHERE [LetterCode] = 'BNSL' -- Booking NoShow Letter SPSV
				);

	-- do not insert the letter if there is already no show letter in the system
	IF(@BookingId IS NOT NULL )
	BEGIN
		IF(SELECT  COUNT(1)  FROM PrintRequestMasterVL AS p INNER JOIN  LetterRequestTypeVLAudit AS a ON p.LetterRequestTypeAuditId = a.LetterRequestTypeAuditId
		WHERE (p.BookingId = @BookingId) AND (LetterRequestTypeId= @NoShowLetterRequestTypeId)) > 0
		BEGIN
			SET @PerformInsert = 0
		END
	END


	-- Send Section 15 Renewal and COV cancellation letters to Nominee
	DECLARE @TempLicenceHolderId INT = CASE
									       WHEN @NewLicenceHolderId IS NULL THEN @LicenceHolderId 
									       ELSE @NewLicenceHolderId 
									   END
	IF (@PerformInsert = 1)
	BEGIN
			--When a VL booking goes into Awaiting Payment status and then the system cancels the booking after 15 minutes,a cancellation letter should not generated
			--in these circumstances.
			-- execute the procedure for this record
			IF EXISTS(Select * from Booking Where BookingStatusId=5 
												AND BookingId in (Select BookingId from BookingAudit 	
												Where BookingStatusId = 2 AND BookingId = @cursorbookingId )
						AND BookingId = @cursorbookingId)
			BEGIN
					exec USP_DWH_PrintRequestVL_Insert
					@PrintRequestId = @PrintRequestId OUTPUT,
					@LicenceNumber = @LicenceNumber,
					@LicenceHolderId = @TempLicenceHolderId,
					@NewLicenceHolderId = null,
					@PreviousLicenceHolderId = null,
					@VehicleRegistrationNumber = @VehicleRegistrationNumber,
					@NewVehicleRegistrationNumber = null,
					@PreviousVehicleRegistrationNumber = null,
					@BookingId = @cursorbookingId,
					@PaymentId = null,
					@PrintRequestReasonId = 1,
					@LetterRequestTypeId = @LetterRequestType,
					@CreatedBy = 'System'	
			END
		ELSE IF EXISTS(Select * from Booking Where BookingStatusId IN (3,5) 
												AND BookingId in (Select BookingId from dbo.VehicleInspections
																	Where TestResultId = 6) 
						AND BookingId = @cursorbookingId)		
			BEGIN
					exec USP_DWH_PrintRequestVL_Insert
					@PrintRequestId = @PrintRequestId OUTPUT,
					@LicenceNumber = @LicenceNumber,
					@LicenceHolderId = @TempLicenceHolderId,
					@NewLicenceHolderId = null,
					@PreviousLicenceHolderId = null,
					@VehicleRegistrationNumber = @VehicleRegistrationNumber,
					@NewVehicleRegistrationNumber = null,
					@PreviousVehicleRegistrationNumber = null,
					@BookingId = @cursorbookingId,
					@PaymentId = null,
					@PrintRequestReasonId = 1,
					@LetterRequestTypeId = @LetterRequestType,
					@CreatedBy = 'System'	
			END
	 END
			FETCH NEXT FROM booking_cursor INTO @cursorbookingId 		
		END  

		CLOSE booking_cursor  
		DEALLOCATE booking_cursor 
		drop table if exists CancelledBookingIDs;
	END
	
END

GO


