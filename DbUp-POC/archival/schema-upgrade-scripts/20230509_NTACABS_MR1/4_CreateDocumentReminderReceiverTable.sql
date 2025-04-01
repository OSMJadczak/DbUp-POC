USE [cabs_production]
GO

/****** Object:  Table [dbo].[DocumentReturnReminderReceiver]    Script Date: 5/23/2023 6:12:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocumentReturnReminderReceiver](
	[LicenceNumber] [varchar](15) NOT NULL,
	[StoredDocumentType] [int] NOT NULL,
	[FirstNotificationSendingDate] [datetime] NULL,
	[SecondNotificationSendingDate] [datetime] NULL
) ON [PRIMARY]
GO