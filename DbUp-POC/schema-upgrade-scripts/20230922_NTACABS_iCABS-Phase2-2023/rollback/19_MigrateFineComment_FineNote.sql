USE [cabs_production]
GO

SET IDENTITY_INSERT cabs_enf.FineNote ON;
TRUNCATE TABLE cabs_enf.FineNote
insert into cabs_enf.FineNote
(
    [Id]
    ,[NoteContent]
    ,[FineId]
    ,[CreatedBy]
    ,[CreatedDate]
)
select 
    [Id]
    ,[NoteContent]
    ,[FineId]
    ,[CreatedBy]
    ,[CreatedDate]

from cabs_enf.tmp_FineNote


SET IDENTITY_INSERT cabs_enf.FineNote OFF;

GO


drop table cabs_enf.Fines
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cabs_enf].[Fines](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Amount] [decimal](18, 0) NULL,
	[Comments] [nvarchar](500) NULL,
	[CourtDate] [datetime] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[DatePaid] [datetime] NULL,
	[DocketNumber] [nvarchar](20) NULL,
	[DriverLicenceNumber] [nvarchar](20) NULL,
	[DueForPayment] [datetime] NULL,
	[FineAreaId] [int] NULL,
	[FineCourtOutcomeId] [int] NULL,
	[FineStatusId] [int] NOT NULL,
	[FineTypeId] [int] NOT NULL,
	[IncidentDate] [datetime] NULL,
	[InfoLicenceNumber] [nvarchar](50) NULL,
	[IsPaid] [bit] NOT NULL,
	[IssueDate] [datetime] NULL,
	[IssueOfficerName] [nvarchar](128) NULL,
	[ModifiedBy] [nvarchar](256) NULL,
	[ModifiedDate] [datetime] NULL,
	[OriginalAmount] [decimal](18, 0) NULL,
	[RegistrationNumber] [nvarchar](50) NULL,
	[SummonsDate] [datetime] NULL,
	[VehicleLicenceNumber] [nvarchar](50) NULL,
	[IssueOfficerId] [uniqueidentifier] NOT NULL,
	[FineClosureTypeId] [int] NULL,
	[InfoRegistrationNumber] [nvarchar](max) NULL,
	[DriverLicenceId] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	[FineCreationType] [int] NULL,
 CONSTRAINT [PK_Fines] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [cabs_enf].[FinesHistory])
)
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Fines_DocketNumber] ON [cabs_enf].[Fines]
(
	[DocketNumber] ASC
)
WHERE ([DocketNumber] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Fines_FineAreaId] ON [cabs_enf].[Fines]
(
	[FineAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Fines_FineClosureTypeId] ON [cabs_enf].[Fines]
(
	[FineClosureTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Fines_FineCourtOutcomeId] ON [cabs_enf].[Fines]
(
	[FineCourtOutcomeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Fines_FineStatusId] ON [cabs_enf].[Fines]
(
	[FineStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [cabs_enf].[Fines] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [IssueOfficerId]
GO
ALTER TABLE [cabs_enf].[Fines] ADD  DEFAULT (dateadd(minute,(-10),getutcdate())) FOR [ValidFrom]
GO
ALTER TABLE [cabs_enf].[Fines] ADD  DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) FOR [ValidTo]
GO
ALTER TABLE [cabs_enf].[Fines]  WITH CHECK ADD  CONSTRAINT [FK_Fines_FineArea_FineAreaId] FOREIGN KEY([FineAreaId])
REFERENCES [cabs_enf].[FineArea] ([AreaId])
GO
ALTER TABLE [cabs_enf].[Fines] CHECK CONSTRAINT [FK_Fines_FineArea_FineAreaId]
GO
ALTER TABLE [cabs_enf].[Fines]  WITH CHECK ADD  CONSTRAINT [FK_Fines_FineClosureType_FineClosureTypeId] FOREIGN KEY([FineClosureTypeId])
REFERENCES [cabs_enf].[FineClosureType] ([FineClosureTypeId])
GO
ALTER TABLE [cabs_enf].[Fines] CHECK CONSTRAINT [FK_Fines_FineClosureType_FineClosureTypeId]
GO
ALTER TABLE [cabs_enf].[Fines]  WITH CHECK ADD  CONSTRAINT [FK_Fines_FineCourtOutcome_FineCourtOutcomeId] FOREIGN KEY([FineCourtOutcomeId])
REFERENCES [cabs_enf].[FineCourtOutcome] ([CourtOutcomeId])
GO
ALTER TABLE [cabs_enf].[Fines] CHECK CONSTRAINT [FK_Fines_FineCourtOutcome_FineCourtOutcomeId]
GO
ALTER TABLE [cabs_enf].[Fines]  WITH CHECK ADD  CONSTRAINT [FK_Fines_FineStatus_FineStatusId] FOREIGN KEY([FineStatusId])
REFERENCES [cabs_enf].[FineStatus] ([FineStatusId])
GO
ALTER TABLE [cabs_enf].[Fines] CHECK CONSTRAINT [FK_Fines_FineStatus_FineStatusId]
GO

SET IDENTITY_INSERT cabs_enf.Fines ON;
insert into cabs_enf.Fines
(
	[Id]
	,[Amount]
	,[Comments]
	,[CourtDate]
	,[CreatedBy]
	,[CreatedDate]
	,[DatePaid]
	,[DocketNumber]
	,[DriverLicenceNumber]
	,[DueForPayment]
	,[FineAreaId]
	,[FineCourtOutcomeId]
	,[FineStatusId]
	,[FineTypeId]
	,[IncidentDate]
	,[InfoLicenceNumber]
	,[IsPaid]
	,[IssueDate]
	,[IssueOfficerName]
	,[ModifiedBy]
	,[ModifiedDate]
	,[OriginalAmount]
	,[RegistrationNumber]
	,[SummonsDate]
	,[VehicleLicenceNumber]
	,[IssueOfficerId]
	,[FineClosureTypeId]
	,[InfoRegistrationNumber]
	,[DriverLicenceId]
	,[FineCreationType]
)
select 
	[Id]
	,[Amount]
	,[Comments]
	,[CourtDate]
	,[CreatedBy]
	,[CreatedDate]
	,[DatePaid]
	,[DocketNumber]
	,[DriverLicenceNumber]
	,[DueForPayment]
	,[FineAreaId]
	,[FineCourtOutcomeId]
	,[FineStatusId]
	,[FineTypeId]
	,[IncidentDate]
	,[InfoLicenceNumber]
	,[IsPaid]
	,[IssueDate]
	,[IssueOfficerName]
	,[ModifiedBy]
	,[ModifiedDate]
	,[OriginalAmount]
	,[RegistrationNumber]
	,[SummonsDate]
	,[VehicleLicenceNumber]
	,[IssueOfficerId]
	,[FineClosureTypeId]
	,[InfoRegistrationNumber]
	,[DriverLicenceId]
	,[FineCreationType]

from cabs_enf.tmp_Fines


SET IDENTITY_INSERT cabs_enf.Fines OFF;

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20240109150831_DeleteFineComments';
GO

GO
