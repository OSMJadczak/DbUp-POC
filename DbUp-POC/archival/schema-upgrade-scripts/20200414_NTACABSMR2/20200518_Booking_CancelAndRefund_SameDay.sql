USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[Booking_CancelAndRefund_SameDay]    Script Date: 5/18/2020 2:15:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================

-- Author:       

-- Create date: 

-- Description:  

-- 

-- =============================================

ALTER PROCEDURE [dbo].[Booking_CancelAndRefund_SameDay]

(

@BookingId int,

@LicenceNumber varchar(20) = null,

@RefundId int output,

@RefundReasonId int,

@BookingCancellationReasonId int,

@Username nvarchar(50),

@ProcessExpiration bit,

@RefundPaymentItemIds varchar(100) = null,

@Amount smallmoney ,

@PaymentRefundOptionId int

)

 

AS

BEGIN



SET NOCOUNT OFF;

 

-----------------------------

-----------------------------

-------Declarations----------

-----------------------------

-----------------------------

DECLARE @ParentId int,           

            @LicenceHolderId int,

            @RegNumber varchar(10),

            @LicenceStateId int,

            @LicenceTypeId int,

            @PaymentItemId int,

            @ErrorMessage varchar(4000),

            @ModifiedDate datetime,

            @RequestId INT,

            @LetterRequestTypeId INT,

            @HistoryChangeId INT

                        

DECLARE @BookingIds TABLE

(

      BookingId int,

      TestResultId int NULL

)

DECLARE @PaymentItemIds TABLE

(

      PaymentItemId int

)



SET @ModifiedDate = GETDATE()

 

-----------------------------

-----------------------------

------Set Parameters---------

-----------------------------

-----------------------------

IF (@LicenceNumber IS NOT NULL)

BEGIN

SELECT @LicenceHolderId = L.LicenceHolderId
	 , @RegNumber = L.RegistrationNumber
	 , @LicenceStateId = L.LicenceStateId
	 , @LicenceTypeId = L.LicenceTypeId

FROM
	dbo.LicenceMasterVL L

WHERE
	LicenceNumber = @LicenceNumber

END

 

IF (@BookingId IS NOT NULL)

BEGIN

--Set basic parameters

--If no parent id found, default to the current booking id

SELECT @ParentId = coalesce(B.ParentId, @BookingId)
	 , @LicenceNumber = B.LicenceNumber
	 , @LicenceHolderId = L.LicenceHolderId
	 , @RegNumber = L.RegistrationNumber
	 , @LicenceStateId = L.LicenceStateId
	 , @LicenceTypeId = L.LicenceTypeId



FROM
	Booking B

	INNER JOIN LicenceMasterVL L
		ON L.LicenceNumber = B.LicenceNumber

WHERE
	BookingId = @BookingId

END

--Get all refundable bookings based on the payment id

INSERT
INTO
	@BookingIds

	(

	BookingId
  , TestResultId

	)

SELECT Booking.BookingId
	 , TestResultId

FROM
	dbo.Booking

	LEFT OUTER JOIN dbo.VehicleInspections VI
		ON VI.BookingId = Booking.BookingId

WHERE
	ParentId = @ParentId

	AND BookingStatusId IN

	(

	1, --Awaiting Payment

	2, --Confirmed

	3 --Completed

	)

 

--Check if any refundable bookings actually have passed tests

--If so, stop as none of the bookings in the parent tree will be refundable

IF EXISTS

(

 SELECT BookingId
 FROM
	 @BookingIds

 WHERE
	 TestResultId = 1

)

BEGIN 

      RETURN

END

            

 

-----------------------------

-----------------------------

--------Get Payments---------

-----------------------------

-----------------------------

IF ((SELECT count(BookingId) FROM @BookingIds) = 1 AND @LicenceNumber = (Select LMV.LicenceNumber From dbo.LicenceMasterVL LMV																																								
																		 WHERE LMV.LicenceStateMasterId=5 AND LMV.LicenceStateId=10
																				AND LMV.LicenceNumber = @LicenceNumber))
	BEGIN
			--Get Payment Item Ids that are refundable for the current booking
			IF EXISTS (SELECT PaymentId	 FROM dbo.BookingPayment WHERE BookingId=(SELECT max(BookingId) FROM @BookingIds))
				BEGIN				
					INSERT	INTO @PaymentItemIds(PaymentItemId)
					SELECT PaymentItemId FROM dbo.PaymentItemVL
							WHERE PaymentStatusId = 2 --Only paid payments can be refunded						
						AND PaymentItemVL.PaymentItemId in (SELECT Element FROM dbo.func_Split(@RefundPaymentItemIds,','))
				END
			ELSE
				BEGIN
					INSERT	INTO @PaymentItemIds(PaymentItemId)
					SELECT PaymentItemId FROM dbo.PaymentItemVL
							WHERE PaymentStatusId = 2 --Only paid payments can be refunded							
							AND PaymentItemVL.PaymentItemId in (SELECT Element FROM dbo.func_Split(@RefundPaymentItemIds,','))
				END
	END
ELSE IF (SELECT count(BookingId) FROM @BookingIds) = 1
	BEGIN
			--Get Payment Item Ids that are refundable for the current booking
			INSERT
			INTO
				@PaymentItemIds
				(
				PaymentItemId
				)
			SELECT PaymentItemId
			FROM
				dbo.PaymentItemVL
			WHERE
				PaymentStatusId = 2 --Only paid payments can be refunded
				AND PaymentId IN --Only payments related to current booking
				(
				 SELECT PaymentId
				 FROM
					 dbo.BookingPayment
				 WHERE
					 BookingId =
					 (
					  SELECT max(BookingId)
					  FROM
						  @BookingIds
					 )
				)
				AND PaymentItemVL.PaymentItemId in (SELECT Element FROM dbo.func_Split(@RefundPaymentItemIds,','))
		

	END


BEGIN TRY
 

BEGIN TRANSACTION FINISH

	INSERT
	INTO
		dbo.PaymentRefundVL

		(

		LicenceNumber
	  , Amount
	  , BookingCancellationId
	  , RefundReasonId
	  , CreatedBy
	  , CreatedDate
	  , ModifiedBy
	  , ModifiedDate

		)

	VALUES

		(

		@LicenceNumber,

		@Amount,

		@BookingCancellationReasonId,

		@RefundReasonId,

		@Username,

		@ModifiedDate,

		@Username,

		@ModifiedDate

		)



	SET @RefundId = Scope_Identity()

            

            IF @RefundId is NULL

            

            BEGIN

                  RAISERROR('Unable to add a refund', 16, 1)

            END



	--When inserting the reason for a booking refund

	--In most cases the reason for refunding everything is supplied

	--However if a failed test result exists for a booking

	--Then the booking refund reason is over-ridden with the "Failed Inspection" reason            

	INSERT
	INTO
		dbo.BookingRefund

		(

		BookingId
	  , RefundId
	  , RefundReasonId

		)

	SELECT BookingId
		 , @RefundId
		 , CASE TestResultId

			   WHEN 2 THEN
				   6 --Failed Inspection

			   ELSE
				   @RefundReasonId
		   END

	FROM
		@BookingIds



	UPDATE dbo.Booking

	SET
		BookingStatusId = 5, -- Refund
		BookingCancellationReasonId = @BookingCancellationReasonId,
		LateCancellation = CASE @RefundReasonId
							   WHEN 2 THEN
								   1 --Failed Inspection
							   ELSE
								   0
							   END,
		ModifiedBy = @Username,
		ModifiedDate = @ModifiedDate
	WHERE
		BookingId IN
		(
		 SELECT BookingId
		 FROM
			 @BookingIds
		) AND BookingStatusId IN (1,2)


	INSERT
	INTO
		BookingAudit

		(

		BookingId
	  , ParentId
	  , InspectionTimeId
	  , TestCentreId
	  , TestCentreLaneId
	  , BookingStatusId
	  , SystemProcessId
	  , BookingDateTime
	  , BookingEndDateTime
	  , LicenceNumber
	  , RegistrationNumber
	  , BookingCancellationReasonId
	  , NewLicenceHolderId
	  , LateCancellation
	  , LateReschedule
	  , PremiumBooking
	  , CreatedBy
	  , CreatedDate
	  , ModifiedBy
	  , ModifiedDate
	  , PaymentRefundOptionId
		)

	SELECT BookingId
		 , ParentId
		 , InspectionTimeId
		 , TestCentreId
		 , TestCentreLaneId
		 , BookingStatusId
		 , SystemProcessId
		 , BookingDateTime
		 , BookingEndDateTime
		 , LicenceNumber
		 , RegistrationNumber
		 , BookingCancellationReasonId
		 , NewLicenceHolderId
		 , LateCancellation
		 , LateReschedule
		 , PremiumBooking
		 , CreatedBy
		 , CreatedDate
		 , ModifiedBy
		 , ModifiedDate
		 , @PaymentRefundOptionId

	FROM
		dbo.Booking

	WHERE
		BookingId IN

		(

		 SELECT BookingId
		 FROM
			 @BookingIds

		)



	INSERT
		dbo.PaymentRefundItemVL
		(
		RefundId
	  , PaymentItemId
	  , CreatedBy
	  , CreatedDate
	  , ModifiedBy
	  , ModifiedDate
		)

	SELECT @RefundId
		 , PaymentItemId
		 , @Username
		 , @ModifiedDate
		 , @Username
		 , @ModifiedDate
	FROM
		@PaymentItemIds



	UPDATE dbo.PaymentItemVL

	SET
		PaymentStatusId = 3, --Refunded

		ModifiedBy = @Username,

		ModifiedDate = @ModifiedDate

	WHERE
		PaymentItemId IN
		(
		 SELECT PaymentItemId
		 FROM
			 @PaymentItemIds
		)



	INSERT
	INTO
		dbo.PaymentItemVLAudit
		(
		PaymentItemId
	  , PaymentId
	  , FeeId
	  , Amount
	  , PaymentStatusId
	  , Comments
	  , CreatedBy
	  , CreatedDate
	  , ModifiedBy
	  , ModifiedDate
		)
	SELECT PaymentItemId
		 , PaymentId
		 , FeeId
		 , Amount
		 , PaymentStatusId
		 , Comments
		 , CreatedBy
		 , CreatedDate
		 , ModifiedBy
		 , ModifiedDate
	FROM
		dbo.PaymentItemVL
	WHERE
		PaymentItemId IN
		(
		 SELECT PaymentItemId
		 FROM
			 @PaymentItemIds
		)




            COMMIT TRANSACTION FINISH            

            RETURN @@TRANCOUNT 

END TRY

BEGIN CATCH

	SET @ErrorMessage = ERROR_MESSAGE()      

      ROLLBACK TRANSACTION FINISH      

            Begin Try

                  --Log the error            

                  DECLARE @log_date datetime

                  DECLARE @thread varchar(256)


	SET @log_date = GETDATE()

	SET @thread = convert(VARCHAR(10), @@SPID)



	EXEC [dbo].[EventLog_Log4Net_Insert]

	@log_date = @log_date,
	@thread = @thread,
	@log_level = 'ERROR',
	@logger = 'Booking_CancelAndRefund_SameDay SPROC',
	@message = @ErrorMessage,
	@url = NULL,
	@usr = @username,
	@addr = NULL

            End try
            Begin Catch

            End Catch
      RAISERROR (@ErrorMessage, 16, 1);           

      RETURN 0      

END CATCH


END


	SET NOCOUNT OFF;


GO


