USE [cabs_live]
GO

/****** Object:  Table [dbo].[GrantProposedVehicleType]    Script Date: 31.05.2022 10:12:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GrantProposedVehicleType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[CreatedBy] [varchar](256) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [varchar](256) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_GrantProposedVehicleType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[GrantDetails] ADD ProposedVehicleTypeId INT NOT NULL
GO

ALTER TABLE [dbo].[GrantDetails]
ADD CONSTRAINT FK_GrantDetails_GrantProposedVehicleType FOREIGN KEY (ProposedVehicleTypeId)
    REFERENCES [dbo].[GrantProposedVehicleType](Id)
GO
