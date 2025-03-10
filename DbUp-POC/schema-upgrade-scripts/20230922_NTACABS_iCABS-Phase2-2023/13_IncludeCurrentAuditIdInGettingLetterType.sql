USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LetterRequestTypeVL_SelectAll]    Script Date: 10/10/2023 3:52:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[LetterRequestTypeVL_SelectAll]
AS
BEGIN
	SET NOCOUNT ON;

	WITH auditIds AS(
		SELECT LetterRequestTypeId, MAX(LetterRequestTypeAuditId) 'LetterRequestTypeAuditId'
		FROM dbo.LetterRequestTypeVLAudit
		GROUP BY LetterRequestTypeId)

	SELECT	L.LetterRequestTypeId,
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
			IntroductionEmailText,
			A.LetterRequestTypeAuditId
			
	FROM dbo.LetterRequestTypeVL L
	INNER JOIN dbo.PrintCompany P on P.PrintCompanyId = L.PrintCompanyId
	JOIN auditIds A on L.LetterRequestTypeId = A.LetterRequestTypeId
	--14/03/2019 - mlinke - add IsActive check on letterType
	--10/10/2023 - mjadczak - include current audit id
	Where L.IsActive = 1
	
END
GO


