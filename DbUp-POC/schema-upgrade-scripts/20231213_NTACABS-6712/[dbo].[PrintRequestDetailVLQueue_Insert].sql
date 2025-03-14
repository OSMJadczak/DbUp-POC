USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[PrintRequestDetailVLQueue_Insert]    Script Date: 13/12/2023 12:28:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[PrintRequestDetailVLQueue_Insert]
(
	@PrintCompanyId int,
	@PrintRequestStatusId int,
	@Limit int
)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @BatchNumber varchar(50),
			@CreatedDate datetime,
			@ErrorMessage varchar(4000)
		
	
	SET @CreatedDate = GETDATE()
	SET @BatchNumber = CONVERT(VARCHAR(20), @CreatedDate, 120)
	SET @BatchNumber = REPLACE(@BatchNumber, ' ', '')
	SET @BatchNumber = REPLACE(@BatchNumber, '-', '')
	SET @BatchNumber = REPLACE(@BatchNumber, ':', '')
	
	BEGIN TRY

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	BEGIN TRANSACTION FINISH
		
	
	INSERT INTO dbo.PrintRequestDetailVLQueue
	(
		BatchNumber,
		PrintCompanyId,
		CreatedDate,
		Completed
	)
	VALUES
	(
		@BatchNumber,
		@PrintCompanyId,
		@CreatedDate,
		0
	)
	
	INSERT INTO dbo.PrintRequestDetailVLQueueItem
	(
		BatchNumber,
		PrintRequestId,
		Printed
	)
	SELECT	top(@Limit)
	@BatchNumber, 
	PrintRequestId,
	0
	FROM dbo.PrintRequestDetailVL P
	WHERE PrintCompanyId = @PrintCompanyId
	AND PrintRequestStatusId = @PrintRequestStatusId
	AND PrintRequestMasterId NOT IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL_InvalidRequests
	)
	AND PrintRequestMasterId IN
	(
		SELECT PrintRequestMasterId FROM dbo.PrintRequestMasterVL where SkBookingID is null and LetterRequestTypeAuditId IN 
        (
			--14/03/2019 - mlinke - add IsActive check on letterType
            SELECT [LetterRequestTypeAuditId] FROM [dbo].[LetterRequestTypeVLAudit] lraudit
            left join [dbo].LetterRequestTypeVL lrtype on lrtype.LetterRequestTypeId = lraudit.LetterRequestTypeId
            where lrtype.IsActive = 1
        )
	)
	
	COMMIT TRANSACTION FINISH
			
	SELECT @BatchNumber As BatchNumber, (SELECT COUNT(1) FROM dbo.PrintRequestDetailVLQueueItem WHERE BatchNumber = @BatchNumber) As BatchCount
	
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
						@CreatedDate,
						1,
						'ERROR',
						'PrintRequestDetailVLQueue_Insert',
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
END

