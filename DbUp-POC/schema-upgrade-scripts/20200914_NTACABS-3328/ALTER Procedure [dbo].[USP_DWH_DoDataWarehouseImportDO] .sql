
ALTER Procedure [dbo].[USP_DWH_DoDataWarehouseImportDO] 

As

Set NoCount On;
Set DateFormat DMY;

Begin Try
	Begin Transaction DWHDOUpdate
		
		-- External Data Import --
		Truncate Table dbo.SupportCases
		Insert dbo.SupportCases
		Select * From [taxiregulator].dbo.SupportCases With (NoLock)
		
		Truncate Table dbo.DispatchOperator
		Insert dbo.DispatchOperator
		Select * From [taxireg].dbo.DispatchOperator With (NoLock)

		-- Fix for the status as we don't want to update OR for now
		update dbo.DispatchOperator
			set licencestatus = 'AutoApproved'
			where licencestatus = 'active'
		
	
	Commit Transaction DWHDOUpdate
	
	/*Truncate Table dbo.photoTable

	INSERT dbo.photoTable
	SELECT * FROM [TAXI-DB01].[taxiccs].dbo.[photoTable]*/
End Try		

Begin Catch
	--print 'fail'
	RollBack Transaction DWHDOUpdate

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
