USE [cabs_production]
GO

delete from  [dbo].[LetterRequestTypeVL] where [LetterRequestTypeId] = 93
GO

delete from [dbo].[LetterRequestTypeVLAudit] WHERE LetterRequestTypeId = 93
GO
