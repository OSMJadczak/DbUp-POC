USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[Booking_CancelAndRefund]    Script Date: 16.04.2020 11:09:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:        Damien Dennehy
-- Create date: 08-Apr-2011
-- Description:   Refund a booking and payment
-- Change 13/07/12 VMcC: Only refund ISI for booking cancellations, no longer conditional expirations
-- =============================================
ALTER PROCEDURE [dbo].[Booking_CancelAndRefund]
@BookingId INT, @LicenceNumber VARCHAR (20)=NULL, @RefundId INT OUTPUT, @RefundReasonId INT, 
@BookingCancellationReasonId INT, @Username NVARCHAR (50), @ProcessExpiration BIT,
@ManualCancelConditionalOffer BIT = null
AS
BEGIN
    SET NOCOUNT OFF;
    -----------------------------
    -----------------------------
    -------Declarations----------
    -----------------------------
    -----------------------------
    DECLARE @ParentId AS INT, 
@Amount AS SMALLMONEY, 
@LicenceHolderId AS INT, 
@RegNumber AS VARCHAR (10), 
@LicenceStateId AS INT, 
@LicenceTypeId AS INT, 
@PaymentItemId AS INT, 
@ErrorMessage AS VARCHAR (4000), 
@ModifiedDate AS DATETIME, 
@RequestId AS INT, 
@LetterRequestTypeId AS INT, 
@HistoryChangeId AS INT;
    DECLARE @BookingIds TABLE (
        BookingId    INT,
        TestResultId INT NULL);
    DECLARE @PaymentItemIds TABLE (
        PaymentItemId INT);
    SET @ModifiedDate = GETDATE();
    -----------------------------
    -----------------------------
    ------Set Parameters---------
    -----------------------------
    -----------------------------
    IF (@LicenceNumber IS NOT NULL)
        BEGIN
            SELECT @LicenceHolderId = L.LicenceHolderId,
                   @RegNumber = L.RegistrationNumber,
                   @LicenceStateId = L.LicenceStateId,
                   @LicenceTypeId = L.LicenceTypeId
            FROM   dbo.LicenceMasterVL AS L
            WHERE  LicenceNumber = @LicenceNumber;
        END
    IF (@BookingId IS NOT NULL)
        BEGIN
            --Set basic parameters
            --If no parent id found, default to the current booking id
            SELECT @ParentId = COALESCE (B.ParentId, @BookingId),
                   @LicenceNumber = B.LicenceNumber,
                   @LicenceHolderId = L.LicenceHolderId,
                   @RegNumber = L.RegistrationNumber,
                   @LicenceStateId = L.LicenceStateId,
                   @LicenceTypeId = L.LicenceTypeId
            FROM   Booking AS B
                   INNER JOIN
                   LicenceMasterVL AS L
                   ON L.LicenceNumber = B.LicenceNumber
            WHERE  BookingId = @BookingId;
        END
    --Get all refundable bookings based on the payment id
    INSERT INTO @BookingIds (BookingId, TestResultId)
    SELECT Booking.BookingId,
           TestResultId
    FROM   dbo.Booking
           LEFT OUTER JOIN
           dbo.VehicleInspections AS VI
           ON VI.BookingId = Booking.BookingId
    WHERE  ParentId = @ParentId
           AND BookingStatusId IN (1, 2, 3); --Awaiting PaymentConfirmedCompleted
    --Check if any refundable bookings actually have passed tests
    --If so, stop as none of the bookings in the parent tree will be refundable
    IF EXISTS (SELECT BookingId
               FROM   @BookingIds
               WHERE  TestResultId = 1)
        BEGIN
            RETURN;
        END
    -----------------------------
    -----------------------------
    --------Get Payments---------
    -----------------------------
    -----------------------------
    IF (SELECT count(BookingId)
        FROM   @BookingIds) = 1
        BEGIN
            INSERT INTO @PaymentItemIds (PaymentItemId)
            SELECT PaymentItemId
            FROM   dbo.PaymentItemVL
            WHERE  PaymentStatusId = 2 --Only paid payments can be refunded
                   AND PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                     FROM   dbo.BookingPayment
                                     WHERE  BookingId = (SELECT max(BookingId)
                                                         FROM   @BookingIds))
                   AND FeeId IN (SELECT FeeId --Only fee types related to current bookings and reason
                                 FROM   dbo.PaymentItemVLRefundableFee
                                 WHERE  RefundReasonId = @RefundReasonId);
            
			--LRA Renewal added for Section15 COV, Late S15  COV & LAH COV, LAH Late COV
			IF (EXISTS (SELECT *
                        FROM   dbo.Booking
                        WHERE  BookingId = (SELECT MAX(BookingId)
                                            FROM   @BookingIds)
                               AND (SystemProcessId=21 OR SystemProcessId=24 OR (@LicenceTypeId = 7 AND (SystemProcessId=7 OR SystemProcessId=13)) ))
                AND @RefundReasonId <> 3)
                BEGIN
                    INSERT INTO @PaymentItemIds (PaymentItemId)
                    SELECT PaymentItemId
                    FROM   dbo.PaymentItemVL
                    WHERE  PaymentStatusId = 2 --Only paid payments can be refunded
                           AND PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                             FROM   dbo.BookingPayment
                                             WHERE  BookingId = (SELECT MAX(BookingId)
                                                                 FROM   @BookingIds))
                           AND FeeId IN (2); --Only fee types related to current bookings and section 15 transfer+COV-Renewal - LRA
                END
        END
    ELSE
        BEGIN
            --Get Payment Item Ids that are refundable for the current booking
            INSERT INTO @PaymentItemIds (PaymentItemId)
            SELECT PaymentItemId
            FROM   dbo.PaymentItemVL
            WHERE  PaymentStatusId = 2 --Only paid payments can be refunded
                   AND PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                     FROM   dbo.BookingPayment
                                     WHERE  BookingId = (SELECT max(BookingId)
                                                         FROM   @BookingIds))
                   AND FeeId IN (SELECT FeeId --Only fee types related to current bookings and reason
                                 FROM   dbo.PaymentItemVLRefundableFee
                                 WHERE  RefundReasonId = @RefundReasonId
                                        AND RefundCurrentBookingOnly = 1);
            
			--LRA Renewal added for Section15 COV, Late S15  COV & LAH COV, LAH Late COV
			IF (EXISTS (SELECT *
                        FROM   dbo.Booking
                        WHERE  BookingId = (SELECT MAX(BookingId)
                                            FROM   @BookingIds)
                               AND (SystemProcessId=21 OR SystemProcessId=24 OR (@LicenceTypeId = 7 AND (SystemProcessId=7 OR SystemProcessId=13)) )
                               AND @RefundReasonId <> 3))
                BEGIN
                    INSERT INTO @PaymentItemIds (PaymentItemId)
                    SELECT PaymentItemId
                    FROM   dbo.PaymentItemVL
                    WHERE  PaymentStatusId = 2 --Only paid payments can be refunded
                           AND PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                             FROM   dbo.BookingPayment
                                             WHERE  BookingId = (SELECT MAX(BookingId)
                                                                 FROM   @BookingIds))
                           AND FeeId IN (2); --Only fee types related to current bookings and section 15 transfer+COV-Renewal - LRA
                END
            --Get Payment Item Ids that are refundable for the previous booking
            INSERT INTO @PaymentItemIds (PaymentItemId)
            SELECT PaymentItemId
            FROM   dbo.PaymentItemVL
            WHERE  PaymentStatusId = 2 --Only paid payments can be refunded
                   AND PaymentId IN (SELECT PaymentId --Only payments related to previous booking and reason
                                     FROM   dbo.BookingPayment
                                     WHERE  BookingId IN (SELECT BookingId
                                                          FROM   @BookingIds
                                                          WHERE  BookingId <> (SELECT max(BookingId)
                                                                               FROM   @BookingIds)))
                   AND FeeId IN (SELECT FeeId
                                 FROM   dbo.PaymentItemVLRefundableFee
                                 WHERE  RefundReasonId = @RefundReasonId
                                        AND RefundCurrentBookingOnly <> 1);
        END
    --Get Payment Item Ids that are refundable for conditional offers
    --NO LAH, REFUND REASON DIFFERENT THAN FAILED ISI
    IF (@LicenceStateId = 10
        AND @LicenceTypeId != 7)  -- Conditional Offer --  LAH conditonal offers are not refunded for either (1) early cancellations (2) late cancellations 
        --AND @RefundReasonId <> 6) -- Committed On 17/08/2016
        BEGIN
            --Add the new licence fee
            --If No Show job so No refund for COL Booking
            --No Show
            --No fees are refunded 
				IF @RefundReasonId NOT IN (3) ---RefundReasonId=3 NoShow
                BEGIN
                    DECLARE @COExpiryDate AS DATE = (SELECT COExpiryDate
                                                     FROM   dbo.LicenceMasterVL
                                                     WHERE  LicenceNumber = @LicenceNumber);
                    DECLARE @NoShowBooking AS INT = (SELECT   TOP 1 b.BookingId
                                                     FROM     dbo.Booking AS b
                                                     WHERE    b.LicenceNumber = @LicenceNumber
                                                              AND BookingStatusId = 5
                                                              AND b.ModifiedBy = 'NOSHOW Job'
                                                              AND b.BookingDateTime BETWEEN DATEADD(DAY, -90, @COExpiryDate) AND @COExpiryDate
                                                              AND b.BookingId <= @BookingId
                                                              AND b.SystemProcessId = 11
                                                     ORDER BY b.BookingId DESC);
                    DECLARE @nextBooking AS INT = (SELECT count(*)
                                                   FROM   dbo.Booking AS b
                                                   WHERE  b.BookingId != @bookingId
                                                          AND LicenceNumber = @LicenceNumber);
                    IF EXISTS (SELECT BP.PaymentId
                               FROM   dbo.BookingPayment AS BP
                                      INNER JOIN
                                      dbo.PaymentItemVL AS PIV
                                      ON BP.PaymentId = PIV.PaymentId
                               WHERE  BP.BookingId = (SELECT MAX(BookingId)
                                                      FROM   @BookingIds)
                                      AND PIV.FeeId <> 6) -- 6 LATE RESCHEDULE
                        BEGIN
                            INSERT INTO @PaymentItemIds
                            SELECT PaymentItemId
                            FROM   dbo.PaymentItemVL AS PIVL
                                   INNER JOIN
                                   dbo.PaymentVL AS PVL
                                   ON PVL.PaymentId = PIVL.PaymentId
                            WHERE  PaymentStatusId IN (2) --Only paid payments can be refunded
                                   AND LicenceNumber = @LicenceNumber
                                   AND PVL.PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                                         FROM   dbo.BookingPayment
                                                         WHERE  BookingId = (SELECT MAX(BookingId)
                                                                             FROM   @BookingIds))
                                   AND FeeId IN (SELECT FeeId
                                                 FROM   dbo.PaymentItemVLRefundableFee
                                                 WHERE  RefundReasonId = @RefundReasonId);
                        END
                    ELSE
                        BEGIN
                            INSERT INTO @PaymentItemIds
                            SELECT PaymentItemId
                            FROM   dbo.PaymentItemVL AS PIVL
                                   INNER JOIN
                                   dbo.PaymentVL AS PVL
                                   ON PVL.PaymentId = PIVL.PaymentId
                            WHERE  PaymentStatusId IN (2) --Only paid payments can be refunded
                                   AND LicenceNumber = @LicenceNumber
                                   AND FeeId IN (SELECT FeeId
                                                 FROM   dbo.PaymentItemVLRefundableFee
                                                 WHERE  RefundReasonId = @RefundReasonId);
                        END
                    --Add the new licence ISI from the original payment if it doesn't already exist
                    --This would only happen if the booking is canceled on an original conditional offer inspection
                    --OR If the offer is refunded without a booking ever made
                    IF @RefundReasonId IN (1, 2, 4,6)   --- Add RefundReasonId = 6 For Failed Inspection on 17/08/2016
                        BEGIN
                            DECLARE @failedInspection AS INT = (SELECT b.BookingId
                                                                FROM   dbo.Booking AS b
                                                                       INNER JOIN
                                                                       dbo.VehicleInspections AS vi
                                                                       ON b.BookingId = vi.BookingId
                                                                WHERE  b.BookingId = @ParentId
                                                                       AND BookingStatusId IN (3)
                                                                       AND vi.TestResultId = 2);
                            DECLARE @lastInspectionFailed AS INT = (SELECT b.BookingId
                                                                    FROM   dbo.Booking AS b
                                                                           INNER JOIN
                                                                           dbo.VehicleInspections AS vi
                                                                           ON b.BookingId = vi.BookingId
                                                                    WHERE  b.BookingId = @BookingId
                                                                           AND BookingStatusId IN (3)
                                                                           AND vi.TestResultId = 2);
                                                                           
                            Declare @lastBookingLateCancellation int
							Declare @lastInspectionFailedByLicenceNumber int
							Declare @lastInspectionNoShow int

							-- For WAT/WAH/Limo check whether last booking has late cancellation or last inspection failed
							IF EXISTS (Select LicenceNumber FROM dbo.LicenceMasterVL WHERE LicenceNumber = @licenceNumber AND LicenceTypeId in (3, 4, 6) /*WAT/WAH/Limo*/) 
							BEGIN

								SET @lastBookingLateCancellation = (SELECT BookingId FROM dbo.Booking B
																			WHERE B.BookingId = (SELECT Top 1 BookingId FROM dbo.Booking B
																				where B.LicenceNumber = @licenceNumber
																				order by BookingId desc)
																			AND B.BookingStatusId = 5 -- Cancelled booking
																			AND B.LateCancellation = 1)
								
								SET @lastInspectionFailedByLicenceNumber = (SELECT b.BookingId FROM dbo.Booking b
																			join dbo.VehicleInspections vi ON b.BookingId=vi.BookingId
																			WHERE b.BookingId = (SELECT Top 1 BookingId FROM dbo.Booking B
																				where B.LicenceNumber = @licenceNumber
																				order by BookingId desc)
																			AND b.BookingStatusId = 3 -- Completed booking
																			AND vi.TestResultId = 2) -- Failed inspection
																			
								SET @lastInspectionNoShow = (SELECT b.BookingId FROM dbo.Booking b
																			join dbo.VehicleInspections vi ON b.BookingId=vi.BookingId
																			WHERE b.BookingId = (SELECT Top 1 BookingId FROM dbo.Booking B
																				where B.LicenceNumber = @licenceNumber
																				order by BookingId desc)
																			AND vi.TestResultId = 3) -- No Show inspection

							END

                            SELECT   TOP 1 @PaymentItemId = PaymentItemId
                            FROM     dbo.PaymentVL AS PVL
                                     INNER JOIN
                                     dbo.PaymentItemVL AS PIVL
                                     ON PVL.PaymentId = PIVL.PaymentId
                            WHERE    LicenceNumber = @LicenceNumber
                                     AND PVL.ServiceTypeId = 7
                                     AND PIVL.FeeId IN (SELECT NewLicenceFeeId
                                                        FROM   dbo.LicenceType
                                                        WHERE  LicenceTypeId = @LicenceTypeId)
                            ORDER BY PIVL.PaymentId ASC;
                            ---If Conditional Offer will go to expire and booking was open-failed then ISI fees should not refund during cancel booking.
                            IF @RefundReasonId = 4
                                BEGIN
                                    IF (((SELECT count(*) FROM @bookingIds) > 0 AND @lastInspectionFailed IS NULL) -- IF CO EXPIRED AND LAST ISI is NO SHOW and if there was at least one booking ever made
                                        OR (@lastBookingLateCancellation IS NOT NULL) -- If last booking has late cancellation
										OR (@lastInspectionFailedByLicenceNumber IS NOT NULL) -- If last inspection failed
										OR (@lastInspectionNoShow IS NOT NULL)) -- If last inspection is No Show
                                        BEGIN
                                            DELETE @PaymentItemIds
                                            WHERE  PaymentItemId IN (SELECT PaymentItemId
                                                                     FROM   PaymentItemVL AS PIV
                                                                            INNER JOIN
                                                                            dbo.PaymentVL AS P
                                                                            ON PIV.PaymentId = P.PaymentId
                                                                     WHERE  FeeId = 5
                                                                            AND P.LicenceNumber = @LicenceNumber);
                                        END
                                END

								
							declare @bookingCount int = ( SELECT count(*) TestResultId FROM dbo.vBookingWithDetails WHERE LicenceNumber = @LicenceNumber)

							IF(@bookingCount > 1)
								BEGIN
								--Get Last booking for selected licence
								declare @testResultIdOfLastBookingForSelectedLicence int = 
								(SELECT top 1 TestResultId FROM dbo.vBookingWithDetails	WHERE LicenceNumber = @LicenceNumber					
								order by BookingId desc) 
								
								-- Get one before last booking for selected licence
								declare @oneBeforeLastbookingStatusId  int = (
								Select top 1  bookingstatusid from (
									SELECT	top 2 *	FROM	
									dbo.vBookingWithDetails where  LicenceNumber = @LicenceNumber order by BookingId desc) a
								order by a.BookingId)
							END



						

                            IF (@PaymentItemId IS NOT NULL
                                AND (@failedInspection IS NOT NULL
                                     OR @NoShowBooking IS NOT NULL))
                                BEGIN
                                    INSERT INTO @PaymentItemIds (PaymentItemId)
                                    SELECT PaymentItemId
                                    FROM   dbo.PaymentVL AS PVL
                                           INNER JOIN
                                           dbo.PaymentItemVL AS PIVL
                                           ON PVL.PaymentId = PIVL.PaymentId
                                    WHERE  LicenceNumber = @LicenceNumber
                                           AND PVL.ServiceTypeId = 7
                                           AND PIVL.FeeId <> 5
                                           AND PIVL.FeeId NOT IN (10) --- No Admin Fees would be refund during New Licence2 Booking Cancelled 	
                                           AND PIVL.FeeId NOT IN (SELECT FeeId
                                                                  FROM   dbo.PaymentItemVL
                                                                  WHERE  PaymentItemId IN (SELECT PaymentItemId
                                                                                           FROM   @PaymentItemIds));
                                END
							ELSE IF (@PaymentItemId IS NOT NULL and @testResultIdOfLastBookingForSelectedLicence = 2
								and @oneBeforeLastbookingStatusId = 5
							) -- There is last booking with inspection fail id = 2, and one before last need to be cancellation booking = 5
								BEGIN
								    -- Refund admin fee if last booking has inspection fail
									INSERT INTO @PaymentItemIds (PaymentItemId)
								        SELECT PaymentItemId
								        FROM   dbo.PaymentVL AS PVL
								               INNER JOIN
								               dbo.PaymentItemVL AS PIVL
								               ON PVL.PaymentId = PIVL.PaymentId
								        WHERE  LicenceNumber = @LicenceNumber
								               AND PVL.ServiceTypeId = 7
								               AND PIVL.FeeId <> 5
								               AND PIVL.FeeId NOT IN (SELECT FeeId
								                                      FROM   dbo.PaymentItemVL
								                                      WHERE  PaymentItemId IN (SELECT PaymentItemId
								                                                               FROM   @PaymentItemIds));
								END
                            ELSE
                                IF (@PaymentItemId IS NOT NULL
                                    AND @RefundReasonId = 1) --early cancellation 
                                    BEGIN		
									 					
                                        IF (@nextBooking > 0) -- if its early canccellation and this IS SUBSEQUENT booking
                                            BEGIN
										
                                                INSERT INTO @PaymentItemIds (PaymentItemId)
                                                SELECT PaymentItemId
                                                FROM   dbo.PaymentVL AS PVL
                                                       INNER JOIN
                                                       dbo.PaymentItemVL AS PIVL
                                                       ON PVL.PaymentId = PIVL.PaymentId
                                                WHERE  LicenceNumber = @LicenceNumber
                                                       AND (PIVL.FeeId = 10 -- NEW LICENCE FEE AND ADMIN FEE TO BE RETURNED				
                                                            OR PIVL.FeeId IN (SELECT NewLicenceFeeId
                                                                              FROM   dbo.LicenceType
                                                                              WHERE  LicenceTypeId = @LicenceTypeId))
                                                       AND PIVL.FeeId <> 5 -- NO ISI FEE RETURNED
                                                       AND PIVL.FeeId <> 6 -- no late reschedule to be refund
                                                       AND PVL.PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                                                             FROM   dbo.BookingPayment
                                                                             WHERE  BookingId = (SELECT MAX(BookingId)
                                                                                                 FROM   @BookingIds));
                                            END
                                        ELSE
                                            BEGIN
										
                                                INSERT INTO @PaymentItemIds (PaymentItemId) -- if its early canccellation and this IS FIRST booking on this CO
                                                SELECT PaymentItemId
                                                FROM   dbo.PaymentVL AS PVL
                                                       INNER JOIN
                                                       dbo.PaymentItemVL AS PIVL
                                                       ON PVL.PaymentId = PIVL.PaymentId
                                                WHERE  LicenceNumber = @LicenceNumber
                                                       AND PVL.ServiceTypeId = 7
                                                       AND PIVL.FeeId <> 6 -- no late reschedule to be refund																		
                                                       AND PIVL.FeeId IN (SELECT NewLicenceFeeId
                                                                          FROM   dbo.LicenceType
                                                                          WHERE  LicenceTypeId = @LicenceTypeId)
                                                       AND PVL.PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                                                             FROM   dbo.BookingPayment
                                                                             WHERE  BookingId = (SELECT MAX(BookingId)
                                                                                                 FROM   @BookingIds));
                                            END
                                    END
                                ELSE
                                    IF (@PaymentItemId IS NOT NULL
                                        AND @RefundReasonId = 2) --late cancellation										
                                        BEGIN
							
                                            IF (@nextBooking > 0) -- if its late canccellation and this IS SUBSEQUENT booking
                                                BEGIN
											
                                                    INSERT INTO @PaymentItemIds (PaymentItemId)
                                                    SELECT PaymentItemId
                                                    FROM   dbo.PaymentVL AS PVL
                                                           INNER JOIN
                                                           dbo.PaymentItemVL AS PIVL
                                                           ON PVL.PaymentId = PIVL.PaymentId
                                                    WHERE  LicenceNumber = @LicenceNumber
                                                           AND (PIVL.FeeId = 10 -- NEW LICENCE FEE AND ADMIN FEE TO BE RETURNED				
                                                                OR PIVL.FeeId IN (SELECT NewLicenceFeeId
                                                                                  FROM   dbo.LicenceType
                                                                                  WHERE  LicenceTypeId = @LicenceTypeId))
                                                           AND PIVL.FeeId <> 5 -- NO ISI FEE RETURNED
                                                           AND PIVL.FeeId <> 6 -- no late reschedule to be refund
                                                           AND PVL.PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                                                                 FROM   dbo.BookingPayment
                                                                                 WHERE  BookingId = (SELECT MAX(BookingId)
                                                                                                     FROM   @BookingIds));
                                                END
                                            ELSE
                                                BEGIN
										
                                                    INSERT INTO @PaymentItemIds (PaymentItemId) -- if its late canccellation and this IS SUBSEQUENT booking
                                                    SELECT PaymentItemId
                                                    FROM   dbo.PaymentVL AS PVL
                                                           INNER JOIN
                                                           dbo.PaymentItemVL AS PIVL
                                                           ON PVL.PaymentId = PIVL.PaymentId
                                                    WHERE  LicenceNumber = @LicenceNumber
                                                           AND PVL.ServiceTypeId = 7
                                                           AND PIVL.FeeId <> 6 -- no late reschedule to be refund																		
                                                           AND PIVL.FeeId IN (SELECT NewLicenceFeeId
                                                                              FROM   dbo.LicenceType
                                                                              WHERE  LicenceTypeId = @LicenceTypeId)
                                                           AND PVL.PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                                                                 FROM   dbo.BookingPayment
                                                                                 WHERE  BookingId = (SELECT MAX(BookingId)
                                                                                                     FROM   @BookingIds));
                                                END
                                        END
                                    ELSE
							
                                        
										
										
										
							IF (@PaymentItemId IS NOT NULL)
                               BEGIN
					
                                   INSERT INTO @PaymentItemIds (PaymentItemId)
                                   SELECT PaymentItemId
                                   FROM   dbo.PaymentVL AS PVL
                                          INNER JOIN
                                          dbo.PaymentItemVL AS PIVL
                                          ON PVL.PaymentId = PIVL.PaymentId
                                   WHERE  LicenceNumber = @LicenceNumber
                                          AND PIVL.FeeId = 6 --Late Reschedule				
                                          AND PVL.PaymentId IN (SELECT TOP 1 PaymentID
                                                                FROM   SystemProcessInstanceVL
                                                                WHERE  LicenceNumber = @LicenceNumber
                                                                       AND SystemProcessId = 16)
                                          AND PVL.PaymentId IN (SELECT PaymentId --Only payments related to current booking
                                                                FROM   dbo.BookingPayment
                                                                WHERE  BookingId = (SELECT MAX(BookingId)
                                                                                    FROM   @BookingIds));
                              END
                        END
                END
        END
    
	IF EXISTS (SELECT B.BookingId
               FROM   dbo.Booking AS B
                      INNER JOIN
                      dbo.VehicleInspections AS VI
                      ON VI.BookingId = B.BookingId
                      INNER JOIN
                      dbo.LicenceMasterVL AS L
                      ON B.LicenceNumber = L.LicenceNumber
               WHERE  (B.LicenceNumber = @LicenceNumber
                       AND L.LicenceStateId = 10
                       AND VI.TestResultId = 2
                       AND B.BookingStatusId = 3
                       AND B.BookingId = @BookingId
                       AND @RefundReasonId NOT IN (4,6)))
        BEGIN
            SET @Amount = 0.00;
        END
    ELSE 
        /*IF (@LicenceTypeId = 7  
            AND @LicenceStateId = 10)
            BEGIN
                SET @Amount = 0.00;
            END
        ELSE*/
            BEGIN
                SELECT @Amount = COALESCE (sum(Amount), 0)
                FROM   dbo.PaymentItemVL
                WHERE  PaymentItemId IN (SELECT PaymentItemId
                                         FROM   @PaymentItemIds);
            END
    --Now that the paymentids are collected, begin a transaction to cancel the bookings and payments
    BEGIN TRY
        BEGIN TRANSACTION FINISH;
        INSERT  INTO dbo.PaymentRefundVL (LicenceNumber, Amount, BookingCancellationId, RefundReasonId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
        VALUES                          (@LicenceNumber, @Amount, @BookingCancellationReasonId, @RefundReasonId, @Username, @ModifiedDate, @Username, @ModifiedDate);
        SET @RefundId = Scope_Identity();
        IF @RefundId IS NULL
            BEGIN
                RAISERROR ('Unable to add a refund', 16, 1);
            END
        --When inserting the reason for a booking refund
        --In most cases the reason for refunding everything is supplied
        --However if a failed test result exists for a booking
        --Then the booking refund reason is over-ridden with the "Failed Inspection" reason            
        INSERT INTO dbo.BookingRefund (BookingId, RefundId, RefundReasonId)
        SELECT BookingId,
               @RefundId,
               CASE TestResultId 
					WHEN 2 THEN 6 ELSE @RefundReasonId --Failed Inspection
			   END
        FROM   @BookingIds;

		Declare @IsExpiredLicence as int = (Select licencestatemasterId from dbo.LicenceMasterVL Where LicenceNumber = @LicenceNumber AND LicenceStateMasterId=5 AND LicenceStateId=8)
		IF @RefundReasonId IN (6) OR (@RefundReasonId = 2 AND @IsExpiredLicence = 5 )  --If Licence has been expired then updated open-fail booking to 'Completed -Fail(Closed)
			BEGIN			
				SELECT @ParentId = ParentId 
				FROM Booking
				WHERE BookingId = @BookingId
				UPDATE  dbo.Booking
						SET  BookingStatusId             = 5,							
							BookingCancellationReasonId = @BookingCancellationReasonId,
							LateCancellation            = CASE @RefundReasonId 
														WHEN 2 THEN 1 ELSE 0 --Failed Inspection
														END,
							ModifiedBy                  = @Username,
							ModifiedDate                = @ModifiedDate
					WHERE   ParentId = @ParentId and BookingStatusid in (1, 2);
					--IF Booking is Completed-Fail and Cancellation Reason is 'Failed Inspection'
				 UPDATE dbo.VehicleInspections 
						SET TestResultId = 6,
							ModifiedBy                  = @Username,
							ModifiedDate                = @ModifiedDate
					WHERE    BookingId IN (SELECT BookingId
									  FROM   @BookingIds)
							AND LicenceNumber = @LicenceNumber
							AND TestResultId = 2;
							
			END
		ELSE 
			BEGIN
				UPDATE  dbo.Booking
					SET BookingStatusId             = 5,
						BookingCancellationReasonId = @BookingCancellationReasonId,
						LateCancellation            = CASE @RefundReasonId 
													WHEN 2 THEN 1 ELSE 0 --Failed Inspection
													END,
						ModifiedBy                  = @Username,
						ModifiedDate                = @ModifiedDate
				WHERE   BookingId IN (SELECT BookingId
									  FROM   @BookingIds);
			END


        INSERT INTO BookingAudit (BookingId, ParentId, InspectionTimeId, TestCentreId, TestCentreLaneId, BookingStatusId, SystemProcessId, BookingDateTime, BookingEndDateTime, LicenceNumber, RegistrationNumber, BookingCancellationReasonId, NewLicenceHolderId, LateCancellation, LateReschedule, PremiumBooking, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
        SELECT BookingId,
               ParentId,
               InspectionTimeId,
               TestCentreId,
               TestCentreLaneId,
               BookingStatusId,
               SystemProcessId,
               BookingDateTime,
               BookingEndDateTime,
               LicenceNumber,
               RegistrationNumber,
               BookingCancellationReasonId,
               NewLicenceHolderId,
               LateCancellation,
               LateReschedule,
               PremiumBooking,
               CreatedBy,
               CreatedDate,
               ModifiedBy,
               ModifiedDate
        FROM   dbo.Booking
        WHERE  BookingId IN (SELECT BookingId
                             FROM   @BookingIds);
        --IF (@LicenceTypeId <> 7)
           -- BEGIN
                IF NOT EXISTS (SELECT B.BookingId
                               FROM   dbo.Booking AS B
                                      INNER JOIN
                                      dbo.VehicleInspections AS VI
                                      ON VI.BookingId = B.BookingId
                                      INNER JOIN
                                      dbo.LicenceMasterVL AS L
                                      ON B.LicenceNumber = L.LicenceNumber
                               WHERE  (B.LicenceNumber = @LicenceNumber
                                       AND L.LicenceStateId = 10
                                       AND VI.TestResultId = 2
                                       AND @RefundReasonId NOT IN (1, 2, 4)))   
                    BEGIN
                        INSERT dbo.PaymentRefundItemVL (RefundId, PaymentItemId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
                        SELECT @RefundId,
                               PaymentItemId,
                               @Username,
                               @ModifiedDate,
                               @Username,
                               @ModifiedDate
                        FROM   @PaymentItemIds;
                        UPDATE  dbo.PaymentItemVL
                            SET PaymentStatusId = 3, --Refunded
                                ModifiedBy      = @Username,
                                ModifiedDate    = @ModifiedDate
                        WHERE   PaymentItemId IN (SELECT PaymentItemId
                                                  FROM   @PaymentItemIds);
                        INSERT INTO dbo.PaymentItemVLAudit (PaymentItemId, PaymentId, FeeId, Amount, PaymentStatusId, Comments, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
                        SELECT PaymentItemId,
                               PaymentId,
                               FeeId,
                               Amount,
                               PaymentStatusId,
                               Comments,
                               CreatedBy,
                               CreatedDate,
                               ModifiedBy,
                               ModifiedDate
                        FROM   dbo.PaymentItemVL
                        WHERE  PaymentItemId IN (SELECT PaymentItemId
                                                 FROM   @PaymentItemIds);
                    END
          --  END
        ------------------ For Expire Conditional Offer Licence   -----------------------------------------
        IF @RefundReasonId = 4 --- Conditional Offer Expiration
            BEGIN
                IF @LicenceStateId = 10 --Conditional Offer
                    BEGIN
                        --Check why we are refunding the conditional offer                  
                        --If a conditional offer has expired, set the letter type and history type
                        IF @ProcessExpiration = 1
                            BEGIN
                                SET @HistoryChangeId = 32; -- cancelled offer
                                SET @LetterRequestTypeId = 3;
                            END
                        ELSE
                            BEGIN
                                SET @HistoryChangeId = 23; -- Time Out Condtional Offer
                                SET @LetterRequestTypeId = 2;
                            END
                        --The licence changes to dead
                        UPDATE  dbo.LicenceMasterVL
                            SET LicenceStateMasterId = 6, --- Dead
                                LicenceStateId       = 17, -- Conditional Offer
                                ModifiedBy           = @Username,
                                ModifiedDate         = @ModifiedDate,
                                HistoryChangeId      = @HistoryChangeId
                        WHERE   LicenceNumber = @LicenceNumber;
                        INSERT INTO LicenceMasterVLAudit (PlateNumber, LicenceNumber, LicenceHolderId, RegistrationNumber, LicenceTypeId, LicenceStateId, LicenceStateMasterId, LicenceExpiryDate, LicenceIssueDate, CoExpiryDate, CoIssueDate, RenewalDate, TransferedFromReg, HistoryChangeId, TestCenterId, RemainingTransfers, TransferDate, OldPlateNumber, OldLicenceAuthority, Ccsn, Ppsn, CompanyNumber, FirstName, LastName, DateOfBirth, CompanyName, TradingAs, AddressLine1, AddressLine2, AddressLine3, Town, CountyId, PostCode, CountryId, PhoneNo1, PhoneNo2, Email, TaxClearanceNumber, TaxClearanceExpiryDate, TaxClearanceStatus, TaxClearanceVisual, TaxClearanceName, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, AuditDate)
                        SELECT PlateNumber,
                               LicenceNumber,
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
                               Email,
                               TaxClearanceNumber,
                               TaxClearanceExpiryDate,
                               TaxClearanceStatus,
                               TaxClearanceVisual,
                               TaxClearanceName,
                               L.CreatedBy,
                               L.CreatedDate,
                               L.ModifiedBy,
                               L.ModifiedDate,
                               @ModifiedDate
                        FROM   LicenceMasterVL AS L
                               INNER JOIN
                               LicenceHolderMaster AS LH
                               ON LH.LicenceHolderId = L.LicenceHolderId
                        WHERE  LicenceNumber = @LicenceNumber;

						-- Manual conditional offer cancelation
					
					IF(@ManualCancelConditionalOffer is not null and @ManualCancelConditionalOffer = 1)
							BEGIN
								  -- change refund reason to 'Conditional Offer Cancelation'	
								  update [cabs_production].[dbo].[PaymentRefundVL]
									set RefundReasonId = 8  where RefundId = @RefundId 

								  -- Update CO Expiry Date
									update LicenceMasterVL 
										set CoExpiryDate = GETDATE()
									where LicenceNumber = @LicenceNumber
									
									EXECUTE USP_DWH_PrintRequestVL_Insert @PrintRequestId = @RequestId OUTPUT, 
									@LicenceNumber = @LicenceNumber, @LicenceHolderId = @LicenceHolderId, 
									@NewLicenceHolderId = NULL, @PreviousLicenceHolderId = NULL, 
									@VehicleRegistrationNumber = @RegNumber, @NewVehicleRegistrationNumber = NULL, 
									@PreviousVehicleRegistrationNumber = NULL, @BookingId = NULL, 
									@PaymentId = NULL, @PrintRequestReasonId = 1, 
									@LetterRequestTypeId = 2, 
									@CreatedBy = 'System', 
									@ManualCancelConditionalOffer = @ManualCancelConditionalOffer,
									@BookingCancellationReasonId = @BookingCancellationReasonId                
						
							END
						ELSE -- System conditional offer cancelation
							BEGIN							 
								EXECUTE USP_DWH_PrintRequestVL_Insert @PrintRequestId = @RequestId OUTPUT, @LicenceNumber = @LicenceNumber, @LicenceHolderId = @LicenceHolderId, @NewLicenceHolderId = NULL, @PreviousLicenceHolderId = NULL, @VehicleRegistrationNumber = @RegNumber, @NewVehicleRegistrationNumber = NULL, @PreviousVehicleRegistrationNumber = NULL, @BookingId = NULL, @PaymentId = NULL, @PrintRequestReasonId = 1, @LetterRequestTypeId = @LetterRequestTypeId, @CreatedBy = 'System';                
							END

                         IF @RequestId IS NULL
                            BEGIN
                                SET @ErrorMessage = 'Unable to generate cancellation/expiry conditional offer letter for licence # ' + @LicenceNumber;
                                RAISERROR (@ErrorMessage, 16, 1);
                            END
                    END
            END
        COMMIT TRANSACTION FINISH;
        RETURN @@TRANCOUNT;
    END TRY
    BEGIN CATCH
        SET @ErrorMessage = ERROR_MESSAGE();
        ROLLBACK TRANSACTION FINISH;
        BEGIN TRY
            --Log the error            
            DECLARE @log_date AS DATETIME;
            DECLARE @thread AS VARCHAR (256);
            SET @log_date = GETDATE();
            SET @thread = CONVERT (VARCHAR (10), @@SPID);
            EXECUTE [dbo].[EventLog_Log4Net_Insert] @log_date = @log_date, @thread = @thread, @log_level = 'ERROR', @logger = 'Booking_CancelAndRefund SPROC', @message = @ErrorMessage, @url = NULL, @usr = @username, @addr = NULL;
        END TRY
        BEGIN CATCH
        END CATCH
        RAISERROR (@ErrorMessage, 16, 1);
        RETURN 0;
    END CATCH
END
SET NOCOUNT OFF;
GO


