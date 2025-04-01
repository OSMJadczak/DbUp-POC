USE [cabs_production]
GO
/****** Object:  StoredProcedure [dbo].[RPT_All_Licences]    Script Date: 7/10/2020 12:19:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create or ALTER    PROCEDURE [dbo].[RPT_AllFutureBookings]


AS
BEGIN
	SET NOCOUNT ON;

select 
lmvl.LicenceNumber,
vm.RegistrationNumber,
b.BookingId as 'Booking ref Number',
lhm.HolderName ,
--lhm.CompanyName,
lhm.AddressLine1,
lhm.AddressLine2,
lhm.AddressLine3,
lhm.Town,
c.CountyName,
lhm.PostCode,
lhm.PhoneNo1,
lhm.PhoneNo2,
FORMAT( CONVERT(date, b.BookingDateTime),'yyyy/MM/dd')as 'BookingDate' ,
convert(time(0),  b.BookingDateTime)as 'BookingTime' ,
bs.BookingStatusName,
tc.TestCentreName,
tcl.TestCentreLaneName,
FORMAT( CONVERT(date,b.CreatedDate),'yyyy/MM/dd')as 'CreatedDate',
sys.ProcessName,
ip.Description as 'InspectionProcess',
iType.Description as 'InspectionType' ,
b.CreatedBy as 'Agent',
convert (nvarchar(50), vm.NctSerialNumber) as 'NctSerialNumber',
FORMAT( CONVERT(date,vm.NctIssueDate),'yyyy/MM/dd')as 'NctIssueDate',
FORMAT( CONVERT(date,vm.NctExpiryDate),'yyyy/MM/dd')as 'NctExpiryDate',
 case when  pm.PaymentMethodName is null and lmvl.LicenceStateId in (3,10,17)
 then 
 (select top(1) pm.PaymentMethodName from dbo.PaymentVL pvl 
join dbo.PaymentMethod pm on pm.PaymentMethodId = pvl.PaymentMethodId
where pvl.LicenceNumber = lmvl.LicenceNumber and pvl.ServiceTypeId = 7 
 order by pvl.ModifiedDate desc )
 else 
 pm.PaymentMethodName 
 end 
 as 'PaymentType'

from dbo.Booking b 
 join dbo.BookingStatus bs on bs.BookingStatusId = b.BookingStatusId
join dbo.LicenceMasterVL lmvl on lmvl.LicenceNumber = b.LicenceNumber
join dbo.VehicleMaster vm on vm.RegistrationNumber = lmvl.RegistrationNumber
join dbo.LicenceHolderMaster lhm on lmvl.LicenceHolderId = lhm.LicenceHolderId
left join dbo.BookingPayment bp on bp.BookingId = b.BookingId
left join dbo.PaymentVL pvl on bp.PaymentId = pvl.PaymentId
left join dbo.PaymentMethod pm on pm.PaymentMethodId = pvl.PaymentMethodId
left join dbo.County c on c.CountyId = lhm.CountyId
left join dbo.TestCentre tc on tc.TestCentreId = b.TestCentreId
left join dbo.TestCentreLanes tcl on tcl.TestCentreLaneId = b.TestCentreLaneId
left join dbo.SystemProcessVL sys on sys.SystemProcessId = b.SystemProcessId
left join dbo.InspectionTime it on it.InspectionTimeId = b.InspectionTimeId
left join dbo.InspectionProcess ip on it.InspectionProcessId = ip.InspectionProcessId
left join dbo.InspectionType iType on iType.InspectionTypeId = it.InspectionTypeId
where 
b.BookingDateTime > cast (CAST( GETDATE() AS Date ) as datetime) 
order by vm.RegistrationNumber




SET NOCOUNT OFF

END
