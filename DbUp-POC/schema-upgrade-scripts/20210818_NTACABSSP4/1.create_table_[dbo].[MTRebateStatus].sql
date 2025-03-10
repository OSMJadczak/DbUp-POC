USE [cabs_production]
GO

/****** Object:  Table [dbo].[EVGrantStatus]    Script Date: 8/18/2021 11:37:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MTRebateStatus](
	[MTRebateStatusId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_MTRebateStatus] PRIMARY KEY CLUSTERED 
(
	[MTRebateStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MTRebateStatus] ADD  DEFAULT ((1)) FOR [Active]
GO




USE [cabs_production]
GO

INSERT INTO [dbo].[MTRebateStatus]
           ([Description]
           ,[Active])
     VALUES
           ('YES'
           ,1)

		   INSERT INTO [dbo].[MTRebateStatus]
           ([Description]
           ,[Active])
     VALUES
           ('NO'
           ,1)
GO





