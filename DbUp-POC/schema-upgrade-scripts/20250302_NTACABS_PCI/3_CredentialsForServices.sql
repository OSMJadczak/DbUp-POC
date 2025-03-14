use authService

insert into [jwtauth].[Permissions]
(id, name)
values
('de6f5c73-83c5-4106-9820-41db8d427699', 'audit-follower.all')


insert into jwtauth.Credentials (id, [Login], [Password])
values
('f2694c58-aceb-44fa-a8fa-4a007f670c16', 'PersonView', CONVERT(VARCHAR(max), HashBytes('SHA2_256', 'my-person-view-password'), 2))
insert into jwtauth.CredentialsPermissions
(CredentialsId, PermissionsId)
values
('f2694c58-aceb-44fa-a8fa-4a007f670c16', 'de6f5c73-83c5-4106-9820-41db8d427699')

insert into jwtauth.Credentials (id, [Login], [Password])
values
('1f90e46a-faac-46c5-9fb0-81930e1a9d99', 'DL', CONVERT(VARCHAR(max), HashBytes('SHA2_256', 'my-dl-password'), 2))
insert into jwtauth.CredentialsPermissions
(CredentialsId, PermissionsId)
values
('1f90e46a-faac-46c5-9fb0-81930e1a9d99', 'de6f5c73-83c5-4106-9820-41db8d427699')


insert into jwtauth.Credentials (id, [Login], [Password])
values
('8683473a-baa0-4710-aede-40cb3989e6c8', 'Enforcement', CONVERT(VARCHAR(max), HashBytes('SHA2_256', 'my-enforcement-password'), 2))
insert into jwtauth.CredentialsPermissions
(CredentialsId, PermissionsId)
values
('8683473a-baa0-4710-aede-40cb3989e6c8', 'de6f5c73-83c5-4106-9820-41db8d427699')



-- 'Cabs' login: SPSV Online, Online Register, Public Register
-- Note: OnlineRegister and Public Register are using same login for now
insert into jwtauth.CredentialsPermissions
(CredentialsId, PermissionsId)
values
((select Id from jwtAuth.Credentials where login = 'Cabs'), 'de6f5c73-83c5-4106-9820-41db8d427699')