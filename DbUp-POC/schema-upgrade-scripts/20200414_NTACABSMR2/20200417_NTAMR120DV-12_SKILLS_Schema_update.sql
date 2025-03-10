USE [cabs_production]
GO

begin tran
  ALTER TABLE [cabs_production].[cabs_cmo].[Person]
  DROP COLUMN TextOptIn

  ALTER TABLE [cabs_production].[cabs_cmo].[PersonAudit]
  DROP COLUMN TextOptIn

commit TRAN