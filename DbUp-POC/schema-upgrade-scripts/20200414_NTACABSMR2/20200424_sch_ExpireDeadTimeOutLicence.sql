USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[sch_ExpireDeadTimeOutLicence]    Script Date: 4/24/2020 2:28:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Syed
-- Create date: 20-Dec-2012
-- Description:	Process each licence in dead timeout state. UC 08 Carlos
--Update on 08/01/2013
--New rules: Rule 1: 
--If any licence goes to expired > 31/1/2013 then after one year it will go 'Dead Time Out' status.
--Example: licence # 20865
--Licence Expired on: 04/01/2013
--One year rule does apply so it's mean it will go dead time out on 31/01/2014.

--Rule 2: 
--If Inactive-Expired licence greater than 31/12/2008 and licence expiry date is less than ‘31/01/2013’ and 
--it still didn't reactivate so licence holder should be reactivate by 31/01/2014 .if licence holder will not reactivate 
--then overnight job will go change into 'Dead Timeout'.  
-- =============================================
ALTER PROCEDURE [dbo].[sch_ExpireDeadTimeOutLicence] 
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
		@LetterRequestTypeId INT,
		@RequestId INT,
		@ModifiedDate DATETIME,
		@ErrorMessage varchar(4000),
		@LetterError varchar(4000)
		


--A counter of 2000 is set to prevent any infinite loops...		
SET @Counter = 1
SET @ModifiedDate = DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0)

WHILE (1 = 1 AND @Counter < 5000)
BEGIN
	SET @Counter = @Counter + 1
		
	SELECT	TOP 1	@LicenceNumber = L.LicenceNumber,
					@PlateNumber = PlateNumber,
					@LicenceTypeId = L.LicenceTypeId,
					@LicenceHolderId = L.LicenceHolderId,
					@VehicleRegistrationNumber = L.RegistrationNumber,
					@RegistrationDate = RegistrationDate,
					@LicenceExpiryDate = LicenceExpiryDate
	FROM dbo.LicenceMasterVL L
	INNER JOIN dbo.LicenceHolderMaster H ON H.LicenceHolderId = L.LicenceHolderId
	INNER JOIN dbo.VehicleMaster V ON V.RegistrationNumber = L.RegistrationNumber
	INNER JOIN dbo.LicenceType T on L.LicenceTypeId = T.LicenceTypeId
	WHERE L.LicenceStateMasterId = 5
	AND L.LicenceStateId = 8	
	AND ( 
		(L.LicenceExpiryDate>=CONVERT(datetime,'1-31-2013') and DATEADD(year, 1,L.LicenceExpiryDate) < @modifiedDate) --rule 1
		OR
		(L.LicenceExpiryDate<CONVERT(datetime,'1-31-2013') and L.LicenceExpiryDate>=CONVERT(datetime,'12-31-2008') and @modifiedDate>CONVERT(datetime,'01/31/2014')) --rule 2
		OR
		(L.LicenceExpiryDate<CONVERT(datetime,'12-31-2008') and DATEADD(year,5,L.LicenceExpiryDate) < @modifiedDate ) --rule 3
		)
		
	--If none are found, stop
	IF @LicenceNumber IS NULL
	BEGIN
		BREAK
	END
	
	BEGIN TRY

		SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
		
		BEGIN TRANSACTION FINISH
			
		UPDATE dbo.LicenceMasterVL
		SET LicenceStateId = 14,
		LicenceStateMasterId=6,
		ModifiedBy = 'System',
		ModifiedDate = Getdate(),		
		HistoryChangeId = 25 -- Time out (5 years)
		WHERE LicenceNumber = @LicenceNumber
		
		DECLARE @AuditDate DATETIME
		SET @AuditDate = GETDATE()
		EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber = @LicenceNumber, @ModifiedDate = @AuditDate
					
		SET @LicenceNumber = NULL
		
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
						Getdate(),
						1,
						'ERROR',
						'sch_ExpireDeadTimeOutLicence',
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


GO


