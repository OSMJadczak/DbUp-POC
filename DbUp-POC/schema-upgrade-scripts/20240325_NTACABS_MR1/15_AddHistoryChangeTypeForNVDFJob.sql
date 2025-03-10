USE [cabs_production]
GO

set IDENTITY_INSERT dbo.HistoryChangeType ON
insert into dbo.HistoryChangeType (HistoryChangeID, HistoryChangeType) values (66, 'NVDF Job Update')
set IDENTITY_INSERT dbo.HistoryChangeType OFF