USE [Cabs_Live]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Vinicius Apolinario>
-- Create date: <05/12/2022>
-- Description:	<Creating new tables for Grant>
-- Modified by:	<Thiago Anuszkiewicz>
-- Modify Date: <06/12/2022>
-- =============================================

CREATE TABLE [dbo].[GrantStatusType](
   Id INT IDENTITY(1,1) NOT NULL,
   Type             VARCHAR(50) NOT NULL,
   IsActive         BIT NOT NULL,
   PRIMARY KEY (Id)
);
GO

CREATE TABLE [dbo].[GrantStatus](
   Id INT IDENTITY(1,1) NOT NULL,
   StatusId INT FOREIGN KEY REFERENCES GrantStatusType(Id),
   CreatedOn            DATE NOT NULL,
   ReferenceNumberId      INT NOT NULL,
   CreatedBy            VARCHAR(50) NOT NULL,
   PRIMARY KEY (Id)
);
GO

CREATE TABLE [dbo].[GrantProposedVehicleAge](
	[GrantProposedAgeId] [int] NOT NULL,
	[GrantProposedAgeName] [varchar](50) NOT NULL,
	[GrantProposedAgeValue] [money] NOT NULL,
	[GrantType] [varchar](12) NOT NULL,
	PRIMARY KEY ([GrantProposedAgeId])
);
GO

CREATE TABLE [dbo].[GrantLimit] (
    Id int IDENTITY(1,1) NOT NULL,
    Year int  NOT NULL,
    LimitAmount float  NOT NULL,
    CreatedDate datetime  NOT NULL,
    CreatedBy nvarchar(256)  NOT NULL,
    ModifiedBy nvarchar(256) NULL,
    ModifiedDate datetime NULL,
    LimitStatus BIT NOT NULL,
    GrantType varchar(12) NOT NULL,
    PRIMARY KEY (Id)
);
GO

CREATE TABLE [dbo].[GrantLicenceCategory](
   Id INT IDENTITY(1,1) NOT NULL,					
   GrantLicenceCategoryName VARCHAR(50) NOT NULL,
   GrantTypeID            VARCHAR(12) NOT NULL,
   CreatedBy            VARCHAR(256) NOT NULL,
   CreatedDate datetime  NOT NULL,
   ModifiedBy nvarchar(256) NULL,
   ModifiedDate datetime NULL,
   PRIMARY KEY (Id)
);
GO

CREATE TABLE [dbo].[GrantDetails](
   Id INT IDENTITY(1,1) NOT NULL,					
   CreatedOn            DATE NOT NULL,
   GrantType            VARCHAR(12) NOT NULL,
   GrantAmount          MONEY NULL,
   CaseReferenceNumber      INT NOT NULL,
   CreatedBy            VARCHAR(256) NOT NULL,
   StatusId INT FOREIGN KEY REFERENCES GrantStatusType(Id),
   GrantExpiryDate      DATE NULL,
   LicenceCategoryId INT FOREIGN KEY REFERENCES GrantLicenceCategory(Id),
   VehicleLicence                      VARCHAR(20) NULL,
   DriverLicence                       VARCHAR(20) NULL,
   VehicleRegistrationNumber           INT NULL,
   AgeOfProposedVehicleId INT FOREIGN KEY REFERENCES GrantProposedVehicleAge(GrantProposedAgeId),
   DisabilityAwarenessTrainingForSpsvs BIT NULL,
   PRIMARY KEY (Id)
);
GO

CREATE TABLE [dbo].[GrantApplicationExtension](
	[Id] INT IDENTITY(1,1) NOT NULL,
	[CaseReferenceNumber] [varchar](50) NOT NULL,
	[ExtensionReason] [varchar](500) NOT NULL,
   PRIMARY KEY (Id)
)
GO

CREATE TABLE [dbo].[GrantApplicationRejection](
	[Id] INT IDENTITY(1,1) NOT NULL,
	[CaseReferenceNumber] [int] NOT NULL,
	[RejectionReason] [varchar](500) NOT NULL,
   PRIMARY KEY (Id)
)
GO

CREATE TABLE [dbo].[GrantApplicationWithdraw](
	[Id] INT IDENTITY(1,1) NOT NULL,
	[CaseReferenceNumber] [int] NOT NULL,
	[WithdrawReason] [varchar](500) NOT NULL,
   PRIMARY KEY (Id)
)
GO