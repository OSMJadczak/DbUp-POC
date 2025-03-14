USE [cabs_production]
GO

/****** Object:  View [dbo].[vw_Bookings]    Script Date: 12/23/2021 3:11:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_Bookings]
AS
(
SELECT     dbo.Booking.BookingId, dbo.Booking.TestCentreId, dbo.Booking.InspectionTimeId, dbo.Booking.TestCentreLaneId, dbo.Booking.BookingStatusId, 
                      dbo.Booking.SystemProcessId, dbo.Booking.BookingDateTime, dbo.Booking.BookingEndDateTime, dbo.Booking.LicenceNumber, dbo.Booking.RegistrationNumber, 
                      dbo.Booking.NewLicenceHolderId, dbo.SystemProcessVL.ProcessName, dbo.BookingStatus.BookingStatusName, dbo.InspectionTime.LicenceTypeId, 
                      dbo.InspectionTime.InspectionTime, dbo.InspectionProcess.Description AS InspectionProcess, dbo.Booking.CreatedBy, dbo.Booking.CreatedDate, 
                      dbo.Booking.ModifiedBy, dbo.Booking.ModifiedDate, dbo.vw_TestCentres.TestCentreName, dbo.vw_TestCentres.AddressLine1, dbo.vw_TestCentres.AddressLine2, 
                      dbo.vw_TestCentres.AddressLine3, dbo.vw_TestCentres.Town, dbo.vw_TestCentres.ContactName, dbo.vw_TestCentres.PostCode, dbo.vw_TestCentres.Eircode,
                      dbo.vw_TestCentres.ContactNumberPrimary, dbo.vw_TestCentres.ContactNumberSecondary, dbo.vw_TestCentres.Email, 
                      dbo.vw_TestCentres.RegionName, dbo.vw_TestCentres.CountyName, dbo.vw_TestCentres.CountryName, dbo.vw_TestCentres.RegionId, 
                      dbo.vw_TestCentres.CountyId, dbo.vw_TestCentres.CountryId, dbo.InspectionType.Description AS InspectionDescription, 
                      dbo.TestCentreLanes.TestCentreLaneName
FROM         dbo.Booking with (nolock) INNER JOIN
                      dbo.InspectionTime ON dbo.Booking.InspectionTimeId = dbo.InspectionTime.InspectionTimeId INNER JOIN
                      dbo.InspectionProcess ON dbo.InspectionTime.InspectionProcessId = dbo.InspectionProcess.InspectionProcessId INNER JOIN
                      dbo.InspectionType ON dbo.InspectionTime.InspectionTypeId = dbo.InspectionType.InspectionTypeId INNER JOIN
                      dbo.BookingStatus ON dbo.Booking.BookingStatusId = dbo.BookingStatus.BookingStatusId INNER JOIN
                      dbo.SystemProcessVL ON dbo.Booking.SystemProcessId = dbo.SystemProcessVL.SystemProcessId INNER JOIN
                      dbo.TestCentreLanes ON dbo.Booking.TestCentreLaneId = dbo.TestCentreLanes.TestCentreLaneId INNER JOIN
                      dbo.vw_TestCentres ON dbo.Booking.TestCentreId = dbo.vw_TestCentres.TestCentreId
)


GO


