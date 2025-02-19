USE [test];

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'People' AND type='U')

DROP TABLE People;