USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[sch_logCheck_ORCheckSearchElement]    Script Date: 01/12/2020 11:58:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Adam Nosal
-- =============================================
create or ALTER         PROCEDURE [dbo].[sch_logCheck_ORCheckSearchElement] 
(
       @SearchId int ,
	   @SearchTerm int ,
       @SearchDate datetime ,
	   @ProcedureNesting int --,
	   --@SearchContinuityReturn int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;

	declare @SearchIdBorder int =5;
	declare @SearchIncrement int =1;
	declare @searchIncrementMinutes int =4;
	declare @procedureNextingMax int =8;
	declare @borderLogCapacity int =50;
	declare @ORCount int =(select Count(*) from [cabs_dck].[JobSearchOnlineRegisterLog] ) ;
	
	declare @newSearchId int = @searchId;

	 if(@ORCount> @borderLogCapacity)
	 return;


	while (@SearchIncrement <= @SearchIdBorder )
		begin 

			declare @searchTerm1 int,@searchDate1 datetime ;
			--select next one from table 
			set @newSearchId = (select top(1)SearchId from cabs_dck.JobSearchOnlineRegisterTempTable  where SearchId > @newSearchId  order by SearchId   );
							
			set  @searchTerm1 = (select top(1) SearchTerm  from cabs_dck.JobSearchOnlineRegisterTempTable  where SearchId = @newSearchId  );
				If(@searchTerm1 is null )
				begin 
				-- if there is nothing to search 
				break;
				end ; 

			--	get next in order 
			set @searchDate1  = (select top(1) SearchDate from cabs_dck.JobSearchOnlineRegisterTempTable  where SearchId = @newSearchId );
				
				 IF (
				  (@searchTerm1  > @SearchTerm)
				 and( @searchDate1 < dateadd(minute,@searchIncrementMinutes, @searchdate))
				 and  (@ProcedureNesting < @procedureNextingMax)
				 )
				  begin 
						
							declare @searchTermT int, @searchDateT datetime, @SearchContinuityTReturn int ;
							set  @searchTermT =@searchTerm1;
							set  @searchDateT = @searchDate1;
			
							
							 declare @searchCount int  = (select Count(*) from [cabs_dck].[JobSearchOnlineRegisterLog] where SearchId = @SearchId);
							 declare @newSearchCount int  = (select Count(*) from [cabs_dck].[JobSearchOnlineRegisterLog] where SearchId = @newSearchId);
							 -- if there is already search like that in log table, do not insert
								If (@searchCount < 1)
								begin 
										 INSERT INTO [cabs_dck].[JobSearchOnlineRegisterLog]
													([SearchId]
													,[SearchTerm]
													,[SearchDate])
												VALUES
													(
													@SearchId,--SearchId 
													@searchTerm,--<SearchTerm, nvarchar(100),>
													@SearchDate--<SearchDate, datetime2(7),>
													)
								end;
								If (@newSearchCount < 1)
								begin 
										 INSERT INTO [cabs_dck].[JobSearchOnlineRegisterLog]
													([SearchId]
													,[SearchTerm]
													,[SearchDate])
												VALUES
													(
													@newSearchId,--SearchId 
													@searchTermT,--<SearchTerm, nvarchar(100),>
													@SearchDateT--<SearchDate, datetime2(7),>
													)
								end;
							Set @ProcedureNesting = @ProcedureNesting +1; 
							execute [dbo].[sch_logCheck_ORCheckSearchElement] 
						 	@SearchId= @newSearchId,
							@SearchTerm=@SearchTermT, 
							@SearchDate=@SearchDateT,
							@ProcedureNesting = @ProcedureNesting ;

							Set @ProcedureNesting = @ProcedureNesting -1; 
						
				 end ;
				 else 
				 begin 
				 --if there is no sequential 
				 set @SearchIncrement = @SearchIncrement+1;
				 continue;
				 end 
			set @SearchIncrement = @SearchIncrement+1;
		
		end
	
end