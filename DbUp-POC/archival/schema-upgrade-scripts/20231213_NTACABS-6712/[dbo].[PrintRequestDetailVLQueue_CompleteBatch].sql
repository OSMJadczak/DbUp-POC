USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[PrintRequestDetailVLQueue_CompleteBatch]    Script Date: 13/12/2023 13:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Damien Dennehy
-- Create date: 05-May-2011
-- =============================================
ALTER PROCEDURE [dbo].[PrintRequestDetailVLQueue_CompleteBatch]
(
	@BatchNumber varchar(50),
	@PrintRequestStatusId int
)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @ModifiedDate datetime,
			@ErrorMessage varchar(4000)
		
	SET @ModifiedDate = GETDATE()
	
	BEGIN TRY

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	BEGIN TRANSACTION FINISH
	
	UPDATE dbo.PrintRequestDetailVLQueue
	SET Completed = 1,
	CompleteDate = @ModifiedDate
	WHERE BatchNumber = @BatchNumber
		
	UPDATE dbo.PrintRequestDetailVL
	SET PrintRequestStatusId = @PrintRequestStatusId,
	PrintDate = @ModifiedDate,
	ModifiedBy = 'System',
	ModifiedDate = @ModifiedDate,
	PrintBatchNumber = @BatchNumber
	WHERE PrintRequestId IN
	(
		SELECT PrintRequestId FROM dbo.PrintRequestDetailVLQueueItem
		WHERE BatchNumber = @BatchNumber and PrintRequestDetailVLQueueItem.Printed =1
	)
	
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
						'PrintRequestDetailVLQueue_CompleteBatch',
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

