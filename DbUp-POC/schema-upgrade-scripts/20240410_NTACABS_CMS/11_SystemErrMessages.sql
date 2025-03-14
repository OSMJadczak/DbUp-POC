-- test query
SELECT * FROM [cabs_production].[cabs_cmo].[SystemMessage]
where MessageCode > 10700 and MessageCode < 10800
order by MessageCode

BEGIN TRANSACTION;
GO

use cabs_production;
go
-- its not part of CMS but this error code was missing
DECLARE @docketNumberNotAllowed int = 10700+14
IF NOT EXISTS(SELECT * FROM [cabs_production].[cabs_cmo].[SystemMessage] where MessageCode = @docketNumberNotAllowed)
BEGIN
  insert into [cabs_production].[cabs_cmo].[SystemMessage]
    (MessageCode, MessageText, lkLanguageID, CreatedOn, CreatedBy)
    values
    (@docketNumberNotAllowed, 'Field ''DocketNumber'' is not allowed', 1, GETDATE(), 'system'),
    (@docketNumberNotAllowed, 'Field ''DocketNumber'' is not allowed', 2, GETDATE(), 'system')

	PRINT CONCAT('Inserted ', @docketNumberNotAllowed ,' Message Code')
END;
GO



DECLARE @streetAddressMandatory int = 10700+15
IF NOT EXISTS(SELECT * FROM [cabs_production].[cabs_cmo].[SystemMessage] where MessageCode = @streetAddressMandatory)
BEGIN
  insert into [cabs_production].[cabs_cmo].[SystemMessage]
    (MessageCode, MessageText, lkLanguageID, CreatedOn, CreatedBy)
    values
    (@streetAddressMandatory, 'Field ''Street Address'' is mandatory', 1, GETDATE(), 'system'),
    (@streetAddressMandatory, 'Field ''Street Address'' is mandatory', 2, GETDATE(), 'system')

	PRINT CONCAT('Inserted ', @streetAddressMandatory ,' Message Code')
END;
GO

DECLARE @incidentDateNotInFuture int = 10700+16
IF NOT EXISTS(SELECT * FROM [cabs_production].[cabs_cmo].[SystemMessage] where MessageCode = @incidentDateNotInFuture)
BEGIN
  insert into [cabs_production].[cabs_cmo].[SystemMessage]
    (MessageCode, MessageText, lkLanguageID, CreatedOn, CreatedBy)
    values
    (@incidentDateNotInFuture, 'Field ''Incident date'' cannot be set to future', 1, GETDATE(), 'system'),
    (@incidentDateNotInFuture, 'Field ''Incident date'' cannot be set to future', 2, GETDATE(), 'system')

	PRINT CONCAT('Inserted ', @incidentDateNotInFuture ,' Message Code')
END;
GO

DECLARE @incidentDateIsMandatory int = 10700+17
IF NOT EXISTS(SELECT * FROM [cabs_production].[cabs_cmo].[SystemMessage] where MessageCode = @incidentDateIsMandatory)
BEGIN
  insert into [cabs_production].[cabs_cmo].[SystemMessage]
    (MessageCode, MessageText, lkLanguageID, CreatedOn, CreatedBy)
    values
    (@incidentDateIsMandatory, 'Field ''Incident date'' is mandatory', 1, GETDATE(), 'system'),
    (@incidentDateIsMandatory, 'Field ''Incident date'' is mandatory', 2, GETDATE(), 'system')
	PRINT CONCAT('Inserted ', @incidentDateIsMandatory,' Message Code')
END;
GO

COMMIT TRANSACTION
GO