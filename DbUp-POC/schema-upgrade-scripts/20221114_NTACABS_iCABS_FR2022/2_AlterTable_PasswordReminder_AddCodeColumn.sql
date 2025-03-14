USE [cabs_production]
GO

ALTER TABLE [cabs_production].[cabs_cmo].[PasswordReminder]
ADD [PasswordResetCode] varchar(255) null
GO