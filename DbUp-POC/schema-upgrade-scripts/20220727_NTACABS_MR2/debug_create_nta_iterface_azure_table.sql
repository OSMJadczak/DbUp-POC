USE [cabs_production]
GO

/****** Object:  Table [dbo].[NTA_Interface_azure]    Script Date: 08.08.2022 13:31:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NTA_Interface_azure]') AND type in (N'U'))
DROP TABLE [dbo].[NTA_Interface_azure]
GO

CREATE TABLE [dbo].[NTA_INTERFACE_AZURE](
       [TRADER_ID] [numeric](8, 0) NOT NULL,
       [INSTRUMENT_ID] [numeric](8, 0) NOT NULL,
       [PLATE_NUMBER] [nvarchar](8) NULL,
       [TEST_DATE] [datetime2](7) NOT NULL,
       [RESULT] [nvarchar](4) NULL,
       [BOOKING_DATE] [datetime2](7) NULL,
       [SOFTWARE_IN_DATE] [nvarchar](3) NULL,
       [SEAL_SECURITY] [nchar](4) NULL,
       [ID] [int] IDENTITY(1,1) NOT NULL,
CONSTRAINT [PK_NTA_INTERFACE_AZURE] PRIMARY KEY CLUSTERED 
(
       [ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

