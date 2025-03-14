USE [cabs_production]
GO

/****** Object:  UserDefinedFunction [person].[udf_GenerateCCSN]    Script Date: 6/22/2023 11:47:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [person].[udf_GenerateCCSN]
(
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@CompanyName nvarchar(100)
)
RETURNS varchar(10) 
AS
BEGIN
declare @CCSN varchar(7)
declare @shortname nchar(2)

set @FirstName = ltrim(rtrim(@FirstName))
set @LastName = ltrim(rtrim(@LastName))
set @CompanyName = ltrim(rtrim(@CompanyName))


declare @tally as table (N int) 
insert into @tally select top (100) row_number() over (order by @@spid) from sys.all_columns

set @ShortName = UPPER(left(@FirstName,1) + LEFT(@LastName, 1))

if @ShortName is null --Person is Company
begin
	select @ShortName=left(upper((select C + '' from (select N, substring(@CompanyName, N, 1) C from @tally where N<=datalength(@CompanyName)) Col
		where C between 'a' and 'Z'
		order by N
		for xml path(''))), 2)
end

--If still NULL assigne default value
if @ShortName is null 
	set @ShortName = 'XX'

select 
	top 1 @CCSN = (@ShortName + right('00000' + convert(varchar(5),  convert(int, substring(ccsn, 3, 20)) + 1), 5))
from person.Person
where 
	left(CCSN,2) = @ShortName
order by ccsn desc

--If still NULL assigne first value
if @CCSN is null 
	set @CCSN = @ShortName + '00001'

/* OLD VERSION
select 
	@CCSN = (@ShortName + right('00000' + convert(varchar(4), count(*)+1), 5))
from person.Person
where 
	left(CCSN,2) = @ShortName
*/

	-- Return the result of the function
	RETURN @CCSN

END
GO


