USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[PrintRequestDetailVLQueue_Insert]    Script Date: 12/12/2023 12:13:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or ALTER PROCEDURE [dbo].[PrintRequestDetailVLQueue_RemoveFromQueue]
(
	@BatchNumber varchar(50),
	@PrintRequestmasterId int
)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @CreatedDate datetime,
			@ErrorMessage varchar(4000)
		
	
	SET @CreatedDate = GETDATE()

	
	BEGIN TRY

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	BEGIN TRANSACTION FINISH
	
	delete from dbo.PrintRequestDetailVLQueueItem
	where PrintRequestDetailVLQueueItem.PrintRequestId = @PrintRequestmasterId and PrintRequestDetailVLQueueItem.BatchNumber = @BatchNumber;
	
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
						'PrintRequestDetailVLQueue_RemoveFromQueue',
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

