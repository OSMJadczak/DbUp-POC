USE [cabs_production]
GO

delete from  [dbo].[LetterRequestTypeVL] where [LetterRequestTypeId] = 92
GO

delete from [dbo].[LetterRequestTypeVLAudit] WHERE LetterRequestTypeId = 92
GO
