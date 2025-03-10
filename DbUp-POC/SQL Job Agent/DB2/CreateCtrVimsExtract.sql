USE [msdb]
GO

/****** Object:  Job [CreateCtrVimsExtract]    Script Date: 5/28/2020 12:10:30 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 5/28/2020 12:10:30 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'CreateCtrVimsExtract', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'CABS\sql_NTA-CABS2-DB2', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CreateSnapShot]    Script Date: 5/28/2020 12:10:30 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CreateSnapShot', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Exec USP_DWH_CTRVIMSExtract_Insert', 
		@database_name=N'TRDWH', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create Excel File]    Script Date: 5/28/2020 12:10:30 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create Excel File', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'sp_configure ''show advanced options'', 1;
Go
RECONFIGURE;
Go
sp_configure ''xp_cmdshell'', 1;
Go
RECONFIGURE;
Go

Exec Master..xp_cmdshell ''bcp "Select * From (Select ''''Reg_Nbr'''' As Reg_Nbr, ''''Plate_Nbr'''' As Plate_Nbr, ''''Licence_Nbr'''' As Licence_Nbr, ''''Old_Plate_Nbr'''' As Old_Plate_Nbr, ''''First_Nm'''' As First_Nm, ''''Last_Nm'''' As Last_Nm, ''''Title_Cd'''' As Title_Cd, ''''Addr_1'''' As Addr_1, ''''Addr_2'''' As Addr_2, ''''Town'''' As Town, ''''Company'''' As Company, ''''Status'''' As Status, ''''Authority'''' As Authority, ''''County'''' As County, ''''ExpiryDate'''' As ExpiryDate, ''''Make'''' As Make, ''''Model'''' As Model, ''''Colour'''' As Colour, ''''PhoneNumber'''' As PhoneNumber, ''''MobileNumber'''' As MobileNumber, ''''Pps_Number'''' As Pps_Number, ''''Company_Number'''' As Company_Number, ''''Refused_Mobile_No'''' As Refused_Mobile_No, ''''VIN'''' As VIN, ''''DateFirstReg'''' As DateFirstReg, ''''EngineCC'''' As EngineCC, ''''LicenceLetter'''' As LicenceLetter, ''''NbrPassengers'''' As NbrPassengers, ''''IssueDate'''' As IssueDate, ''''TestCentre'''' As TestCentre, ''''TaxClearanceNumber'''' As TaxClearanceNumber, ''''TaxClearanceExpiryDate'''' As TaxClearanceExpiryDate, ''''InsuranceCertNumber'''' As InsuranceCertNumber, ''''InsuranceCertExpiryDate'''' As InsuranceCertExpiryDate) As T" queryout "D:\ExtractFiles\CTRExtract.xls" -c -T''

Exec Master..xp_cmdshell ''bcp "Select Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd, Addr_1, Addr_2, Town, Company, [Status], Authority, County, ExpiryDate, Make, Model, Colour, PhoneNumber, MobileNumber, Pps_Number, Company_Number, Refused_Mobile_No, VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate, InsuranceCertNumber, InsuranceCertExpiryDate From TRDWH.dbo.LICENCES_EXTRACT_ARCHIVE_ALL Where ImpFileDate = (Select Max(ImpFileDate) From TRDWH.dbo.LICENCES_EXTRACT_ARCHIVE_ALL)" queryout "c:\Temp\ztempdata.xls" -c -T''

Exec Master..xp_cmdshell ''Type c:\Temp\ztempdata.xls >> D:\ExtractFiles\CTRExtract.xls''

Exec Master..xp_cmdshell ''Del c:\Temp\ztempdata.xls''
Go
sp_configure ''xp_cmdshell'', 0;
Go
RECONFIGURE;
Go
sp_configure ''show advanced options'', 0;
Go', 
		@database_name=N'TRDWH', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'CtrVimsSchedule', 
		@enabled=1, 
		@freq_type=32, 
		@freq_interval=8, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=16, 
		@freq_recurrence_factor=1, 
		@active_start_date=20100211, 
		@active_end_date=99991231, 
		@active_start_time=210000, 
		@active_end_time=235959, 
		@schedule_uid=N'a11e1de9-9b84-44f8-842e-c618bc61b9e6'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

