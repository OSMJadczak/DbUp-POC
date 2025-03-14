USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_DriverName_Select]    Script Date: 5/14/2020 3:56:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
=============================================
-- Author:		Conor McNally
-- Create date: 17-Dec-2009
-- Description:	

Exec USP_DWH_DriverName_Select 'ohn bar'

=============================================
*/
ALTER PROCEDURE [dbo].[USP_DWH_DriverName_Select]
	-- Add the parameters for the stored procedure here
	@DriverName NVarChar (150) = '' 

As

BEGIN

If IsNull(@DriverName, '') = ''
		Set @DriverName = '%'
		

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

if exists (SELECT 1 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' 
    AND TABLE_NAME='temp_driver') 
	DROP TABLE temp_driver

CREATE TABLE temp_driver
(
	Licence varchar(20),
	Full_Name varchar(150),
	Date_Of_Birth varchar(20),
	Address_1 Varchar(100),
	Address_2 Varchar(100),
	Town Varchar(50),
	County Varchar(50)
)
insert into temp_driver (Licence, Full_Name, Date_Of_Birth, Address_1, Address_2, Town, County)
(select licnum, fname + ' ' + sname, dob,add1,add2,add3,add4 from DWH_DriverMaster)


update temp_driver
set Full_Name = replace (Full_Name,'Á','A')
update temp_driver
set Full_Name = replace (Full_Name,'É','E')
update temp_driver
set Full_Name = replace (Full_Name,'Í','I')
update temp_driver
set Full_Name = replace (Full_Name,'Ó','O')
update temp_driver
set Full_Name = replace (Full_Name,'Ú','U')
update temp_driver
set Full_Name = replace (Full_Name,'''','')

update temp_driver
set Full_Name = replace (Full_Name,' ','')

set @DriverName = replace(replace(@DriverName, ' ',''),'''','')


Select Top 1000 
*
From 
	temp_driver
where 
IsNull(Full_Name, '') Like '%'+@DriverName+'%'
--FREETEXT (Full_Name, @DriverName )
	
DROP TABLE temp_driver

END

GO


