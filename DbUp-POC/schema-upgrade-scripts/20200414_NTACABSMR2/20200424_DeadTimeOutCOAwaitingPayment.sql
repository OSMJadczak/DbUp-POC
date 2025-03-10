USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[DeadTimeOutCOAwaitingPayment]    Script Date: 4/24/2020 1:02:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[DeadTimeOutCOAwaitingPayment]

(

@LicenceNumber varchar(20) = null,
@Username nvarchar(50),
@ProcessExpiration bit

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
          
            @ErrorMessage varchar(4000),

            @ModifiedDate datetime,

            @RequestId INT,           

            @HistoryChangeId INT



SET @ModifiedDate = GETDATE()
SET @HistoryChangeId = 32



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

	--The licence changes to dead



	UPDATE dbo.LicenceMasterVL

	SET
		LicenceStateMasterId = 6,
		ModifiedBy = @Username,
		ModifiedDate = @ModifiedDate,
		HistoryChangeId = @HistoryChangeId



	WHERE
		LicenceNumber = @LicenceNumber

    EXEC [dbo].[LicenceMasterVLAudit_AuditLastChange] @LicenceNumber = @LicenceNumber, @ModifiedDate = @ModifiedDate


END

GO


