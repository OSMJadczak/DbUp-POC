USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[EVGrantStatus_SelectAll]    Script Date: 8/18/2021 11:54:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or ALTER PROCEDURE [dbo].[MTRebateStatus_SelectAll]
AS
BEGIN

	SET NOCOUNT ON;
	SELECT [MTRebateStatusId], [Description], [Active]
	FROM [cabs_production].[dbo].[MTRebateStatus]
END
