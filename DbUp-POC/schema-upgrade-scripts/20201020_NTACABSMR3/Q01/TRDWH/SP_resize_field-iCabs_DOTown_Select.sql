USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[iCabs_DOTown_Select]    Script Date: 5/14/2020 2:55:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
=============================================
-- Author:		Dan Rusu
-- Create date: 18-Apr-2011
-- Description:	
=============================================
*/
ALTER PROCEDURE [dbo].[iCabs_DOTown_Select]
	-- Add the parameters for the stored procedure here
	@doTown NVarChar (150) = '' 

As

Begin

Set NoCount On;

If IsNull(@doTown, '') = ''
		Set @doTown = '%'
		
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

Create Table #temp_do
(
	Licence varchar(20),
	Name varchar(150),
	Address1 Varchar(100),
	Address2 Varchar(100),
	Town Varchar(50),
	County Varchar(50)
)

Insert Into #temp_do (Licence, Name, Address1, Address2, Town, County)
(Select LicenceNumber, CompanyName, CompanyAddress1, CompanyAddress2, CompanyAddress3, County 
From dbo.DispatchOperator Where LicenceStatus In ('AutoApproved')--, 'Incomplete', 'Pending', 'Rejected') 
And CompanyAddress3 Like '%' + @doTown + '%')

Set NoCount Off;

Select 
	*
From 
	#temp_do

End
GO


