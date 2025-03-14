
--
-- Note: it's copy of 20230922_NTACABS_iCABS-Phase2-2023/14_SetMaxSize_LetterContent_Template.sql
-- 

ALTER TABLE dbo.LetterRequestTypeVLAudit ADD CONSTRAINT CHK_T_VarB__8MB CHECK (DATALENGTH(FileContent) <= 8388608);