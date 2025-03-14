IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

SET IDENTITY_INSERT [or].[Permissions] ON
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1001, 'Licence Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1002, 'Licence Issue Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1003, 'Licence Expiry Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1004, 'Licence Status')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1005, 'Number For Bookings')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1006, 'Email For Bookings')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1007, 'Website Or Bookings App')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1008, 'Area Of Operation')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1009, 'Operation Hours Start')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1010, 'Operation Hours End')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1011, 'Holder Name')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1012, 'Contact Person')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1013, 'Address Line 1')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1014, 'Address Line 2')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1015, 'Address Line 3')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1016, 'Town')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1017, 'County')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1018, 'Postcode')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1019, 'Eircode')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1020, 'Country')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1021, 'Email Address')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1022, 'Mobile Phone Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1023, 'Other Phone Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (1024, 'Advanced Search')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (2001, 'Active')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (2002, 'Inactive - Expired')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (2003, 'Inactive - Suspended')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (2004, 'Dead - Surrendered')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (2005, 'Dead - Revoked')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (2006, 'Dead - Timeout')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3001, 'Licence Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3002, 'Cert Status')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3003, 'Licence Issue Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3004, 'Licence Expiry Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3005, 'Licence Status')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3006, 'Primary Area')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3007, 'Additional Areas')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3008, 'LAH Area')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3009, 'Garda Area')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3010, 'Renewal Payment Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3011, 'Driver Photo')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3012, 'Holder Name')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3013, 'Date Of Birth')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3014, 'Address Line 1')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3015, 'Address Line 2')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3016, 'Address Line 3')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3017, 'Town')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3018, 'County')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3019, 'Postcode')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3020, 'Eircode')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3021, 'Country')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3022, 'Mobile Phone Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3023, 'Other Phone Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3024, 'Driver Link Tab')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (3025, 'Advanced Search')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (4001, 'Active')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (4002, 'Inactive - Expired')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (4003, 'Inactive - Suspended')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (4004, 'Dead - Surrendered')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (4005, 'Dead - Revoked')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (4006, 'Dead - Timed Out')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5001, 'Ppsn')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5002, 'Candidate Name')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5003, 'Date Of Birth')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5004, 'Test Centre Name')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5005, 'Test Code')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5006, 'Area')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5007, 'Test Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5008, 'Confirmation Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5009, 'Result')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5010, 'Module Name')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5011, 'Module Code')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5012, 'Module Result')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (5013, 'Score In Percentage Format')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6001, 'Licence Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6002, 'Licence Type')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6003, 'Licence Issue Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6004, 'Licence Expiry Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6005, 'Licence Status')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6006, 'Licence Suspension End Date')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6007, 'Vehicle Registration Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6008, 'Vehicle Make')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6009, 'Vehicle Model')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6010, 'Vehicle Colour')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6011, 'Holder Name')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6012, 'Date Of Birth')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6013, 'Address Line 1')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6014, 'Address Line 2')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6015, 'Address Line 3')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6016, 'Town')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6017, 'County')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6018, 'Postcode')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6019, 'Eircode')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6020, 'Country')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6021, 'Mobile Phone Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6022, 'Other Phone Number')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6023, 'Driver Link Tab')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6024, 'Vehicle Rentals Tab')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (6025, 'Advanced Search')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7001, 'Active')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7002, 'Inactive - Expired')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7003, 'Inactive - Suspended')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7004, 'Inactive - Deferred')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7005, 'Inactive - Conditional offer')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7006, 'Inactive - Probate')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7007, 'Dead - Surrendered')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7008, 'Dead - Revoked')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7009, 'Dead - Timed Out')
GO

INSERT INTO [or].[Permissions] ([Id], [Name]) VALUES (7010, 'Dead - Conditional Offer')
GO

SET IDENTITY_INSERT [or].[Permissions] OFF
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230413133852_InsertPermissions', N'6.0.15');
GO

COMMIT;
GO