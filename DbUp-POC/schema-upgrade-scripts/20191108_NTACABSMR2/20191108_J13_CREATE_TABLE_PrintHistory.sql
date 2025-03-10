Create table cabs_sk.PrintHistory(
	Id int IDENTITY(1,1) PRIMARY KEY,
	TestId int not null,
	PrintSource nvarchar(20) not null,
	CreatedBy nvarchar(50) not null,
    CreatedOn datetime not null
);