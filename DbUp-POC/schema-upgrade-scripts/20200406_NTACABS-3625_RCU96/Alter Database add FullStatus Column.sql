begin tran 



alter table [dbo].[LICENCES_EXTRACT]
add  FullStatus nvarchar(100);

alter table LICENCES_EXTRACT_ARCHIVE
add  FullStatus nvarchar(100);

alter table LICENCES_EXTRACT_ARCHIVE_ALL
add  FullStatus nvarchar(100);

alter table [dbo].[LICENCES_EXTRACT_EOM]
add  FullStatus nvarchar(100);

alter table DWH_LICENSES_HISTORY
add  FullStatus nvarchar(100);

rollback