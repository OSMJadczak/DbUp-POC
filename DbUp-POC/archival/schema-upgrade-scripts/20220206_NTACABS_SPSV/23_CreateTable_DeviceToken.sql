USE [cabs_production]
GO

/****** Object:  Table [cabs_aut].[DeviceToken]    Script Date: 29.11.2022 12:29:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [cabs_aut].[DeviceToken](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](50) NOT NULL,
	[Token] [nvarchar](128) NOT NULL,
	[CreatedUtc] [datetime] NOT NULL,
	[ValidityPeriodInMonths] [int] NOT NULL,
	[ApplicationName] [nvarchar](50) NOT NULL,
	[ApplicationVersion] [nvarchar](50) NOT NULL,
	[ClientType] [nvarchar](50) NOT NULL,
	[ClientIP] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


