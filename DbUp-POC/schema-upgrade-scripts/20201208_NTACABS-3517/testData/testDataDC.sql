USE [cabs_production]


begin tran 


declare @i int =0;
declare @maxI int = 15;
declare @maxSequential int =5;
declare @searchTerm int = 45000;

declare @timeDiff int =0;
declare @logStartTime datetime ='2020-11-17 09:40:32.183';
declare @logTime datetime =@logStartTime;



while (@i< @maxI)
begin
 
set @timeDiff = ABS(CHECKSUM(NEWID()) % 45);
set @logTime = dateadd(second, @timeDiff, @logTime );
set @logTime = dateadd(second, @timeDiff, @logTime );
	
	if(@i < @maxSequential)
	--if needs sequential add in 1
	set @searchTerm +=1;
	else 
	-- if not sequential add in random
	set @searchTerm +=ABS(CHECKSUM(NEWID()) % 45);

	INSERT INTO [cabs_dck].[DriverCheckLog]
			   ([SearchTerm]
			   ,[ExternalUserId]
			   ,[SearchDate]
			   ,[Name]
			   ,[Email]
			   ,[PhoneNo]
			   ,[MethodName])
		 VALUES
			   (@searchTerm--<SearchTerm, nvarchar(100),>
			   ,null--<ExternalUserId, uniqueidentifier,>
			   ,@logTime
			   ,null--<Name, nvarchar(100),>
			   ,'d501f5f0-b513-4a4d-aef9-29a1ff2364d9'--<Email, nvarchar(100),>
			   ,null--<PhoneNo, nvarchar(100),>
			   ,'DriverCheckService.GetDriverDetails'--<MethodName, nvarchar(200),>
			   )

set @i +=1;

end 



select top(1000)* from [cabs_dck].[DriverCheckLog]
order by [SearchDate] desc 

rollback

