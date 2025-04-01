begin transaction 

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

begin transaction 
ALTER TABLE dbo.licencemasterVL
ADD MotorTaxRebateStatusID int  null;

ALTER TABLE [dbo].[LicenceMasterVL]  WITH CHECK ADD  CONSTRAINT [FK_LicenceMasterVL_MotorTaxRebateStatus] FOREIGN KEY(MotorTaxRebateStatusID)
REFERENCES [dbo].[MTRebateStatus] ([MTRebateStatusId])
GO

ALTER TABLE dbo.licencemasterVL
ADD MotorTaxRebateDate datetime NULL;



Commit
