USE [cabs_production]
GO

/****** Object:  StoredProcedure [person].[update_opv_marshaller]    Script Date: 4/17/2020 1:16:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER procedure [person].[update_opv_marshaller] (
	@SourceSystem as varchar(3), 
	@Id as int, 
	@PersonType as varchar(20),
	@PersonStatus as varchar(20),
	@Ppsn as varchar(20), 
	@FirstName as nvarchar(50), 
	@LastName as nvarchar(50), 
	@CompanyName as nvarchar(100), 
	@CompanyNumber as int, 
	@TradingAs as nvarchar(100), 
	@DateOfBirth as date, 
	@MobilePhone as varchar(50), 
	@OtherPhone as varchar(50), 
	@Email as varchar(50), 
	@AddressLine1 as nvarchar(100), 
	@AddressLine2 as nvarchar(100), 
	@AddressLine3 as nvarchar(100), 
	@Irish as bit,
	@EirCode as varchar(7), 
	@PrefContactMethod as varchar(20), 
	@Town as nvarchar(50), 
	@PostCode as varchar(12), 
	@CountyId as nvarchar(20), 
	@CountryId as varchar(20), 
	@ModifiedBy as nvarchar(256), 
	@ModifiedOn as datetime, 
	@ETLId as int
	)
as
BEGIN

declare @ErrorNumber as int = NULL
declare @ErrorMessage as nvarchar(4000) = NULL

declare @PersonTypeId int = NULL
declare @PersonStatusId int = NULL
declare @ContactMethodId int = NULL
declare @PersonId int = NULL
declare @AddressId int = NULL
declare @EmailId int = NULL
declare @PhoneTypeId int = NULL
declare @Phone varchar(50) = NULL
declare @PhoneId int = NULL
declare @MobilePhoneSMSUsageId tinyint = NULL

declare @ccsn varchar(10) 
declare @ShortName as nvarchar(2)

declare @tally as table (N int) 
insert into @tally select top (100) row_number() over (order by @@spid) from sys.all_columns

BEGIN TRY
		BEGIN TRANSACTION;

		--PERSON TYPE
			IF not exists (select * from person.PersonType with (nolock) where PersonType=@PersonType)
				BEGIN
					set @ErrorNumber = 13001
					set @ErrorMessage = ('Not found ' + isnull(@PersonType, 'NULL') + ' in table person.PersonType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
					goto errorstatement
				END
			ELSE
				BEGIN
					select @PersonTypeId=PersonTypeId from person.PersonType with (nolock) where PersonType=@PersonType
				END

		--PERSON STATUS
			IF not exists (select * from person.PersonStatus with (nolock) where PersonStatus=@PersonStatus)
				BEGIN
					set @ErrorNumber = 13002
					set @ErrorMessage = ('Not found ' + isnull(@PersonStatus, 'NULL') + ' in table person.PersonStatus for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
					goto errorstatement
				END
			ELSE
				BEGIN
					select @PersonStatusId=PersonStatusId from person.PersonStatus with (nolock) where PersonStatus=@PersonStatus
				END

		--PrefContactMethod
		if @PrefContactMethod is not null
		begin
			IF not exists (select * from person.ContactMethod with (nolock) where ContactMethod=@PrefContactMethod)
				BEGIN
					set @ErrorNumber = 13004
					set @ErrorMessage = ('Not found ' + isnull(@PrefContactMethod, 'NULL') + ' in table person.ContactMethod for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
					goto errorstatement
				END
			ELSE
				BEGIN
					select @ContactMethodId=ContactMethodId from person.ContactMethod with (nolock) where ContactMethod=@PrefContactMethod
				END
		end
		else
		begin
			set @ContactMethodId = NULL
		end

		if @MobilePhone like '8%' and len(@MobilePhone)=9
			set @MobilePhone = '0'+@MobilePhone 

				declare @md datetime
				select @PersonId=PersonId, @md=isnull(ModifiedDate, CreatedDate) from Person.Person where PPSN=@PPSN

				if exists (select * from Person.Person where PersonId=@PersonId)
				BEGIN
					--check if persontype was changed
					declare @ChangedPersonType bit = NULL
					if @PersonTypeId!=(select PersonTypeId from person.person where PersonId=@PersonId)
					begin
						set @ChangedPersonType=1
						print 'Changed PersonType'
					end	
					
					UPDATE person.person set
						PersonTypeId=@PersonTypeId,
						PersonStatusId=@PersonStatusId,
						ContactMethodId=@ContactMethodId,
						ModifiedBy=@ModifiedBy,
						ModifiedDate=@ModifiedOn
					where PersonId=@PersonId

					IF @ChangedPersonType=1
						begin
							print 'Changed person type'
							delete from person.Company where PersonId=@PersonId
							delete from person.Individual where PersonId=@PersonId

							IF @PersonType = 'Company'
							BEGIN
								INSERT INTO person.Company
									select @PersonId, @CompanyName, @CompanyNumber, @TradingAs, @ModifiedBy, getdate(), NULL, NULL
							END
							ELSE IF @PersonType = 'Individual'
								BEGIN
									INSERT INTO person.Individual
										select @PersonId, @FirstName, @LastName, @DateOfBirth, @TradingAs, @ModifiedBy, getdate(), NULL, NULL
								END
						end
					ELSE
						IF @PersonType = 'Company'
							BEGIN
								UPDATE person.Company set
									CompanyName=@CompanyName, 
									CompanyNumber=@CompanyNumber, 
									TradingAs=@TradingAs, 
									ModifiedBy=@ModifiedBy,
									ModifiedDate=@ModifiedOn
								where PersonId=@PersonId 
								and (
									CompanyName!=@CompanyName or
									CompanyNumber!=@CompanyNumber or
									TradingAs!=@TradingAs
									)

							END
						ELSE IF @PersonType = 'Individual'
							BEGIN
								UPDATE person.Individual set
									FirstName=@FirstName, 
									LastName=@LastName, 
									DateOfBirth=@DateOfBirth, 
									TradingAs=@TradingAs, 
									ModifiedBy=@ModifiedBy,
									ModifiedDate=@ModifiedOn
								where PersonId=@PersonId
									and (
									FirstName!=@FirstName or 
									LastName!=@LastName or
									DateOfBirth!=@DateOfBirth or
									TradingAs!=@TradingAs
									)
							END

						--GEOGRAPHICAL
							--ADDRESS
							UPDATE person.Address set
								AddressLine1=@AddressLine1, 
								AddressLine2=@AddressLine2, 
								AddressLine3=@AddressLine3, 
								Town=@Town, 
								PostCode=@PostCode, 
								CountyId=@CountyId, 
								EirCode=@EirCode, 
								Irish=@Irish, 
								ModifiedBy=@ModifiedBy,
								ModifiedDate=@ModifiedOn
							where PersonId=@PersonId
								and (
								AddressLine1!=@AddressLine1 or
								AddressLine2!=@AddressLine2 or
								AddressLine3!=@AddressLine3 or
								Town!=@Town or
								PostCode!=@PostCode or
								CountyId!=@CountyId or
								EirCode!=@EirCode or
								Irish!=@Irish
								)

							--EMAIL
							if @Email is not null
							begin
								select TOP 1 @EmailId=[EmailId] from person.Email with (nolock) where PersonId=@PersonId

								update person.Email set
									Email=@Email, 
									ModifiedBy=@ModifiedBy,
									ModifiedDate=@ModifiedOn
								where EmailId=@EmailId;
							end
							else
							begin
								delete from person.Email where PersonId=@PersonId
							end

							--Phone
							select TOP 1 @PhoneTypeId=PhoneTypeId from person.PhoneType where PhoneType = 'Mobile'

							if(@MobilePhone IS NOT NULL and @MobilePhone <> '')
							BEGIN 
								IF (@PhoneTypeId IS NOT NULL)
								BEGIN
									print 'Updating Mobile Phone Number'

									IF not exists (select * from person.Phone with (nolock) where [PersonId]=@PersonId and [PhoneTypeId]=@PhoneTypeId)
									BEGIN
										INSERT INTO person.Phone
											select @PersonId, @MobilePhone, @PhoneTypeId, @ModifiedOn, getdate(), NULL, NULL

										set @PhoneId = (select scope_identity())
									END
									ELSE
									BEGIN
										declare @mobilePhoneId int = NULL;	

										select TOP 1 @mobilePhoneId=[PhoneId] from person.Phone with (nolock) 
										where [PersonId]=@PersonId and [PhoneTypeId]=@PhoneTypeId

										UPDATE person.Phone
										SET PhoneNumber = @MobilePhone
										WHERE [PhoneId]=@mobilePhoneId
									END
								END
								ELSE
								BEGIN
									set @ErrorNumber = 13015
									set @ErrorMessage = ('Not found Mobile in table person.PhoneType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
									goto errorstatement
								END
							END
							select @PhoneTypeId=PhoneTypeId from person.PhoneType where PhoneType = 'Home'

							if(@OtherPhone IS NOT NULL and @OtherPhone <> '')
							BEGIN 
								IF (@PhoneTypeId IS NOT NULL)
								BEGIN
									print 'Updating Home Phone Number'

									IF not exists (select * from person.Phone with (nolock) where [PersonId]=@PersonId and [PhoneTypeId]=@PhoneTypeId)
									BEGIN
										INSERT INTO person.Phone
											select @PersonId, @OtherPhone, @PhoneTypeId, @ModifiedOn, getdate(), NULL, NULL
									END
									ELSE
									BEGIN
										declare @otherPhoneId int = NULL;	

										select TOP 1 @otherPhoneId=[PhoneId] from person.Phone with (nolock) 
										where [PersonId]=@PersonId and [PhoneTypeId]=@PhoneTypeId

										UPDATE person.Phone
										SET PhoneNumber = @OtherPhone
										WHERE [PhoneId]=@otherPhoneId
									END
								END
								ELSE
								BEGIN
									set @ErrorNumber = 13007
									set @ErrorMessage = ('Not found Home Phone Type in table person.PhoneType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
									goto errorstatement
								END
							END
				END



		--set @ErrorNumber = 14000
	--select @ErrorNumber
	errorstatement:
		if @ErrorNumber is null
			COMMIT TRANSACTION;
		else
			begin
				ROLLBACK TRANSACTION;
				insert into cabs.cleansing.ErrorLog
				select 
					@ETLId, getdate(), 'proc_insert_to_ops', @ErrorNumber, @ErrorMessage, @SourceSystem, @id
			end
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION;
				
				insert into cabs.cleansing.ErrorLog
				select 
					@ETLId 'ETLId',  
					getdate() 'Date', 
					ERROR_PROCEDURE() 'ERROR_PROCEDURE', 
					case when @ErrorNumber is null then  ERROR_NUMBER() else @ErrorNumber end 'ERROR_NUMBER', 
					case when @ErrorMessage is null then ERROR_MESSAGE() else @ErrorMessage end 'ERROR_MESSAGE',
					@SourceSystem, 
					@id
				--into cleansing.ErrorLog
			END
	END CATCH;

END
GO


