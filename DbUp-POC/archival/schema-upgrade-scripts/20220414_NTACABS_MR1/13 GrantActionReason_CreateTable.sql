USE [Cabs_Live]
GO

/****** Object:  Table [dbo].[GrantApplicationExtension]    Script Date: 08.07.2022 08:32:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GrantActionReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GrantId] [int] NOT NULL,
	[ActionType] [varchar](50) NOT NULL,
	[Reason] [varchar](MAX) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](250) NULL,
CONSTRAINT [PK_GrantActionReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[GrantActionReason] WITH CHECK ADD CONSTRAINT [FK_GrantActionReason_GrantDetials_GrantId] FOREIGN KEY ([GrantId])
REFERENCES [dbo].[GrantDetails] ([Id])
GO

