USE [msdb]
GO

/****** Object:  Job [Import Vehicle Licence To Cabs]    Script Date: 5/28/2020 12:07:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 5/28/2020 12:07:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Import Vehicle Licence To Cabs', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Imports data from the DWH_LicenceHolderMaster, DWH_LicenceMaster and DWH_VehicleMaster into corresponding tables in Cabs', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CABS\sql_NTA-CABS2-DB1', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Do Import]    Script Date: 5/28/2020 12:07:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Do Import', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Use Cabs_Live
Go
delete from dbo.DWH_LicenceHolderMaster
delete from  dbo.DWH_LicenceMaster
delete from  dbo.DWH_VehicleMaster
Go


Insert into dbo.DWH_LicenceHolderMaster(LicenceHolderURN,CCSN,Title_Cd,First_Nm,Last_Nm,Addr_1,Addr_2,
Addr_3,Town,PostCode,County,Company_Number,Company,TradingAs,PhoneNumber,MobileNumber,Pps_Number,
TaxClearanceNumber,TaxClearanceExpiryDate,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
Select * From [nta-cabs2-db2].TRDWH.dbo.DWH_LicenceHolderMaster

Insert into dbo.DWH_LicenceMaster(Licence_Nbr,Plate_Nbr,Reg_Nbr,CCSN,IssueDate,ExpiryDate,SPSVCategoryId,
LicenceState,LicenceSubState,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Status, REMAINING_TRANSFERS, transfer_date, LicenceHolderURN,Pps_Number,SuspensionEndDate)
Select * From [nta-cabs2-db2].TRDWH.dbo.DWH_LicenceMaster

Insert into dbo.DWH_VehicleMaster(Reg_Nbr,Make,Model,Colour,BodyStyle,VIN,DateFirstReg,EngineCC,NbrSeats,
NbrPassengers,EUVehicleCategory,TypeApprovalNumber,VRTCode,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,
ExcessWindowTint,DateOfRegistrationInIreland,YearOfManufacture,PermissibleMassGVW,TypeApprovalCategory,SIMIStatisticalCode)
Select * From [nta-cabs2-db2].TRDWH.dbo.DWH_VehicleMaster', 
		@database_name=N'Cabs_Live', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'ImportVehicleData', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20100621, 
		@active_end_date=99991231, 
		@active_start_time=84500, 
		@active_end_time=235959, 
		@schedule_uid=N'f2930673-5ff7-4c88-a369-ce87ae85dbf0'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

