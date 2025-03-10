USE [Cabs_Live]
GO

/****** Object:  Table [dbo].[GrantFiles]    Script Date: 2022-06-08 12:42:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GrantFiles](
	[GrantId] [int] NOT NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_dbo.GrantFiles] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Files](
	[FileId] [uniqueidentifier] NOT NULL,
	[RealFileName] [nvarchar](255) NOT NULL,
	[SavedFileName] [nvarchar](255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_dbo.Files] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[GrantFiles]
ADD CONSTRAINT FK_GrantFiles_GrantDetails_GrantId FOREIGN KEY (GrantId)
    REFERENCES [dbo].[GrantDetails](Id)
GO

ALTER TABLE [dbo].[GrantFiles]
ADD CONSTRAINT FK_GrantFiles_Files_FileId FOREIGN KEY (FileId)
    REFERENCES [dbo].[Files](FileId)
GO
