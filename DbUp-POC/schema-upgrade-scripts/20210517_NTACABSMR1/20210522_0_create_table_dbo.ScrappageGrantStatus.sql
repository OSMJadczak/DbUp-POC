USE [cabs_production]
GO

/****** Object:  Table [dbo].[ScrappageGrantStatuses]    Script Date: 2021-05-17 15:09:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ScrappageGrantStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](30) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_ScrappageGrantStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO dbo.ScrappageGrantStatuses(Description, Active)
VALUES ('YES', 1), ('NO', 1)

