USE [cabs_production]
GO

INSERT INTO [dbo].[PaymentMethod]
           ([PaymentMethodId]
           ,[PaymentMethodName]
           ,[ReferenceFieldRequired]
           ,[PaymentGatewayRequired]
           ,[RefundablePayment]
           ,[AllowedRoles])
     VALUES
           (9
           ,'Waivered – Covid'
           ,0
           ,0
           ,0
           ,'*')
GO


