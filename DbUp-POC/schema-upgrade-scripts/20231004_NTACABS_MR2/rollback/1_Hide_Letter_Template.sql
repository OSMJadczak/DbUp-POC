USE [cabs_production]
GO

SET IDENTITY_INSERT LetterRequestTypeVL ON;
TRUNCATE TABLE LetterRequestTypeVL
insert into LetterRequestTypeVL
(
    [LetterRequestTypeId], [LetterRequestTypeDescription], [FileContent], [CreatedBy], [CreatedDate],
    [ModifiedBy], [ModifiedDate], [AllowedRoles], [LetterCode], [NumPages], [PrintStyle],
    [EnvelopeType], [PrintCompanyId], [IntroductionEmailText], [AllowEmail], [AllowPost], [IsActive]
)
select 
    [LetterRequestTypeId], [LetterRequestTypeDescription], [FileContent], [CreatedBy], [CreatedDate],
    [ModifiedBy], [ModifiedDate], [AllowedRoles], [LetterCode], [NumPages], [PrintStyle],
    [EnvelopeType], [PrintCompanyId], [IntroductionEmailText], [AllowEmail], [AllowPost], [IsActive]

from tmp_LetterRequestTypeVL


SET IDENTITY_INSERT LetterRequestTypeVL OFF;

GO


