USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[DispatchOperatorMaster_SelectAll]    Script Date: 7/2/2020 10:48:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DispatchOperatorMaster_SelectAll]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT LicenceHolderId,CompanyOwnerName,VatNumber,
			Website,CreatedBy,CreatedDate,
			ModifiedBy,ModifiedDate
	FROM dbo.DispatchOperatorMaster
	WHERE CompanyOwnerName <> 'DO Company' -- I know that it looks bad, but rpodgorski forced me to do it (this functionality will be rewritten soon).
END
GO


