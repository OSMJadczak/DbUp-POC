use authService

DECLARE @pass NVARCHAR(max)
set @pass = (select password from jwtauth.Credentials where [Login]= 'mockadministrationtool')
if (@pass <> '04D31A99A948F85D69A673CEA9B23430')
BEGIN
    throw 51000, 'Diff password (mockadministrationtool).', 1;
end


set @pass = (select password from jwtauth.Credentials where [Login]= 'cabs')
if (@pass <> '04D31A99A948F85D69A673CEA9B23430')
BEGIN
    throw 51000, 'Diff password (cabs)', 1;
end

update jwtauth.Credentials
  set [Password] = '7F9193B2BD933838524D662C7327B2850B0D06FC429BCAD0195BE712185DBAAE'
  where [Login]= 'mockadministrationtool' or [Login] = 'cabs'




if ((select COUNT(distinct ApplicationPassword) from jwtauth.ApplicationSettings) <> 1)
BEGIN
    throw 51000, 'Used more than one password for all ApplicationPassword', 1;
END

set @pass = (select top 1 ApplicationPassword from jwtauth.ApplicationSettings)
if (@pass <> '04D31A99A948F85D69A673CEA9B23430')
BEGIN
    throw 51000, 'Diff password (ApplicationPassword)', 1;
end

update jwtauth.ApplicationSettings
  set [ApplicationPassword] = '7F9193B2BD933838524D662C7327B2850B0D06FC429BCAD0195BE712185DBAAE'
  