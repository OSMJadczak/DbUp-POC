SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ReportsVL_SelectByReportId]

	@ReportId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ReportId,ReportName,ReportPath,AllowedRoles
	
	FROM dbo.ReportsVL
	
	WHERE ReportId = @ReportId
END
GO
