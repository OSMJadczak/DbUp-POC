USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LetterRequestTypeVL_SelectAll]    Script Date: 15/12/2023 08:50:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[LetterRequestTypeVL_SelectAll]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	LetterRequestTypeId,
			LetterRequestTypeDescription,
			--FileContent,
			HasFile, 
			LetterCode,
			NumPages,
			PrintStyle,
			EnvelopeType,
			AllowedRoles,
			ModifiedBy,
			ModifiedDate,
			CreatedBy,
			CreatedDate,
			P.PrintCompanyId AS P_PrintCompanyId,
			P.PrintCompanyName AS P_PrintCompanyName,
			IntroductionEmailText
			
	FROM dbo.LetterRequestTypeVL L
	INNER JOIN dbo.PrintCompany P on P.PrintCompanyId = L.PrintCompanyId
	--14/03/2019 - mlinke - add IsActive check on letterType
	Where L.IsActive = 1
	
END
GO


