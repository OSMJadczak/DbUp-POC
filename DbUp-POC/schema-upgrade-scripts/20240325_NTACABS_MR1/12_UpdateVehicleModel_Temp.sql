USE [cabs_production]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[UpdateVehicleModel_Temp]
AS
BEGIN

	declare @RegistrationNumber nvarchar(50)	
	declare @updatedVLSRows int		
	declare @Count bigint = 0
	
    declare IU_NotInSync cursor for
		Select l.RegistrationNumber from LicenceMasterVL l 
				inner join VehicleMaster v ON l.RegistrationNumber=v.RegistrationNumber
				inner join VehicleMake vm On v.MakeId=vm.MakeId
				inner join VehicleModel vmo On v.ModelId = vmo.ModelId
				Where (vmo.Model like 'C SERIES')
      
	open IU_NotInSync
	  fetch next from IU_NotInSync into @RegistrationNumber
	while (@@FETCH_STATUS <> -1)	  
	begin	  
	  Update dbo.VehicleMaster Set ModelId=2054  where RegistrationNumber =@RegistrationNumber AND MakeId=179;
	   
	  set @updatedVLSRows = @@Rowcount

	  if (@updatedVLSRows > 0) 
	  begin
		INSERT INTO [dbo].[VehicleMasterAudit]([RegistrationNumber],[MakeId],[ModelId],[BodyTypeId],[FuelTypeId],[ColourId],[EngineCapacity],[VIN]
           ,[YearOfManufacture],[RegistrationDateIreland],[RegistrationDateOrigin],[TurboDieselYn],[ModifiedYn],[TestCenterId],[NumberPassengers]
           ,[NumberSeats],[NumberDoors],[TypeApprovalNumber],[TypeApprovalCategory],[PermissibleMassGvw],[VrtVehicleCategory],[NctSerialNumber]
           ,[NctIssueDate],[NctExpiryDate],[LastDocumentationCheckDate],[MileageReading],[ExcessWindowTint],[DataCheckedDate],[InsuranceExpiryDate]
           ,[InsuranceClassCorrect],[CreatedBy],[ModifiedBy] ,[CreatedDate],[ModifiedDate],[AuditDate],[HistoryChangeId],[RoofSignSticker],[MeterSealed])
			Select top 1 [RegistrationNumber],[MakeId],2054,[BodyTypeId],[FuelTypeId],[ColourId],[EngineCapacity],[VIN]
           ,[YearOfManufacture],[RegistrationDateIreland],[RegistrationDateOrigin],[TurboDieselYn],[ModifiedYn],[TestCenterId],[NumberPassengers]
           ,[NumberSeats],[NumberDoors],[TypeApprovalNumber],[TypeApprovalCategory],[PermissibleMassGvw],[VrtVehicleCategory],[NctSerialNumber]
           ,[NctIssueDate],[NctExpiryDate],[LastDocumentationCheckDate],[MileageReading],[ExcessWindowTint],[DataCheckedDate],[InsuranceExpiryDate]
           ,[InsuranceClassCorrect],[CreatedBy],'Helpdesk' ,[CreatedDate],getdate(),getdate(),48,[RoofSignSticker],[MeterSealed]
		   from dbo.VehicleMasterAudit where RegistrationNumber=@RegistrationNumber order by id desc
		   
		  set @Count = @Count + 1
	  end;     
	
	  fetch next from IU_NotInSync into @RegistrationNumber
	end
    close IU_NotInSync
    deallocate IU_NotInSync	    
   			   	        
END
GO
