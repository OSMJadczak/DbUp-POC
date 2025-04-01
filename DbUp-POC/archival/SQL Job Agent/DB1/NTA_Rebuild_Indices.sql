USE [msdb]
GO

/****** Object:  Job [NTA_Rebuild_Indices]    Script Date: 5/28/2020 12:08:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 5/28/2020 12:08:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'NTA_Rebuild_Indices', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [cabs_production]    Script Date: 5/28/2020 12:08:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'cabs_production', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Ensure a USE <databasename> statement has been executed first.

SET QUOTED_IDENTIFIER ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130);
DECLARE @objectname nvarchar(130);
DECLARE @indexname nvarchar(130);
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000);

--DROP TABLE #work_to_do;
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function
-- and convert object and index IDs to names.

SELECT
    s.object_id AS objectid,
    s.index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag,
    o.name as table_name, 
    i.name as index_name, 
    SCHEMA_NAME(schema_id) s_name
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, ''LIMITED'') s
join sys.objects o on o.object_id = s.object_id
join sys.indexes i on i.index_id = s.index_id and i.object_id = s.object_id
WHERE avg_fragmentation_in_percent > 8.0 AND s.index_id > 0
AND
--------------------------------
-- tables which will be affected
--------------------------------
(
o.name like ''aspnet_%'' 
OR SCHEMA_NAME(schema_id) like ''cabs_%''
OR o.name in (''DriverImages'', ''LicenceHolderMaster'', ''LicenceMaster'', ''LicenceState'', ''LicenceStateMaster'', ''LicenceType'', ''VehicleMake'', ''VehicleMaster'', ''VehicleModel'') -- cabs_live tables
OR o.name in (''DriverMaster'', ''LicenceHolderImage'', ''LicenceHolderMaster'', ''LicenceMaster'', ''LicenceMasterVL'', ''LicenceState'', ''LicenceStateMaster'', ''LicenceType'', ''VehicleMake'', ''VehicleMaster'', ''VehicleModel'' ) -- cabs_production tables
);

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT objectid,
									 indexid,
									 partitionnum,
									 frag 
							   FROM #work_to_do

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;

        IF @@FETCH_STATUS < 0 BREAK;
        
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
        --IF @frag < 30.0
        --    SET @command = N''ALTER INDEX '' + @indexname + N'' ON '' + @schemaname + N''.'' + @objectname + N'' REORGANIZE'';
        --IF @frag >= 30.0
            SET @command = N''ALTER INDEX '' + @indexname + N'' ON '' + @schemaname + N''.'' + @objectname + N'' REBUILD'';

        IF @partitioncount > 1
            SET @command = @command + N'' PARTITION='' + CAST(@partitionnum AS nvarchar(10));

        EXEC (@command);

        PRINT N''Executed: '' + @command;

        print @indexname + N'' ON '' + @schemaname + N''.'' + @objectname + N'' - '' + cast(@frag as varchar)

    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

--select table_name, INDEX_name, s_name, frag from #work_to_do w  
--order by table_name

-- Drop the temporary table.
DROP TABLE #work_to_do;
GO', 
		@database_name=N'cabs_production', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [cabs_live]    Script Date: 5/28/2020 12:08:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'cabs_live', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Ensure a USE <databasename> statement has been executed first.

SET QUOTED_IDENTIFIER ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130);
DECLARE @objectname nvarchar(130);
DECLARE @indexname nvarchar(130);
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000);

--DROP TABLE #work_to_do;
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function
-- and convert object and index IDs to names.

SELECT
    s.object_id AS objectid,
    s.index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag,
    o.name as table_name, 
    i.name as index_name, 
    SCHEMA_NAME(schema_id) s_name
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, ''LIMITED'') s
join sys.objects o on o.object_id = s.object_id
join sys.indexes i on i.index_id = s.index_id and i.object_id = s.object_id
WHERE avg_fragmentation_in_percent > 8.0 AND s.index_id > 0
AND
--------------------------------
-- tables which will be affected
--------------------------------
(
o.name like ''aspnet_%'' 
OR SCHEMA_NAME(schema_id) like ''cabs_%''
OR o.name in (''DriverImages'', ''LicenceHolderMaster'', ''LicenceMaster'', ''LicenceState'', ''LicenceStateMaster'', ''LicenceType'', ''VehicleMake'', ''VehicleMaster'', ''VehicleModel'') -- cabs_live tables
OR o.name in (''DriverMaster'', ''LicenceHolderImage'', ''LicenceHolderMaster'', ''LicenceMaster'', ''LicenceMasterVL'', ''LicenceState'', ''LicenceStateMaster'', ''LicenceType'', ''VehicleMake'', ''VehicleMaster'', ''VehicleModel'' ) -- cabs_production tables
);

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT objectid,
									 indexid,
									 partitionnum,
									 frag 
							   FROM #work_to_do

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;

        IF @@FETCH_STATUS < 0 BREAK;
        
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
        --IF @frag < 30.0
        --    SET @command = N''ALTER INDEX '' + @indexname + N'' ON '' + @schemaname + N''.'' + @objectname + N'' REORGANIZE'';
        --IF @frag >= 30.0
            SET @command = N''ALTER INDEX '' + @indexname + N'' ON '' + @schemaname + N''.'' + @objectname + N'' REBUILD'';

        IF @partitioncount > 1
            SET @command = @command + N'' PARTITION='' + CAST(@partitionnum AS nvarchar(10));

        EXEC (@command);

        PRINT N''Executed: '' + @command;

        print @indexname + N'' ON '' + @schemaname + N''.'' + @objectname + N'' - '' + cast(@frag as varchar)

    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

--select table_name, INDEX_name, s_name, frag from #work_to_do w  
--order by table_name

-- Drop the temporary table.
DROP TABLE #work_to_do;
GO', 
		@database_name=N'Cabs_Live', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Rebuild_sch', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20130130, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'38b87ace-0dcd-4fe5-8810-f122cbf40fdd'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

