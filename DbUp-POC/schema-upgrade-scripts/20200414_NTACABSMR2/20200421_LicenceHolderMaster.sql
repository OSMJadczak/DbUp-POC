USE [cabs_production]
GO

/****** Object:  Index [_dta_index_LicenceHolderMaster_35_133679624__K1_K18_K5_2_6_7_9_10_11]    Script Date: 4/21/2020 3:50:22 PM ******/
DROP INDEX [_dta_index_LicenceHolderMaster_35_133679624__K1_K18_K5_2_6_7_9_10_11] ON [dbo].[LicenceHolderMaster]
GO

DROP STATISTICS [dbo].[LicenceHolderMaster].[_dta_stat_133679624_5_1]
DROP STATISTICS [dbo].[LicenceHolderMaster].[_dta_stat_133679624_18_1_5]
DROP STATISTICS [dbo].[LicenceHolderMaster].[_dta_stat_133679624_18_5_16]
DROP STATISTICS [dbo].[LicenceHolderMaster].[_dta_stat_133679624_5_1_16_18]
DROP STATISTICS [dbo].[LicenceHolderMaster].[_dta_stat_133679624_5_3_18_16]

GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [_dta_index_LicenceHolderMaster_35_133679624__K1_K18_K5_2_6_7_9_10_11]    Script Date: 4/21/2020 3:50:22 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_LicenceHolderMaster_35_133679624__K1_K18_K5_2_6_7_9_10_11] ON [dbo].[LicenceHolderMaster]
(
	[LicenceHolderId] ASC,
	[CountryId] ASC
)
INCLUDE ( 	[Ccsn],
	[FirstName],
	[LastName],
	[CompanyNumber],
	[CompanyName],
	[TradingAs]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]



ALTER TABLE [cabs_production].[dbo].[LicenceHolderMaster]
DROP CONSTRAINT FK_LicenceHolderMaster_Title,
COLUMN [TextOptIn], [ContactNumberFax],[TitleId];

GO