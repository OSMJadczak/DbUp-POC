USE OR_Test


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
set @timeDiff = ABS(CHECKSUM(NEWID()) % 60);
set @logTime = dateadd(MILLISECOND, @timeDiff, @logTime );
	
	if(@i < @maxSequential)
	--if needs sequential add in 1
	set @searchTerm +=1;
	else 
	-- if not sequential add in random
	set @searchTerm +=ABS(CHECKSUM(NEWID()) % 45);


INSERT INTO [dbo].[SearchLog]
           ([ip]
           ,[SearchType]
           ,[SearchKey]
           ,[Created]
           ,[UserName])
     VALUES
           ('10.0.0.1'--<ip, nvarchar(30),>
           ,'vehicle'--<SearchType, nvarchar(50),>
           ,'Licence Number:'+ CAST(@searchTerm as nvarchar(20)) --<SearchKey, nvarchar(max),>
           ,@logTime--<Created, datetime,>
           ,null--<UserName, nvarchar(150),>
		   )




set @i +=1;

end 



select top(1000)* from [dbo].[SearchLog]
order by [Created] desc 

rollback

