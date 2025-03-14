USE [cabs_production]
GO

/****** Object:  Table [dbo].[DtoReminderReceiver]    Script Date: 11/13/2023 7:33:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DtoReminderReceiver](
	[VehicleLicenceNumber] [varchar](10) NOT NULL,
	[ExpirationDate] [datetime] NOT NULL,
	[SendDate] [datetime] NOT NULL,
	[LicenceHolderId] [int] NOT NULL,
 CONSTRAINT [PK_DtoReminderReceiver] PRIMARY KEY CLUSTERED 
(
	[VehicleLicenceNumber] ASC,
	[ExpirationDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


