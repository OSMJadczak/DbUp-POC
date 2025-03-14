USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[WatRegister_Update]    Script Date: 21/11/2023 15:47:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[WatRegister_Update]

(
@LicenceNumber varchar(50),
@PersonId int = NULL,
@DispatchOperatorId int,
@Email nvarchar(255),
@ContactNumberBookings nvarchar(255),
@ContactNumberMobile nvarchar(255),
@WebSite nvarchar(255),
@Comments nvarchar(max),
@CreatedBy nvarchar(50),	
@CreatedDate datetime,	
@ModifiedBy nvarchar(50),	
@ModifiedDate datetime output
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SET @ModifiedDate = GETDATE()
	
UPDATE WatRegister

SET

PersonId = @PersonId,
DispatchOperatorId = @DispatchOperatorId,
Email = @Email,
ContactNumberBookings = @ContactNumberBookings,
ContactNumberMobile = @ContactNumberMobile,
WebSite = @WebSite,
Comments = @Comments,
ModifiedBy = @ModifiedBy,
ModifiedDate = @ModifiedDate

WHERE LicenceNumber = @LicenceNumber

END
