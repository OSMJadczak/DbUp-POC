USE [cabs_production]
GO

ALTER TABLE dbo.LetterRequestTypeVLAudit ADD CONSTRAINT CHK_T_VarB__8MB CHECK (DATALENGTH(FileContent) <= 8388608);