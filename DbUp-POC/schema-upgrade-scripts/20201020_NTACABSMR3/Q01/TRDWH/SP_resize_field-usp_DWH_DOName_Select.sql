USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[usp_DWH_DOName_Select]    Script Date: 5/14/2020 3:11:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
=============================================
-- Author:		Conor McNally
-- Create date: 17-Dec-2009
-- Description:	

Exec usp_DWH_DOName_Select 'ohn bar'

=============================================
*/
ALTER PROCEDURE [dbo].[usp_DWH_DOName_Select]
	-- Add the parameters for the stored procedure here
	@DOName NVarChar (150) = '' 

As

Begin

Set NoCount On;

If IsNull(@DOName, '') = ''
		Set @DOName = '%'
		
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

Create Table #temp_driver
(
	Licence varchar(20),
	Name varchar(150),
	Address1 Varchar(100),
	Address2 Varchar(100),
	Town Varchar(50),
	County Varchar(50)
)

Insert Into #temp_driver (Licence, Name, Address1, Address2, Town, County)
(Select LicenceNumber, CompanyName, CompanyAddress1, CompanyAddress2, CompanyAddress3, County From dbo.DispatchOperator Where LicenceStatus In ('AutoApproved')--, 'Incomplete', 'Pending', 'Rejected') 
And CompanyName Like '%' + @DOName + '%')

Set NoCount Off;

Select 
	*
From 
	#temp_driver

End
GO


