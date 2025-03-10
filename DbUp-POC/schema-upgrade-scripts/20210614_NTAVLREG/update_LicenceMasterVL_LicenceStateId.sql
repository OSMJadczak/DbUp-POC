
USE [cabs_production]
GO

DECLARE @ModifiedDate DATETIME = GETDATE()
DECLARE @ModifiedBy VARCHAR(255) = 'Covid-Update'
DECLARE @TimeOutStateId INT = 14
DECLARE @StartingDate DATETIME = '2019-07-16'
DECLARE @ExpiredStateId INT = 8
DECLARE @InactiveStateMasterId INT = 5
DECLARE @DatabaseFixes INT = 48

INSERT INTO LicenceMasterVLAudit (PlateNumber, LicenceNumber, LicenceHolderId, RegistrationNumber, LicenceTypeId, LicenceStateId,
  LicenceStateMasterId, LicenceExpiryDate, LicenceIssueDate, CoExpiryDate, CoIssueDate, RenewalDate, TransferedFromReg, HistoryChangeId, TestCenterId, RemainingTransfers, TransferDate, OldPlateNumber, OldLicenceAuthority,
  Ccsn, Ppsn, CompanyNumber, FirstName, LastName, DateOfBirth, CompanyName, TradingAs, AddressLine1, AddressLine2, AddressLine3, Town, CountyId, PostCode, CountryId, PhoneNo1, PhoneNo2, Email, TaxClearanceNumber,
  TaxClearanceExpiryDate, TaxClearanceStatus, TaxClearanceVisual, TaxClearanceName, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, AuditDate, LAHArea, LAHDriverLicenceNumber, SuspensionStartDate, SuspensionEndDate,
  EVGrantStatusId, EVGrantExpiryDate, WAVGrantStatusId, WAVGrantExpiryDate, AreaOfOpperations, DispatchOperatorId, EmailAddressForBooking, NumberForBookings, Website)
    SELECT
      PlateNumber,
      L.LicenceNumber,
      L.LicenceHolderId,
      RegistrationNumber,
      LicenceTypeId,
	  @ExpiredStateId,
      @InactiveStateMasterId,
      LicenceExpiryDate,
      LicenceIssueDate,
      CoExpiryDate,
      CoIssueDate,
      RenewalDate,
      TransferedFromReg,
      @DatabaseFixes,
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
      @ModifiedDate,
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
      WR.WebSite
    FROM LicenceMasterVL AS L
    INNER JOIN LicenceHolderMaster AS LH
      ON LH.LicenceHolderId = L.LicenceHolderId
    LEFT OUTER JOIN dbo.LAHLink LAH
      ON L.LicenceNumber = LAH.VehicleLicenceNumber
    LEFT OUTER JOIN dbo.EVGrantRegister EVR
      ON EVR.LicenceNumber = L.LicenceNumber
    LEFT OUTER JOIN dbo.WatRegister WR
      ON WR.LicenceNumber = L.LicenceNumber
	WHERE LicenceExpiryDate >= @StartingDate AND L.LicenceStateId = @TimeOutStateId

UPDATE [dbo].[LicenceMasterVL]
	SET	 [LicenceStateId] = @ExpiredStateId
		,[LicenceStateMasterId] = @InactiveStateMasterId
		,[HistoryChangeId] = @DatabaseFixes
		,[ModifiedBy] = @ModifiedBy
		,[ModifiedDate] = @ModifiedDate
	WHERE LicenceExpiryDate >= @StartingDate AND LicenceStateId = @TimeOutStateId

