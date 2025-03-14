USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[sch_InactiveSuspendedLicence]    Script Date: 4/24/2020 2:48:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sch_InactiveSuspendedLicence] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @LicenceNumber varchar(10),
		@PlateNumber INT,		
		@LicenceTypeId INT,
		@Counter INT,
		@LicenceHolderId INT,
		@VehicleRegistrationNumber varchar(10),
		@RegistrationDate DATETIME,
		@LicenceExpiryDate DATETIME,		
		@RequestId INT,
		@ModifiedDate DATETIME,
		@ErrorMessage varchar(4000),
		@LetterError varchar(4000),
		@LicenceStateId INT,
		@SuspensionEndDate DATETIME,
		@AuditLicenceStateId INT,
		@AuditLicenceStateMasterId INT
		
		


--A counter of 2000 is set to prevent any infinite loops...		
SET @Counter = 1
SET @ModifiedDate = GETDATE()

WHILE (1 = 1 AND @Counter < 2000)
BEGIN
	SET @Counter = @Counter + 1
		
	SELECT	TOP 1	@LicenceNumber = L.LicenceNumber,
					@PlateNumber = PlateNumber,
					@LicenceTypeId = L.LicenceTypeId,
					@LicenceHolderId = L.LicenceHolderId,
					@VehicleRegistrationNumber = L.RegistrationNumber,
					@RegistrationDate = RegistrationDate,
					@LicenceExpiryDate =LicenceExpiryDate ,
					@LicenceStateId = LicenceStateId,
					@SuspensionEndDate = SuspensionEndDate
	FROM dbo.LicenceMasterVL L
	INNER JOIN dbo.LicenceHolderMaster H ON H.LicenceHolderId = L.LicenceHolderId
	INNER JOIN dbo.VehicleMaster V ON V.RegistrationNumber = L.RegistrationNumber
	INNER JOIN dbo.LicenceType T on L.LicenceTypeId = T.LicenceTypeId
	WHERE L.LicenceStateMasterId = 5 --inactive
	AND L.LicenceStateId=11 --Suspended
	AND dbo.IsDateExpired(SuspensionEndDate) = 1
	
		
	--If none are found, stop
	IF @LicenceNumber IS NULL
	BEGIN
		BREAK
	END
	

	
	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

		BEGIN TRANSACTION FINISH

			  SELECT  top 1  @AuditLicenceStateId = LMA.LicenceStateId,
						  @AuditLicenceStateMasterId = LMA.LicenceStateMasterId						  
			FROM   dbo.LicenceMasterVLAudit LMA
			WHERE  (LMA.LicenceNumber = @LicenceNumber
					AND (LMA.LicenceStateId <> 11  OR LMA.LicenceStateId is NULL))
					order by id desc

		/*
		  That an active licence which is suspended, and goes into inactive-deferred status during the suspension period,
		  is restored to inactive-deferred on the expiration of the suspension		   
		*/
			DECLARE @defLicenceNumber AS VARCHAR (10)                
			Select TOP 1 @defLicenceNumber= l.LicenceNumber from dbo.LicenceMasterVL l 
						Where l.RegistrationNumber=@VehicleRegistrationNumber 
						AND l.LicenceNumber <> 
				(Select TOP 1 v.LicenceNumber from dbo.LicenceMasterVL v Where v.LicenceStateMasterId=4 AND v.RegistrationNumber=@VehicleRegistrationNumber)
				AND l.LicenceNumber=@LicenceNumber
				AND @AuditLicenceStateMasterId = 4;				   

			

		  ---Get HistoryChangeType for Suspended End---
		   DECLARE @HistoryChangeID INT = (SELECT HistoryChangeId FROM [cabs_production].[dbo].[HistoryChangeType] WHERE [HistoryChangeType] = 'Suspended End');
			
			 IF ((@defLicenceNumber IS NOT NULL AND @defLicenceNumber <>'' ) AND (@LicenceExpiryDate>=CONVERT(datetime,@SuspensionEndDate) AND  ( @AuditLicenceStateMasterId = 4 )))
                    BEGIN
					SET @RequestId = 1
				UPDATE dbo.LicenceMasterVL
						SET LicenceStateMasterId = 5, -- Inactive
						LicenceStateId = 9, ---Deferred
						ModifiedBy = 'System',
						ModifiedDate = @ModifiedDate,
						HistoryChangeId = @HistoryChangeID -- Suspended End
						WHERE LicenceNumber = @LicenceNumber
					END
			ELSE IF (@LicenceExpiryDate>=CONVERT(datetime,@SuspensionEndDate) AND  ( @AuditLicenceStateId <> 9 OR @AuditLicenceStateId IS NULL))
			BEGIN 
				--Example : if a licence expiring 01 July 2015 is suspended until 01 May 2015,
				-- when the suspension expires the licence should be restored to Active status.
				SET @RequestId = 1
				UPDATE dbo.LicenceMasterVL
						SET LicenceStateMasterId = 4, -- Active
						LicenceStateId = NULL,
						ModifiedBy = 'System',
						ModifiedDate = @ModifiedDate,
						HistoryChangeId = @HistoryChangeID -- Suspended End
						WHERE LicenceNumber = @LicenceNumber
			END
		ELSE IF (@LicenceExpiryDate<CONVERT(datetime,@SuspensionEndDate)  AND  @AuditLicenceStateMasterId = 5 AND  @AuditLicenceStateId = 8)
			BEGIN 
				-- Example : if a licence expiring 01 July 2015 is suspended until 01 August 2015 
				--(i.e. if the licence expired while the temporary suspension is in place), 
				--when the suspension expires the licence should be restored to Inactive-Expired status.
				SET @RequestId = 1				
				UPDATE dbo.LicenceMasterVL
						SET LicenceStateMasterId = 5, -- Inactive
						LicenceStateId = 8, ---Expired
						ModifiedBy = 'System',
						ModifiedDate = @ModifiedDate,
						HistoryChangeId = @HistoryChangeID -- Suspended End
						WHERE LicenceNumber = @LicenceNumber
			END
		ELSE IF (@LicenceExpiryDate<CONVERT(datetime,@SuspensionEndDate)  AND  @AuditLicenceStateMasterId = 4)
			BEGIN 
				-- if a licence expiring 01 July 2015 is suspended until 01 August 2015 
				--(i.e. if the licence expired while the temporary suspension is in place), 
				--when the suspension expires the licence should be restored to original status to active
				-- then next expired licence job will be execute and change to Inactive-Expired status.
				SET @RequestId = 1				
				UPDATE dbo.LicenceMasterVL
						SET LicenceStateMasterId = 4, -- Active
						LicenceStateId = NULL,
						ModifiedBy = 'System',
						ModifiedDate = @ModifiedDate,
						HistoryChangeId = @HistoryChangeID -- Suspended End
						WHERE LicenceNumber = @LicenceNumber
			END
		ELSE IF (@AuditLicenceStateMasterId = 5 AND  @AuditLicenceStateId = 9)
			BEGIN 				
				--Example : if a licence in deferred-status, expiring 01 February 2015 is suspended until 01 March 2015,
				--that a licence in inactive-deferred status is restored once the suspension end date is reached. 
				--Expected result: status of inactive-deferred is restored, unless the licence expires in the meantime. 				
				SET @RequestId = 1
				UPDATE dbo.LicenceMasterVL
						SET LicenceStateMasterId = 5, -- Inactive
						LicenceStateId = 9, ---Deferred
						ModifiedBy = 'System',
						ModifiedDate = @ModifiedDate,
						HistoryChangeId = @HistoryChangeID -- Suspended End
						WHERE LicenceNumber = @LicenceNumber
			END
		ELSE IF (@LicenceExpiryDate<CONVERT(datetime,@SuspensionEndDate)  AND  @AuditLicenceStateMasterId = 5 AND  @AuditLicenceStateId = 15)
			BEGIN 				
				--Example : if a licence in probate-status, expiring 01 February 2015 is suspended until 01 March 2015,				
				SET @RequestId = 1
				UPDATE dbo.LicenceMasterVL
						SET LicenceStateMasterId = 5, -- Inactive
						LicenceStateId = 15, ---Probate
						ModifiedBy = 'System',
						ModifiedDate = @ModifiedDate,
						HistoryChangeId = @HistoryChangeID -- Suspended End
						WHERE LicenceNumber = @LicenceNumber
			END
		ELSE IF (@LicenceExpiryDate<=CONVERT(datetime,@SuspensionEndDate)  AND  @AuditLicenceStateMasterId = 6 AND  @AuditLicenceStateId = 14)
			BEGIN 				
				--Example : if an expired licence, which expired on  01 March 2014 is suspended until 01 May 2015,
				-- when the suspension expires the licence should be restored to Dead-Timed Out status. 
				SET @RequestId = 1
				UPDATE dbo.LicenceMasterVL
						SET LicenceStateMasterId = 6, -- Dead
						LicenceStateId = 14, ---Timed out
						ModifiedBy = 'System',
						ModifiedDate = @ModifiedDate,
						HistoryChangeId = @HistoryChangeID -- Suspended End
						WHERE LicenceNumber = @LicenceNumber
			END
		

	
				

		IF @RequestId = 1
			BEGIN
			 EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber = @LicenceNumber, @ModifiedDate = @ModifiedDate
			END
					
		SET @LicenceNumber = NULL
		SET @RequestId = NULL
		SET @AuditLicenceStateId = NULL
		SET @defLicenceNumber = NULL
		SET @VehicleRegistrationNumber = NULL
		SET @AuditLicenceStateMasterId = NULL
		SET @LicenceExpiryDate = NULL

		COMMIT TRANSACTION FINISH
			
	END TRY

	BEGIN CATCH
	
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION FINISH
		END
			SET @ErrorMessage = ERROR_MESSAGE()
		
			Begin Try
			--Log the error
		
			INSERT INTO [dbo].[PrintEventLogs]
					(
						[Date],
						[Thread],
						[Level],
						[Logger],
						[Message],
						[Usr]
					)
			VALUES
					(
						@ModifiedDate,
						1,
						'ERROR',
						'sch_InactiveSuspendedLicence',
						@ErrorMessage,
						'System'
					)
					
			End	Try
					
			BEGIN CATCH
					
			--Nothing to do if the Print Event Log fails
					
			END CATCH
		
		
		RAISERROR (@ErrorMessage, 16, 1);
			
		RETURN 0
		
	END CATCH
			
	CONTINUE
END
END

------------------*********************END HERE*************************----------------------------



GO


