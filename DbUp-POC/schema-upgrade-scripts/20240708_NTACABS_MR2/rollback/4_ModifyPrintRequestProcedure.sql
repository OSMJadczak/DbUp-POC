SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[USP_DWH_PrintRequestVL_Insert] 
(
    @PrintRequestId int output,
    @LicenceNumber varchar(50) = null,
    @LicenceHolderId Int = null,
    @NewLicenceHolderId int = null,
    @PreviousLicenceHolderId int = null,
    @VehicleRegistrationNumber varchar(10) = null,
    @NewVehicleRegistrationNumber varchar(10) = null,
    @PreviousVehicleRegistrationNumber varchar(10) = null,
    @BookingId int = null,
    @PaymentId int = null,
    @PrintRequestReasonId int = null,
    @LetterRequestTypeId int = null,
    @CreatedBy nvarchar(50) = null,
    @LetterDate datetime = null,
    @DespatchMethod int = null,
    @CustomFields nvarchar(MAX) = null,
	@ManualCancelConditionalOffer bit = null,
	@BookingCancellationReasonId int = null

)

AS
    
Set NoCount On;

Declare @PrintRequestMasterId Int,
        @LetterRequestTypeAuditId int,
        @ErrorMessage VarChar (Max),
        @NewHolderName nvarchar(100),
        @PreviousHolderName nvarchar(100),
        @PaymentAmount money,
        @PaymentDate datetime,
        @InspectionDate datetime,
        @InspectionProcess varchar(50),
        @InspectionType varchar(50),
        @TestCentreName varchar(50),
        @TestCentreAddress varchar(500),
        @TimeStamp datetime,
        @PrintCompanyId int,
        @BookingModifiedDate datetime,
        @TotalFeesPaid money,
        @TotalRefund money,
        @TotalIncurred money,
        --@RefundId int, -- not needed as it will be incorrect if there are multiple references
        --@PaymentReference varchar(50),-- not needed as it will be incorrect if there are multiple payments
        @BookingCancellationDate datetime,
        @BookingCancellationReason varchar(max),
		@SystemProcessId int, 
		@LicNumber varchar(50),
		@PrintRequestStatusId int = 1
DECLARE @LicenceRenewalPeriod int = (
    SELECT TOP 1 ParameterValue FROM SystemParameter where ParameterName = 'LicenceRenewalPeriod')

    SET @TimeStamp = GETDATE()
    SET @LetterDate = COALESCE(@LetterDate, @TimeStamp)
        
    --Start Validate Parameters
    if (@LicenceNumber is null)
    Begin
        Set @ErrorMessage = 'A Licence Number was not provided as part of the Print Request.'
        Raiserror (@ErrorMessage, 16, 1)
    End
    
    if (@LicenceHolderId is null)
    Begin
        Set @ErrorMessage = 'A Licence Holder was not provided as part of the Print Request.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    if (@VehicleRegistrationNumber is null)
    Begin
        Set @ErrorMessage = 'A Vehicle Registration Number was not provided as part of the Print Request.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    if (@PrintRequestReasonId is null)
    Begin
        Set @ErrorMessage = 'A Print Request Reason was not provided as part of the Print Request.'
        Raiserror (@ErrorMessage, 16, 1)
    End
    
    if (@LetterRequestTypeId is null)
    Begin
        Set @ErrorMessage = 'A Letter Request Type was not provided as part of the Print Request.'
        Raiserror (@ErrorMessage, 16, 1)
    End
    
    if (@CreatedBy is null)
    Begin
        Set @ErrorMessage = 'A username was not provided as part of the Print Request.'
        Raiserror (@ErrorMessage, 16, 1)
    End
    
    --End Validate Parameters
    
    --ensure Licence Number is valid
    If Not Exists (Select LicenceNumber From LicenceMasterVL As LMVL With (NoLock) Where LicenceNumber = @LicenceNumber)
    Begin
        Set @ErrorMessage = 'Licence Number provided (' + @LicenceNumber + ') was not found in the LicenceMasterVL table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure Licence Holder Id is valid
    If Not Exists (Select LicenceHolderId From LicenceHolderMaster As LHM With (NoLock) Where LicenceHolderId = @LicenceHolderId)
    Begin
        Set @ErrorMessage = 'Licence Holder provided (' + convert(varchar(10),@LicenceHolderId) + ') was not found in the LicenceHolder table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure Registration Number is valid
    If Not Exists (Select RegistrationNumber From VehicleMaster As VM With (NoLock) Where RegistrationNumber = @VehicleRegistrationNumber)
    Begin
        Set @ErrorMessage = 'Vehicle provided (' + @VehicleRegistrationNumber + ') was not found in the VehicleMaster table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure PrintRequestReason is valid
    If Not Exists (Select PrintRequestReasonId From PrintRequestReasonVL As PRR With (NoLock) Where PrintRequestReasonId = @PrintRequestReasonId)
    Begin
        Set @ErrorMessage = 'Print Request Reason provided (' + Convert(varchar(10),@PrintRequestReasonId) + ') was not found in the PrintRequestReason L table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure LetterRequestType is valid
    If Not Exists (Select LetterRequestTypeId From LetterRequestTypeVL As LRTVL With (NoLock) Where LetterRequestTypeId = @LetterRequestTypeId)
    Begin
        Set @ErrorMessage = 'Letter Request Type provided (' + Convert(varchar(10),@LetterRequestTypeId) + ') was not found in the Letter Request Type VL table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure LetterRequestTypeAudit is valid
    If Not Exists (Select LetterRequestTypeId From LetterRequestTypeVLAudit As Audit With (NoLock) Where LetterRequestTypeId = @LetterRequestTypeId)
    Begin
        Set @ErrorMessage = 'Letter Request Type provided (' + Convert(varchar(10),@LetterRequestTypeId) + ') was not found in the Letter Request Type VL Audit table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure New Licence Holder Id is valid if not null
    If @NewLicenceHolderId is not null and Not Exists (Select LicenceHolderId From LicenceHolderMaster As LHM With (NoLock) Where LicenceHolderId = @NewLicenceHolderId)
    Begin
        Set @ErrorMessage = 'New Licence Holder provided (' + convert(varchar(10),@NewLicenceHolderId) + ') was not found in the LicenceHolder table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure Previous Licence Holder Id is valid if not null
    If @PreviousLicenceHolderId is not null and Not Exists (Select LicenceHolderId From LicenceHolderMaster As LHM With (NoLock) Where LicenceHolderId = @PreviousLicenceHolderId)
    Begin
        Set @ErrorMessage = 'Previous Licence Holder provided (' + convert(varchar(10),@PreviousLicenceHolderId) + ') was not found in the LicenceHolder table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure New Registration Number is valid
    If @NewVehicleRegistrationNumber is not null and Not Exists (Select RegistrationNumber From VehicleMaster As VM With (NoLock) Where RegistrationNumber = @NewVehicleRegistrationNumber)
    Begin
        Set @ErrorMessage = 'New Vehicle provided (' + @NewVehicleRegistrationNumber + ') was not found in the VehicleMaster table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure Previous Registration Number is valid
    If @PreviousVehicleRegistrationNumber is not null and Not Exists (Select RegistrationNumber From VehicleMaster As VM With (NoLock) Where RegistrationNumber = @PreviousVehicleRegistrationNumber)
    Begin
        Set @ErrorMessage = 'Previous Vehicle provided (' + @PreviousVehicleRegistrationNumber + ') was not found in the VehicleMaster table.'
        Raiserror (@ErrorMessage, 16, 1)
    End
    
    --ensure Booking Id is valid
    If @BookingId is not null and Not Exists (Select BookingId From Booking As B With (NoLock) Where BookingId = @BookingId)
    Begin
        Set @ErrorMessage = 'Booking provided (' + convert(varchar(10),@BookingId) + ') was not found in the Booking table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --ensure Payment Id is valid
    If @PaymentId is not null and Not Exists (Select PaymentId From PaymentVL As P With (NoLock) Where PaymentId = @PaymentId)
    Begin
        Set @ErrorMessage = 'Payment provided (' + convert(varchar(10),@PaymentId) + ') was not found in the Payment table.'
        Raiserror (@ErrorMessage, 16, 1)
    End

    --get the letter request type audit from the table
    SELECT @LetterRequestTypeAuditId = MAX(LetterRequestTypeAuditId) FROM dbo.LetterRequestTypeVLAudit
    WHERE LetterRequestTypeId = @LetterRequestTypeId
    
    --if a new licence holder is provided, get their name from the table
    if @NewLicenceHolderId is not null
    begin
        SELECT @NewHolderName = HolderName FROM LicenceHolderMaster WHERE LicenceHolderId = @NewLicenceHolderId
    end

    --if a previous licence holder is provided, get their name from the table
    if @PreviousLicenceHolderId is not null
    begin
        SELECT @PreviousHolderName = HolderName FROM LicenceHolderMaster WHERE LicenceHolderId = @PreviousLicenceHolderId
    end
    
    --if a booking id is provided, get the booking details from the table
    if @BookingId is not null
    begin
            SELECT   @InspectionDate = BookingDateTime,
                    @BookingModifiedDate = ModifiedDate,
                    @InspectionProcess = InspectionProcess,
                    @InspectionType = InspectionDescription,
                    @TestCentreName = TestCentreName,
                    @TestCentreAddress = 
                    CASE 
					WHEN  COALESCE(PostCode, '') = '' and COALESCE(CountyName, '') != ''
                    THEN AddressLine1 + coalesce(', ' + AddressLine2, '') + coalesce(', ' + AddressLine3, '') + coalesce(', ' + Town, '') + (', ' + CountyName) 
					+ coalesce(', ' + CountryName, '') + coalesce(', ' + Eircode, '') 
					WHEN COALESCE(CountyName, '') = '' and COALESCE(PostCode, '') != ''
					THEN AddressLine1 + coalesce(', ' + AddressLine2, '') + coalesce(', ' + AddressLine3, '') + coalesce(', ' + Town, '') + (', ' + PostCode) 
					+ coalesce(', ' + CountryName, '') + coalesce(', ' + Eircode, '') 
                    ELSE AddressLine1 + coalesce(', ' + AddressLine2, '') + coalesce(', ' + AddressLine3, '') + coalesce(', ' + Town, '') + (', ' + CountyName) + (' ' + PostCode) 
					+ coalesce(', ' + CountryName, '') + coalesce(', ' + Eircode, '') 
                    END,
					@SystemProcessId = SystemProcessId,                    
					@LicNumber = LicenceNumber
            FROM dbo.vw_Bookings            
            WHERE BookingId = @BookingId
            
			declare @firstBooking int = (SELECT MIN(BookingId) FROM dbo.Booking  where LicenceNumber = @LicNumber) --if it's firs booking for the CO then there is no reference in BookingPayment table therefore you have to fetch payment from the PaymentVL table		

			---IF NewLicence2 Cancelled without inspection ,without late reschedule.
			Declare @IsNewLicence1Cancelled int = (Select TOP 1 SPV.BookingId from dbo.SystemProcessInstanceVL SPV
										  join dbo.Booking B ON SPV.BookingId=B.BookingId
											Where SPV.SystemProcessId=11 and SPV.Completed=1 and SPV.PaymentID IS NULL and SPV.BookingId=@BookingId
											AND B.BookingID not in (Select BookingID from dbo.BookingPayment Where BookingID=@BookingId));
			IF (@SystemProcessId = 11)
				BEGIN
					IF (@firstBooking = @BookingId)
					BEGIN

						SELECT  @TotalRefund = SUM(Amount) FROM [BookingRefund] br 
							inner join [dbo].[PaymentRefundVL] pvl on pvl.RefundId = br.RefundId 
						WHERE BookingId = @BookingId

						SELECT @TotalFeesPaid = SUM(PIV.Amount)
						FROM PaymentVL PVL 
							INNER JOIN PaymentItemVL PIV on PIV.PaymentId = PVL.PaymentId 
						WHERE [LicenceNumber] = @LicenceNumber
						AND (ServiceTypeId = 7 OR PVL.PaymentId IN (SELECT PaymentId from BookingPayment where BookingId = 	@BookingId)) 
						AND PIV.PaymentStatusId IN (2,3) 
						
						SET @TotalIncurred = ISNULL(@TotalFeesPaid, 0) - ISNULL(@TotalRefund, 0)						

						SELECT 
								@BookingCancellationReason = CR.BookingCancellationReason,
								@BookingCancellationDate = B.ModifiedDate
						FROM 
								Booking B								
								LEFT JOIN BookingCancellationReason CR ON CR.BookingCancellationReasonID = B.BookingCancellationReasonID
						WHERE 
								(B.BookingStatusId = 5
								OR (B.BookingStatusId=3 AND B.BookingId = (Select top 1 BookingId from dbo.VehicleInspections
																			Where BookingId = @BookingId AND TestResultId = 6 )
									)
								) AND B.BookingId = @BookingId
					END
					ELSE
					BEGIN
							-- Get cancellation details for this booking            
							SELECT 
								@BookingCancellationReason = CR.BookingCancellationReason,
								@BookingCancellationDate = B.ModifiedDate,
								--@PaymentReference = Payments.PaymentReference,
								@TotalFeesPaid = ISNULL(Payments.TotalFeesPaid, 0),
								--@RefundId = Refunds.RefundId,
								@TotalRefund = ISNULL(Refunds.TotalRefunds, 0),
								@TotalIncurred = ISNULL(Payments.TotalFeesPaid, 0) - ISNULL(Refunds.TotalRefunds, 0)
							FROM 
								Booking B
								JOIN LicenceMasterVL L ON L.LicenceNumber = B.LicenceNumber
								JOIN dbo.LicenceType T ON T.LicenceTypeID = L.LicenceTypeID
								LEFT JOIN BookingCancellationReason CR ON CR.BookingCancellationReasonID = B.BookingCancellationReasonID
								LEFT JOIN (
											SELECT 										
												B.BookingId as 'BookingId',											
												SUM(PIT.Amount) as 'TotalFeesPaid'
											FROM 
											Booking B	
											LEFT JOIN BookingPayment BP on BP.BookingId = B.BookingId																						  
											INNER JOIN dbo.PaymentVL P ON P.PaymentId = BP.PaymentId
											INNER JOIN dbo.PaymentItemVL PIT ON P.PaymentId= PIT.PaymentId  
											WHERE 
												B.BookingId = @BookingId  --AND b.ParentId=@BookingId
												AND PIT.PaymentStatusId IN (2,3)  
											Group BY
												B.BookingId
										) Payments ON Payments.BookingId = B.BookingId
								LEFT JOIN (
											SELECT  
												BookingId as 'BookingId',
												SUM(Amount) as 'TotalRefunds' 
											FROM [BookingRefund] br 
												inner join [dbo].[PaymentRefundVL] pvl on pvl.RefundId = br.RefundId 
											WHERE BookingId = @BookingId
											Group BY
												BookingId
										) Refunds ON Refunds.BookingId = B.BookingId
							WHERE 
								(B.BookingStatusId = 5
								OR (B.BookingStatusId=3 AND B.BookingId = (Select top 1 BookingId from dbo.VehicleInspections
																			Where BookingId = @BookingId AND TestResultId = 6 )
									)
								) AND B.BookingId = @BookingId
							-- ended cancellation booking information   
							IF (@TotalIncurred < 0)
							BEGIN
								SET @TotalIncurred = 0
							END
					END 
				END
			ELSE IF @IsNewLicence1Cancelled IS NOT NULL 		
				BEGIN
							 -- Get cancellation details for this booking            
					SELECT 
						@BookingCancellationReason = CR.BookingCancellationReason,
						@BookingCancellationDate = B.ModifiedDate,
						--@PaymentReference = Payments.PaymentReference,
						@TotalFeesPaid = ISNULL(Payments.TotalFeesPaid, 0),
						--@RefundId = Refunds.RefundId,
						@TotalRefund = ISNULL(Refunds.TotalRefunds, 0),
						@TotalIncurred = ISNULL(Payments.TotalFeesPaid, 0) - ISNULL(Refunds.TotalRefunds, 0)
					FROM 
						Booking B
						JOIN LicenceMasterVL L ON L.LicenceNumber = B.LicenceNumber
						JOIN dbo.LicenceType T ON T.LicenceTypeID = L.LicenceTypeID
						LEFT JOIN BookingCancellationReason CR ON CR.BookingCancellationReasonID = B.BookingCancellationReasonID
						LEFT JOIN (
									SELECT 
										SPV.LicenceNumber as LicenceNumber,
										@BookingId as 'BookingId',										
										SUM(P.Amount) as 'TotalFeesPaid'
									FROM 
										 dbo.SystemProcessInstanceVL SPV 
										 JOIN PaymentVL P ON P.PaymentId = SPV.PaymentId
									WHERE 
										 p.[PaymentReference] is not null  --Added by OSDS Reason : Should be refund only Paid amount
										AND SPV.Completed=1		
										AND SPV.LicenceNumber=@LicenceNumber				
										AND SPV.SystemProcessId = 10 
										AND P.ServiceTypeId=7	
									Group BY
											SPV.LicenceNumber																	
								) Payments ON Payments.LicenceNumber = B.LicenceNumber
						LEFT JOIN (
									SELECT 
										B.BookingId as 'BookingId',
										--MAX(R.RefundId) as 'RefundId',, -- no longer needed
										CASE 
											WHEN SUM(PIT.Amount) IS NOT NULL THEN SUM(PIT.Amount)
											ELSE SUM(R.Amount) 
											END 'TotalRefunds'
									  FROM 
										Booking B
										 LEFT JOIN BookingPayment BP ON BP.BookingId = B.BookingId   --- Added By Syed
										 LEFT JOIN dbo.PaymentItemVL PIT ON BP.PaymentId= PIT.PaymentId  
										LEFT JOIN BookingRefund BR ON BR.BookingId = B.BookingId
										LEFT JOIN PaymentRefundVL R ON R.RefundId = BR.RefundId
									WHERE 
										B.BookingId = @BookingId  
										AND (PIT.PaymentStatusId=3   OR  BR.RefundId in (Select RefundId from [dbo].[PaymentRefundItemVL] pri
																						join PaymentItemVL pitv ON pri.PaymentItemId=pitv.PaymentItemId																				
																						Where pitv.PaymentStatusId = 3
																						AND pitv.PaymentId not in (SELECT PaymentId FROM dbo.BookingPayment	
																						WHERE BookingId =@BookingId )) )
									Group BY
										B.BookingId
								) Refunds ON Refunds.BookingId = B.BookingId
					WHERE 
						(B.BookingStatusId = 5
								OR (B.BookingStatusId=3 AND B.BookingId = (Select top 1 BookingId from dbo.VehicleInspections
																			Where BookingId = @BookingId AND TestResultId = 6 )
									)
								) AND B.BookingId = @BookingId
					-- ended cancellation booking information  
				END			
			ELSE
				BEGIN
						-- Get cancellation details for this booking            
						SELECT 
							@BookingCancellationReason = CR.BookingCancellationReason,
							@BookingCancellationDate = B.ModifiedDate,
							--@PaymentReference = Payments.PaymentReference,
							@TotalFeesPaid = ISNULL(Payments.TotalFeesPaid, 0),
							--@RefundId = Refunds.RefundId,
							@TotalRefund = ISNULL(Refunds.TotalRefunds, 0),
							@TotalIncurred = ISNULL(Payments.TotalFeesPaid, 0) - ISNULL(Refunds.TotalRefunds, 0)
						FROM 
							Booking B
							JOIN LicenceMasterVL L ON L.LicenceNumber = B.LicenceNumber
							JOIN dbo.LicenceType T ON T.LicenceTypeID = L.LicenceTypeID
							LEFT JOIN BookingCancellationReason CR ON CR.BookingCancellationReasonID = B.BookingCancellationReasonID
							LEFT JOIN (
										SELECT 
											B.BookingId as 'BookingId',
											--MAX(P.PaymentReference) as 'PaymentReference', -- no longer needed could replace this with multiple if more than 1
											SUM(P.Amount) as 'TotalFeesPaid'
										FROM 
											Booking B
											LEFT JOIN BookingPayment BP ON BP.BookingId = B.BookingId
											LEFT JOIN PaymentVL P ON P.PaymentId = BP.PaymentId
										WHERE 
											B.BookingId = @BookingId  AND p.[PaymentReference] is not null  --Added by OSDS Reason : Should be refund only Paid amount
										Group BY
											B.BookingId
									) Payments ON Payments.BookingId = B.BookingId
							LEFT JOIN (
										SELECT 
											B.BookingId as 'BookingId',
											--MAX(R.RefundId) as 'RefundId',, -- no longer needed
											 SUM(PIT.Amount) as  'TotalRefunds'
										  FROM 
											Booking B
											 LEFT JOIN BookingPayment BP ON BP.BookingId = B.BookingId   --- Added By Syed
											 LEFT JOIN dbo.PaymentItemVL PIT ON BP.PaymentId= PIT.PaymentId  
											--LEFT JOIN BookingRefund BR ON BR.BookingId = B.BookingId
											--LEFT JOIN PaymentRefundVL R ON R.RefundId = BR.RefundId
										WHERE 
											B.BookingId = @BookingId  --AND b.ParentId=@BookingId
											AND PIT.PaymentStatusId=3   
										Group BY
											B.BookingId
									) Refunds ON Refunds.BookingId = B.BookingId
						WHERE 
							(B.BookingStatusId = 5
								OR (B.BookingStatusId=3 AND B.BookingId = (Select top 1 BookingId from dbo.VehicleInspections
																			Where BookingId = @BookingId AND TestResultId = 6 )
									)   ---A Booking Cancellation letter should be generated overnight, listing the fees refunded, and it should appear in the Letters tab. TestResultId= 6 =  Fail (Closed)
								) AND B.BookingId = @BookingId
						-- ended cancellation booking information   
			    END 

    end    

    
    --if a payment id is provided, get the amount from the table
    if @PaymentId is not null
    begin
        SELECT    @PaymentDate = CreatedDate
        FROM    PaymentVL 
        WHERE    PaymentId = @PaymentId
        
        SELECT    @PaymentAmount = COALESCE(SUM(Amount),0)                
        FROM    PaymentItemVL
        WHERE    PaymentId = @PaymentId
        AND PaymentStatusId IN (2,3) --Paid and refunded amounts only
    end
    
    SELECT @PrintCompanyId = PrintCompanyId 
    FROM dbo.LetterRequestTypeVL
    WHERE LetterRequestTypeId = @LetterRequestTypeId
        
	if @ManualCancelConditionalOffer is not null and @ManualCancelConditionalOffer = 1
	begin
				if @BookingCancellationReasonId is not null
				begin
					select @BookingCancellationReason = BookingCancellationReason 
					from BookingCancellationReason where BookingCancellationReasonId = @BookingCancellationReasonId
				end
				
	            EXECUTE [dbo].[RefundsForConditionalOffer_GetByLicenceNumber] 
					 @LicenceNumber =  @LicenceNumber
					,@TotalFeesPaid =  @TotalFeesPaid OUTPUT
					,@TotalRefund = @TotalRefund OUTPUT

				Begin Try
					set @TotalIncurred = @TotalFeesPaid - @TotalRefund
				End Try
				Begin Catch
					set @TotalIncurred =  0
				End Catch
                
	end


    Begin Try

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    -- IF this is a print request for a booking cancelation then make
    -- sure that a cancellation letter has not already been generated for
    -- this booking id. There may be an issue with jobs that use this procedure running simultaneously hence this check
    DECLARE @PerformInsert int
    SET @PerformInsert = 1
    
    --IF(@BookingId IS NOT NULL AND @BookingCancellationReason IS NOT NULL)
    --BEGIN
    --    IF(SELECT COUNT(1) FROM PrintRequestMasterVL WHERE BookingId = @BookingId AND BookingCancellationReason = @BookingCancellationReason) > 0
    --    BEGIN
    --        SET @PerformInsert = 0
    --    END
    --END
    
    IF (@PerformInsert = 1)
    BEGIN
        Begin Transaction CreatePrintRequest
        
            INSERT INTO [PrintRequestMasterVL] 
            (
                [LetterRequestTypeAuditId],
                [LicenceNumber],
                [LetterDate],
                [LicenceHolderId],
                [VehicleRegNumber],     
                [CreatedBy],
                [CreatedDate],
                [ModifiedBy],
                [ModifiedDate],
                [LicenceType],
                [LicenceIssueDate],
                [LicenceExpiryDate],
                [LicenceLastReactivationDate], --Expiry Date + @LicenceRenewalPeriod years
                [LicenceFirstRenewalDate], --Expiry Date - 60 days
                [LicenceLastRenewalDate], --Vehicle Registration Date + 10 years,
                [LicenceCoIssueDate],
                [LicenceCoExpiryDate],
                [LicenceDeferralExpiryDate], --Date change of vehicle occured + 30 days, ie date the letter was generated + 30 days
                [LicenceSurrenderDate], --Date licence was surrendered, ie date the letter was generated
                [LicenceTransferDate], 
                [LicenceRemainingTransfers],
                [NewLicenceHolderId],
                [PreviousLicenceHolderId],
                [HolderCCSN],
                [HolderPPSN],
                [HolderName],
                [NewHolderName],
                [PreviousHolderName],
                [HolderTitle],
                [HolderFirstName],
                [HolderLastName],
                [HolderDateOfBirth],
                [HolderCompanyNumber],
                [HolderCompanyName],
                [HolderTradingAs],
                [HolderAddressLine1],
                [HolderAddressLine2],
                [HolderAddressLine3],
                [HolderTown],
                [HolderPostCode],
                [HolderCounty],
                [HolderCountry],
                [HolderPhoneNumber1],
                [HolderPhoneNumber2],
                [HolderFaxNumber],
                [HolderEmail],
                [NewVehicleRegNumber],
                [PreviousVehicleRegNumber],
                [VehicleAgeYears],
                [VehicleAgeYearsDays],
                [VehicleAgeAtExpiryDate],
                [VehicleAgeAtExpiryYearsDays],
                [VehicleAgeAtFirstRenewalDate],
                [VehicleAgeAtFirstRenewalYearsDays],
                [VehicleAgeValid],
                [VehicleAgeValidAtExpiryDate],
                [VehicleRegistrationDate],
                [VehicleMake],
                [VehicleModel],
                [VehicleYearOfManufacture],
                [VehicleColour],
                [VehicleBody],
                [VehicleNumberDoors],
                [VehicleNumberPassengers],
                [VehicleNumberSeats],
                [BookingId],
                [BookingLastStandardDate],
                [InspectionDate],
                [InspectionProcess],
                [InspectionType],
                [TestCentreName],
                [TestCentreAddress],
                [PaymentId],
                [PaymentAmount],
                [PaymentDate],
                [BookingModifiedDate],
                [BookingCancellationReason],
                [BookingCancellationDate],
                --[PaymentReference],
                [TotalFeesPaid],
                --[RefundId],
                [TotalRefund],
                [TotalIncurred],
                [VehicleFinalOperationDate],
                [CustomFields]
        )
                SELECT
                @LetterRequestTypeAuditId,
                LicenceNumber,
                dbo.StripTime(@LetterDate),
                @LicenceHolderId,
                @VehicleRegistrationNumber,     
                @CreatedBy,
                @TimeStamp,
                @CreatedBy,
                @TimeStamp,
                LicenceType,
                dbo.StripTime(LicenceIssueDate),
                dbo.StripTime(LicenceExpiryDate),
                DATEADD(year, @LicenceRenewalPeriod, dbo.StripTime(LicenceExpiryDate)),
                DATEADD(day, -60, dbo.StripTime(LicenceExpiryDate)),
                DATEADD(year, 10, dbo.StripTime(RegistrationDate)),
                dbo.StripTime(CoIssueDate),
                dbo.StripTime(CoExpiryDate),
                dbo.StripTime(DATEADD(day, 30, @TimeStamp)),
                dbo.StripTime(@TimeStamp),
                dbo.StripTime(TransferDate),
                coalesce(RemainingTransfers, 0),
                @NewLicenceHolderId,
                @PreviousLicenceHolderId,
                CCSN,
                PPSN,
                HolderName,
                @NewHolderName,
                @PreviousHolderName,
                NULL AS 'Title',
                FirstName,
                LastName,
                dbo.StripTime(DateOfBirth),
                CompanyNumber,
                CompanyName,
                TradingAs,
                AddressLine1,
                AddressLine2,
                AddressLine3,
                Town,
                PostCode,
                CASE IrishLanguageAddress WHEN 1 THEN IrishName ELSE CountyName END,
                CountryName,
                PhoneNo1,
                PhoneNo2,
                NULL AS 'ContactNumberFax',
                Email,
                @NewVehicleRegistrationNumber,
                @PreviousVehicleRegistrationNumber,
                VehicleAge, --VehicleAgeYears
                [dbo].[ToYearsDays](RegistrationDate, @TimeStamp), --VehicleAgeYearsDays
                Convert(decimal(18,2),DATEDIFF(day, RegistrationDate, LicenceExpiryDate)) / 365, --VehicleAgeAtExpiryDate
                [dbo].[ToYearsDays](RegistrationDate, LicenceExpiryDate), --VehicleAgeAtExpiryYearsDays
                Convert(decimal(18,2),DATEDIFF(day, RegistrationDate, DATEADD(day, -60, LicenceExpiryDate))) / 365, --VehicleAgeAtFirstRenewalDate
                [dbo].[ToYearsDays](RegistrationDate, DATEADD(day, -60, LicenceExpiryDate)), --VehicleAgeAtFirstRenewalYearsDays
                case when VehicleAge < 10 then 1 else 0 end,
                case when datediff(year,[RegistrationDate],LicenceExpiryDate) < 10 then 1 else 0 end,
                dbo.StripTime(RegistrationDate),
                Make,
                Model,
                YearOfManufacture,
                Colour,
                BodyType,
                NumberDoors,
                NumberPassengers,
                NumberSeats,
                @BookingId,
                Convert(decimal(18,2),DATEADD(day, -60, dbo.StripTime(LicenceExpiryDate))) / 365,
                @InspectionDate,
                @InspectionProcess,
                @InspectionType,
                @TestCentreName,
                @TestCentreAddress,
                @PaymentId,
                @PaymentAmount,
                @PaymentDate,
                @BookingModifiedDate,
                @BookingCancellationReason,
                @BookingCancellationDate,
                --@PaymentReference,
                @TotalFeesPaid,
                --@RefundId,
                @TotalRefund,
                @TotalIncurred,
                LMVL.FinalOperationDate,
				@CustomFields

            FROM    [dbo].[vw_LicenceMasterVLDetails] LMVL, 
                    [dbo].[vw_LicenceHolderDetails] LHM, 
                    [dbo].[vw_VehicleDetails] VM

            WHERE    LMVL.LicenceNumber = @LicenceNumber
                AND    LHM.LicenceHolderId = @LicenceHolderId
                AND VM.RegistrationNumber = @VehicleRegistrationNumber

            SET @PrintRequestMasterId = SCOPE_IDENTITY()
            
            if @PrintRequestMasterId is null or @PrintRequestMasterId = 0
            begin
                Set @ErrorMessage = 'Unable to find PrintRequestMasterId after insertion.'
                Raiserror (@ErrorMessage, 16, 1)
            end
            
			-- 2	COL - CANCELLATION LETTER
			-- 3	COL - EXPIRED LETTER
			-- 5	COL - REMINDER LETTER
			-- 15	DEFERRAL LETTER
			-- 8	LRA - CONFIRMATION OF LICENCE EXPIRY
			-- 25	BOOKING CANCELLATION
            -- 61	No show letter
            -- 62	no show letter
			-- 80, 81, 82, 83, 84, 85, 86	all belong to Section 17 documents awaiting return after licence expiration
			-- 92   FPN Letter

        
			if (@LetterRequestTypeId is not null and @LetterRequestTypeId in (2,3,5,15,8,25,61,62,80,81,82,83,84,85,92))		                                 
					if (SELECT EmailOptIn from LicenceHolderMaster where LicenceHolderId = @LicenceHolderId) = 1			
							set @DespatchMethod = 3 -- 3 - EMAIL								
					ELSE						
							set @DespatchMethod = 1  -- 1 - POST		
													
		     if (SELECT DeceasedYn from LicenceHolderMaster where LicenceHolderId = @LicenceHolderId) = 1			
							set @DespatchMethod = 6 -- NOT SENT								
										
            INSERT INTO [dbo].[PrintRequestDetailVL]
                   (
                   [PrintRequestMasterId],
                   [PrintRequestStatusId],
                   [PrintRequestReasonId],
                   [PrintCompanyId],
                   [CreatedBy],
                   [CreatedDate],
                   [ModifiedBy],
                   [ModifiedDate],
                   [DespatchMethodId]
                   )
             VALUES
                   (
                   @PrintRequestMasterId,
                   @PrintRequestStatusId,
                   @PrintRequestReasonId,
                   @PrintCompanyId,
                   @CreatedBy,
                   @TimeStamp,
                   @CreatedBy,
                   @TimeStamp,
                   @DespatchMethod
                   )
                   
            SET @PrintRequestId = SCOPE_IDENTITY()

            if @PrintRequestId is null or @PrintRequestId = 0
            begin
                Set @ErrorMessage = 'Unable to find PrintRequestId after insertion.'
                Raiserror (@ErrorMessage, 16, 1)
            end   

        Commit Transaction CreatePrintRequest
    END


End Try

Begin Catch
    --Rollback the command executed
    IF @@TRANCOUNT > 0
    BEGIN    
        Rollback Transaction CreatePrintRequest
    END
    --Set the error message equal to the error thrown
    Set @ErrorMessage = Error_Message();
    
    Begin Try
        --Log the error
    
        INSERT INTO [dbo].[PrintEventLogs]
                (
                    [Date],
                    [Thread],
                    [Level],
                    [Logger],
                    [Message],
                    [Usr]
                )
        VALUES
                (
                    @TimeStamp,
                    1,
                    'ERROR',
                    'USP_DWH_PrintRequestVL_Insert',
                    @ErrorMessage,
                    'System'
                )
                
    End    Try
            
    Begin Catch
            
    --Nothing to do if the Print Event Log fails
            
    End Catch
    
    --Rethrow the error
    
    Raiserror (@ErrorMessage, 16, 1);
End Catch
               SET NOCOUNT OFF;




GO
