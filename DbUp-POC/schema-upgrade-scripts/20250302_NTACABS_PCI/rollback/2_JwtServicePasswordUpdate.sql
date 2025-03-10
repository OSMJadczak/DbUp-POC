use authService

update jwtauth.Credentials
  set [Password] = '04D31A99A948F85D69A673CEA9B23430'
  where [Login]= 'mockadministrationtool' or [Login] = 'cabs'


update jwtauth.ApplicationSettings
  set [ApplicationPassword] = '04D31A99A948F85D69A673CEA9B23430'