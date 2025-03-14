USE [cabs_production]
GO

/****** Object:  Table [dbo].[ContingencyFod]    Script Date: 15.11.2022 12:04:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ContingencyFod](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OriginalFodStartDate] [datetime] NOT NULL,
	[OriginalFodEndDate] [datetime] NOT NULL,
	[ExtensionMonths] [int] NOT NULL,
	[CreatedBy] [nvarchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](20) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_ContingencyFods] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
