BEGIN TRANSACTION;
GO

IF ((SELECT COUNT(*) FROM dbo.LetterRequestTypeVL WHERE LetterRequestTypeDescription like 'LICENCE HOLDER NON TAX COMPLIANT FOR 30 DAYS') = 1) 
     update dbo.LetterRequestTypeVL set IsActive = 0 WHERE LetterRequestTypeDescription like 'LICENCE HOLDER NON TAX COMPLIANT FOR 30 DAYS'
ELSE
    THROW 51000, 'The template with the description "LICENCE HOLDER NON TAX COMPLIANT FOR 30 DAYS" was found 0 or more than 1 times', 1;
COMMIT;
GO