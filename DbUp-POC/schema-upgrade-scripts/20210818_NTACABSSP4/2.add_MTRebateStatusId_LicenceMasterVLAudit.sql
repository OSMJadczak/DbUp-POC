
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

ALTER TABLE dbo.LicenceMasterVLAudit
ADD MotorTaxRebateStatusID  int  null;

ALTER TABLE [dbo].[LicenceMasterVLAudit]  WITH CHECK ADD  CONSTRAINT [FK_LicenceMasterVLAudit_MotorTaxRebateStatus] FOREIGN KEY(MotorTaxRebateStatusID)
REFERENCES [dbo].[MTRebateStatus] ([MTRebateStatusId])
GO

ALTER TABLE dbo.LicenceMasterVLAudit
ADD MotorTaxRebateDate datetime NULL;

COMMIT
