USE [cabs_production]
GO

/****** Object:  StoredProcedure [cabs_spsv].[GenerateLetter]    Script Date: 10/20/2020 3:24:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER procedure [cabs_spsv].[GenerateLetter]
	@LetterDataEntryXml nvarchar(max)
as
begin
SET NOCOUNT ON
	declare @NowDate datetime=getdate();
	declare @Templates table(Name nvarchar(100), IsDl bit, IsVl bit, LetterRequestTypeAuditId int, DespatchMethodVL int, DespatchMethodDL int);
	declare @CreatedBy nvarchar(20);
	declare @CreatedOn datetime;

	declare @PrintRequestReasonId int;
	declare @PrintCompanyId int;

	declare @DriverLicenceHolderId int;
	declare @DriverLicenceHolderEmail nvarchar(50);
	declare @DriverLicenceNumber varchar(50);
	declare @DriverLicenceId int;
	declare @DriverLicenceHolderFirstName nvarchar(50);
	declare @DriverLicenceHolderLastName nvarchar(50);
	declare @DriverLicenceHolderAddress1 nvarchar(100);
	declare @DriverLicenceHolderAddress2 nvarchar(100);
	declare @DriverLicenceHolderAddress3 nvarchar(100);
	declare @DriverLicenceHolderAddress4 nvarchar(100);
	declare @DriverLicenceHolderTown nvarchar(50);
	declare @DriverLicenceHolderCounty nvarchar(20);
	declare @DriverLicenceHolderPostcode varchar(12);
	declare @DriverLicenceStatus nvarchar(100);
	declare @DriverLicenceExpireDate varchar(20);
	declare @DriverPpsn varchar(20);

	declare @VehicleLicenceHolderId int;
	declare @VehicleLicenceHolderEmail nvarchar(50);
	declare @VehicleLicenceNumber nvarchar(50);
	declare @HistoricalVehicleLicenceNumber nvarchar(50);
	declare @VehicleRegistrationNumber nvarchar(100);
	declare @VehicleLicenceHolderFirstName nvarchar(50);
	declare @VehicleLicenceHolderLastName nvarchar(50);
	declare @VehicleLicenceFullName nvarchar(101);
	declare @VehicleLicenceHolderAddress1 nvarchar(100);
	declare @VehicleLicenceHolderAddress2 nvarchar(100);
	declare @VehicleLicenceHolderAddress3 nvarchar(100);
	declare @VehicleLicenceHolderAddress4 nvarchar(100);
	declare @VehicleLicenceHolderTown nvarchar(50);
	declare @VehicleLicenceHolderCounty nvarchar(50);
	declare @VehicleLicenceHolderPostcode nvarchar(50);
	declare @VehicleLicenceStatus nvarchar(100);
	declare @VehicleLicenceExpireDate nvarchar(100);
	declare @VehicleMake nvarchar(100);
	declare @VehicleModel nvarchar(100);
	declare @VehiclePpsn varchar(20);

	declare @LinkStartDate nvarchar(100);
	declare @LinkEndDate nvarchar(100);
	declare @LinkMethod nvarchar(100);
	declare @IsLinkPerpetual nvarchar(100);
	declare @RentalStartDate nvarchar(100);
	declare @RentalEndDate nvarchar(100);
	declare @RentalMethod nvarchar(100);
	declare @SpsvWebUrl nvarchar(100);
	declare @SpsvRegistrationNumber nvarchar(10);
	declare @SpsvInvitationUrl nvarchar(100);
	declare @SpsvEmailHtml nvarchar(max);
	declare @SpsvEmailItemId int;
	declare @SpsvSmsMessage nvarchar(max);
	declare @SpsvSmsPhoneNumber nvarchar(50);

	declare @PrintRequestStatusId int;
	declare @PrintRequestMasterId int;
	declare @PrintRequestId int;	
	declare @ErrorMessage nvarchar(255);	
	
	declare @xml xml=CAST (@LetterDataEntryXml AS xml)

	select @CreatedBy=Node.Id.value('.', 'nvarchar(20)') from @xml.nodes('/LetterDataEntry/CreatedBy') as Node(Id)

	select @PrintRequestStatusId=Node.Id.value('number(.)', 'int') from @xml.nodes('/LetterDataEntry/PrintRequestStatusId') as Node(Id)
	select @PrintRequestReasonId=Node.Id.value('number(.)', 'int') from @xml.nodes('/LetterDataEntry/PrintRequestReasonId') as Node(Id)
	select @PrintCompanyId=Node.Id.value('number(.)', 'int') from @xml.nodes('/LetterDataEntry/PrintCompanyId') as Node(Id)
                   
	select @DriverLicenceHolderId=Node.Id.value('number(.)', 'int') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderId') as Node(Id)
	select @DriverLicenceHolderEmail=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderEmail') as Node(Id)
	select @DriverLicenceNumber=Node.Id.value('.', 'varchar(50)') from @xml.nodes('/LetterDataEntry/DriverLicenceNumber') as Node(Id)
	select @DriverLicenceId=Node.Id.value('number(.)', 'int') from @xml.nodes('/LetterDataEntry/DriverLicenceId') as Node(Id)
	select @DriverLicenceHolderFirstName=Node.Id.value('.', 'nvarchar(25)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderFirstName') as Node(Id)
	select @DriverLicenceHolderLastName=Node.Id.value('.', 'nvarchar(25)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderLastName') as Node(Id)
	select @DriverLicenceHolderAddress1=Node.Id.value('.', 'nvarchar(35)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderAddress1') as Node(Id)
	select @DriverLicenceHolderAddress2=Node.Id.value('.', 'nvarchar(35)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderAddress2') as Node(Id)
	select @DriverLicenceHolderAddress3=Node.Id.value('.', 'nvarchar(35)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderAddress3') as Node(Id)
	select @DriverLicenceHolderAddress4=Node.Id.value('.', 'nvarchar(35)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderAddress4') as Node(Id)
	select @DriverLicenceHolderTown=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderTown') as Node(Id)
	select @DriverLicenceHolderCounty=Node.Id.value('.', 'nvarchar(20)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderCounty') as Node(Id)
	select @DriverLicenceHolderPostcode=Node.Id.value('.', 'varchar(10)') from @xml.nodes('/LetterDataEntry/DriverLicenceHolderPostcode') as Node(Id)
	select @DriverLicenceStatus=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/DriverLicenceStatus') as Node(Id)
	select @DriverLicenceExpireDate=Node.Id.value('.', 'varchar(20)') from @xml.nodes('/LetterDataEntry/DriverLicenceExpireDate') as Node(Id)
	select @DriverPpsn=Node.Id.value('.', 'varchar(20)') from @xml.nodes('/LetterDataEntry/DriverPpsn') as Node(Id)

	select @VehicleLicenceHolderId=Node.Id.value('number(.)', 'int') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderId') as Node(Id)
	select @VehicleLicenceHolderEmail=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderEmail') as Node(Id)
	select @VehicleLicenceNumber=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceNumber') as Node(Id)
	select @HistoricalVehicleLicenceNumber=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/HistoricalVehicleLicenceNumber') as Node(Id)
	select @VehicleRegistrationNumber=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/VehicleRegistrationNumber') as Node(Id)
	select @VehicleLicenceHolderFirstName=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderFirstName') as Node(Id)
	select @VehicleLicenceHolderLastName=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderLastName') as Node(Id)
	select @VehicleLicenceFullName=Node.Id.value('.', 'nvarchar(101)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderFullName') as Node(Id)
	select @VehicleLicenceHolderAddress1=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderAddress1') as Node(Id)
	select @VehicleLicenceHolderAddress2=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderAddress2') as Node(Id)
	select @VehicleLicenceHolderAddress3=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderAddress3') as Node(Id)
	select @VehicleLicenceHolderAddress4=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderAddress4') as Node(Id)
	select @VehicleLicenceHolderTown=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderTown') as Node(Id)
	select @VehicleLicenceHolderCounty=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderCounty') as Node(Id)
	select @VehicleLicenceHolderPostcode=Node.Id.value('.', 'nvarchar(50)') from @xml.nodes('/LetterDataEntry/VehicleLicenceHolderPostcode') as Node(Id)
	select @VehicleLicenceStatus=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/VehicleLicenceStatus') as Node(Id)
	select @VehicleLicenceExpireDate=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/VehicleLicenceExpireDate') as Node(Id)
	select @VehicleMake=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/VehicleMake') as Node(Id)
	select @VehicleModel=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/VehicleModel') as Node(Id)
	select @VehiclePpsn=Node.Id.value('.', 'nvarchar(20)') from @xml.nodes('/LetterDataEntry/VehiclePpsn') as Node(Id)

	select @LinkStartDate=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/LinkStartDate') as Node(Id)
	select @LinkEndDate=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/LinkEndDate') as Node(Id)	
	select @LinkMethod=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/LinkMethod') as Node(Id)
	select @IsLinkPerpetual=Node.Id.value('.', 'bit') from @xml.nodes('/LetterDataEntry/IsLinkPerpetual') as Node(Id)
	select @RentalStartDate=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/RentalStartDate') as Node(Id)
	select @RentalEndDate=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/RentalEndDate') as Node(Id)	
	select @RentalMethod=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/RentalMethod') as Node(Id)
	select @SpsvWebUrl=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/SpsvWebUrl') as Node(Id)
	select @SpsvRegistrationNumber=Node.Id.value('.', 'nvarchar(10)') from @xml.nodes('/LetterDataEntry/SpsvRegistrationNumber') as Node(Id)
	select @SpsvInvitationUrl=Node.Id.value('.', 'nvarchar(100)') from @xml.nodes('/LetterDataEntry/SpsvInvitationUrl') as Node(Id)
	select @SpsvEmailHtml=Node.Id.value('.', 'nvarchar(max)') from @xml.nodes('/LetterDataEntry/SpsvEmailHtml') as Node(Id)
	select @SpsvEmailItemId=Node.Id.value('.', 'nvarchar(max)') from @xml.nodes('/LetterDataEntry/SpsvEmailItemId') as Node(Id)
	select @SpsvSmsMessage=Node.Id.value('.', 'nvarchar(max)') from @xml.nodes('/LetterDataEntry/SpsvSmsMessage') as Node(Id)
	select @SpsvSmsPhoneNumber=Node.Id.value('.', 'nvarchar(max)') from @xml.nodes('/LetterDataEntry/SpsvSmsPhoneNumber') as Node(Id)

	insert into @Templates (Name, IsDl, IsVl,  DespatchMethodVL, DespatchMethodDL)
		select 
			x.value('TemplateName[1]', 'nvarchar(100)')
			,x.value('IsDl[1]', 'bit')
			,x.value('IsVl[1]', 'bit')
			,x.value('DespatchMethodVL[1]', 'int')
			,x.value('DespatchMethodDL[1]', 'int')
		from @xml.nodes('/LetterDataEntry/LetterTemplate') as Node(x)

	declare @TemplateName nvarchar(100);
	declare @IsDl bit;
	declare @IsVl bit;
	declare @LetterRequestTypeAuditId int;
	declare @LetterRequestTypeId int;
	declare @DespatchMethodVL int;
	declare @DespatchMethodDL int;

	declare templatesCursor cursor static for select Name, IsDl, IsVl, LetterRequestTypeAuditId, DespatchMethodVL, DespatchMethodDL from @Templates
	open templatesCursor   
	fetch next from templatesCursor into @TemplateName, @IsDl, @IsVl, @LetterRequestTypeAuditId, @DespatchMethodVL, @DespatchMethodDL
	while @@fetch_status = 0
	begin

			select top 1
				@LetterRequestTypeAuditId=a.LetterRequestTypeAuditId,
				@LetterRequestTypeId=a.LetterRequestTypeId
			from dbo.LetterRequestTypeVLAudit a
			inner join dbo.LetterRequestTypeVL rt on a.LetterRequestTypeId=rt.LetterRequestTypeId
			where rt.LetterCode=@TemplateName
			order by a.LetterRequestTypeAuditId desc

		if @IsDl=1
		begin
			insert into dl.LetterRequestMaster
				   ([LetterRequestStatusId]
				   ,[DeliveryDestinationId]
				   ,[DespatchMethodId]
				   ,[LicenceNumber]
				   ,[LicenceMasterId]
				   ,[FirstName]
				   ,[LastName]
				   ,[DriverAddress1]
				   ,[DriverAddress2]
				   ,[DriverAddress3]
				   ,[DriverCounty]
				   ,[DriverPostCode]
				   ,[ExpiryDate]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[ModifiedBy]
				   ,[ModifiedDate]
				   ,[Email]
				   ,[LetterRequestTypeVLAuditId]
				   ,[Town]
				   ,LicenceStatus
				   ,VehicleLicenceNumber
				   ,VehicleRegistrationNumber
				   ,LinkStartDate
				   ,LinkEndDate
				   ,LinkMethod
				   ,DriverLicenceHolderId
				   ,RentalStartDate
				   ,RentalEndDate
				   ,RentalMethod
				   ,SPSVWebUrl
				   ,Ppsn
				   ,SPSVRegistrationNumber
				   ,SPSVRegistrationUrl
				   ,SPSVEmailHtml
				   ,SPSVEmailItemId
				   ,HistoricalVehicleLicenceNumber
				   ,SPSVSmsMessage
				   ,SPSVSmsPhoneNumber
				   ,[LetterRequestTypeVLId]
				   ,LetterRequestTypeId
				   )
			 values
				   (isnull(@PrintRequestStatusId, 1)
				   ,1
				   ,@DespatchMethodDL
				   ,isnull(@DriverLicenceNumber, '')
				   ,@DriverLicenceId
				   ,isnull(@DriverLicenceHolderFirstName, '')
				   ,isnull(@DriverLicenceHolderLastName, '')
				   ,isnull(@DriverLicenceHolderAddress1, '')
				   ,@DriverLicenceHolderAddress2
				   ,@DriverLicenceHolderAddress3
				   ,isnull(@DriverLicenceHolderCounty, '')
				   ,@DriverLicenceHolderPostcode
				   ,isnull(@DriverLicenceExpireDate, '')
				   ,@CreatedBy
				   ,@NowDate
				   ,@CreatedBy
				   ,@NowDate
				   ,@DriverLicenceHolderEmail
				   ,@LetterRequestTypeAuditId
				   ,@DriverLicenceHolderTown
				   ,@DriverLicenceStatus
				   ,@VehicleLicenceNumber
				   ,@VehicleRegistrationNumber
				   ,@LinkStartDate
				   ,@LinkEndDate
				   ,@LinkMethod
				   ,@DriverLicenceHolderId
				   ,@RentalStartDate
				   ,@RentalEndDate
				   ,@RentalMethod
				   ,@SpsvWebUrl
				   ,@DriverPpsn
				   ,@SpsvRegistrationNumber
				   ,@SpsvInvitationUrl
				   ,@SpsvEmailHtml
				   ,@SpsvEmailItemId
				   ,@HistoricalVehicleLicenceNumber
				   ,@SpsvSmsMessage
				   ,@SpsvSmsPhoneNumber
				   ,@LetterRequestTypeId
				   ,3
				   )
				   select @@identity

				   SET @PrintRequestMasterId = SCOPE_IDENTITY()
            
            if @PrintRequestMasterId is null or @PrintRequestMasterId = 0
            begin
                Set @ErrorMessage = 'Unable to find PrintRequestMasterId after insertion.'
                Raiserror (@ErrorMessage, 16, 1)
            end
            

            INSERT INTO dl.LetterRequestDetail
                   (
                 [LetterRequestMasterId],
                   [LetterRequestStatusId],
                   [CreatedBy],
                   [CreatedDate],
                   [ModifiedBy],
                   [ModifiedDate],
				   Email
                   )
             VALUES
                   (
                   @PrintRequestMasterId,
                   isnull(@PrintRequestStatusId, 1),
                   @CreatedBy,
                   @NowDate,
                   @CreatedBy,
                   @NowDate,
                   @DriverLicenceHolderEmail
                   )
                   
            SET @PrintRequestId = SCOPE_IDENTITY()

            if @PrintRequestId is null or @PrintRequestId = 0
            begin
                Set @ErrorMessage = 'Unable to find PrintRequestId after insertion.'
                Raiserror (@ErrorMessage, 16, 1)
            end 
		end

		if @IsVl=1
		begin
			insert into [dbo].[PrintRequestMasterVL]
				   ([LetterRequestTypeAuditId]
				   ,[LicenceNumber]
				   ,[LetterDate]
				   ,[ExpiryDate]
				   ,[LicenceHolderId]
				   ,[HolderFirstName]
				   ,[HolderLastName]
				   ,[HolderCompanyName]
				   ,[HolderAddressLine1]
				   ,[HolderAddressLine2]
				   ,[HolderAddressLine3]
				   ,[HolderTown]
				   ,[HolderPostCode]
				   ,[HolderCounty]
				   ,[HolderEmail]
				   ,[VehicleRegNumber]
				   ,[VehicleMake]
				   ,[VehicleModel]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[ModifiedBy]
				   ,[ModifiedDate]
				   ,[LicenceStatus]
				   ,[VehicleRegistrationNumber]
				   ,[LinkStartDate]
				   ,[LinkEndDate]
				   ,[LinkMethod]
				   ,[DriverLicenceHolderId]
				   ,[DriverLicenceNumber]
				   ,RentalStartDate
				   ,RentalEndDate
				   ,RentalMethod
				   ,SPSVWebUrl
				   ,HolderPPSN
				   ,SPSVRegistrationNumber
				   ,SPSVRegistrationUrl
				   ,HistoricalVehicleLicenceNumber
				   )
			 values
				   (@LetterRequestTypeAuditId
				   ,@VehicleLicenceNumber
				   ,@NowDate
				   ,@VehicleLicenceExpireDate
				   ,@VehicleLicenceHolderId
				   ,@VehicleLicenceHolderFirstName
				   ,@VehicleLicenceHolderLastName
				   ,@VehicleLicenceFullName
				   ,@VehicleLicenceHolderAddress1
				   ,@VehicleLicenceHolderAddress2
				   ,@VehicleLicenceHolderAddress3
				   ,@VehicleLicenceHolderTown
				   ,@VehicleLicenceHolderPostcode
				   ,@VehicleLicenceHolderCounty
				   ,@VehicleLicenceHolderEmail
				   ,@VehicleRegistrationNumber
				   ,@VehicleMake
				   ,@VehicleModel
				   ,@CreatedBy
				   ,@NowDate
				   ,@CreatedBy
				   ,@NowDate
				   ,@VehicleLicenceStatus
				   ,@VehicleRegistrationNumber
				   ,@LinkStartDate
				   ,@LinkEndDate
				   ,@LinkMethod
				   ,@DriverLicenceHolderId
				   ,@DriverLicenceNumber
				   ,@RentalStartDate
				   ,@RentalEndDate
				   ,@RentalMethod
				   ,@SpsvWebUrl
				   ,@VehiclePpsn
				   ,@SpsvRegistrationNumber
				   ,@SpsvInvitationUrl
				   ,@HistoricalVehicleLicenceNumber
				   )

				    SET @PrintRequestMasterId = SCOPE_IDENTITY()
            
            if @PrintRequestMasterId is null or @PrintRequestMasterId = 0
            begin
                Set @ErrorMessage = 'Unable to find PrintRequestMasterId after insertion.'
                Raiserror (@ErrorMessage, 16, 1)
            end
            

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
                   1,
                   @PrintRequestReasonId,
                   @PrintCompanyId,
                   @CreatedBy,
                   @NowDate,
                   @CreatedBy,
                   @NowDate,
                   @DespatchMethodVL
                   )
                   
            SET @PrintRequestId = SCOPE_IDENTITY()

            if @PrintRequestId is null or @PrintRequestId = 0
            begin
                Set @ErrorMessage = 'Unable to find PrintRequestId after insertion.'
                Raiserror (@ErrorMessage, 16, 1)
            end 

		end

		fetch next from templatesCursor into @TemplateName, @IsDl, @IsVl, @LetterRequestTypeAuditId, @DespatchMethodVL, @DespatchMethodDL
	end
	close templatesCursor
	deallocate templatesCursor
	SET NOCOUNT OFF
	END



GO


