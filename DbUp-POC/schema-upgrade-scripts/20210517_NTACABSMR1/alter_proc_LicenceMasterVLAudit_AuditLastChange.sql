USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceMasterVLAudit_AuditLastChange]    Script Date: 2021-06-16 11:38:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber varchar(20), @ModifiedDate datetime, @ModifiedBy nvarchar(20) = NULL
AS
BEGIN
  INSERT INTO LicenceMasterVLAudit (PlateNumber, LicenceNumber, LicenceHolderId, RegistrationNumber, LicenceTypeId, LicenceStateId,
  LicenceStateMasterId, LicenceExpiryDate, LicenceIssueDate, CoExpiryDate, CoIssueDate, RenewalDate, TransferedFromReg, HistoryChangeId, TestCenterId, RemainingTransfers, TransferDate, OldPlateNumber, OldLicenceAuthority,
  Ccsn, Ppsn, CompanyNumber, FirstName, LastName, DateOfBirth, CompanyName, TradingAs, AddressLine1, AddressLine2, AddressLine3, Town, CountyId, PostCode, CountryId, PhoneNo1, PhoneNo2, Email, TaxClearanceNumber,
  TaxClearanceExpiryDate, TaxClearanceStatus, TaxClearanceVisual, TaxClearanceName, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, AuditDate, LAHArea, LAHDriverLicenceNumber, SuspensionStartDate, SuspensionEndDate,
  EVGrantStatusId, EVGrantExpiryDate, WAVGrantStatusId, WAVGrantExpiryDate, AreaOfOpperations, DispatchOperatorId, EmailAddressForBooking, NumberForBookings, Website, ScrappageGrantStatusId)
    SELECT
      PlateNumber,
      L.LicenceNumber,
      L.LicenceHolderId,
      RegistrationNumber,
      LicenceTypeId,
      LicenceStateId,
      LicenceStateMasterId,
      LicenceExpiryDate,
      LicenceIssueDate,
      CoExpiryDate,
      CoIssueDate,
      RenewalDate,
      TransferedFromReg,
      HistoryChangeId,
      TestCenterId,
      RemainingTransfers,
      TransferDate,
      OldPlateNumber,
      OldLicenceAuthority,
      Ccsn,
      Ppsn,
      CompanyNumber,
      FirstName,
      LastName,
      DateOfBirth,
      CompanyName,
      TradingAs,
      AddressLine1,
      AddressLine2,
      AddressLine3,
      Town,
      CountyId,
      PostCode,
      CountryId,
      PhoneNo1,
      PhoneNo2,
      LH.Email,
      TaxClearanceNumber,
      TaxClearanceExpiryDate,
      TaxClearanceStatus,
      TaxClearanceVisual,
      TaxClearanceName,
      L.CreatedBy,
      L.CreatedDate,
      ISNULL(@ModifiedBy, L.ModifiedBy),
      L.ModifiedDate,
      @ModifiedDate,
      LAH.Area,
      LAH.DriverLicenceNumber,
      L.SuspensionStartDate,
      L.SuspensionEndDate,
      EVR.EVGrantStatusId,
      EVR.EVGrantExpiryDate,
      WR.WavGrantStatusID,
      WR.WavGrantExpiryDate,
      (SELECT
        STUFF((SELECT
          ',' + A.AreaName
        FROM dbo.WatServiceProvisionCounty W
        INNER JOIN dbo.AreaOfOperation A
          ON W.CountyId = A.AreaId
        WHERE LicenceNumberId = L.LicenceNumber
        FOR xml PATH ('')), 1, 1, ''))
      AS 'AreaOfOpperations',
      WR.DispatchOperatorId,
      WR.Email,
      WR.ContactNumberBookings,
      WR.WebSite,
	  ScrappageGrantStatusId
    FROM LicenceMasterVL AS L
    INNER JOIN LicenceHolderMaster AS LH
      ON LH.LicenceHolderId = L.LicenceHolderId
    LEFT OUTER JOIN dbo.LAHLink LAH
      ON L.LicenceNumber = LAH.VehicleLicenceNumber
    LEFT OUTER JOIN dbo.EVGrantRegister EVR
      ON EVR.LicenceNumber = L.LicenceNumber
    LEFT OUTER JOIN dbo.WatRegister WR
      ON WR.LicenceNumber = L.LicenceNumber

    WHERE L.LicenceNumber = @LicenceNumber
END
GO


