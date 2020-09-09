set global validate_password.policy=0;
SHOW VARIABLES LIKE 'validate_password%';
set global validate_password.length=6;
set global validate_password.special_char_count=0;
set global validate_password.mixed_case_count=0;
alter user root@localhost identified by 'drh123';
create database django_bbs;
create user work identified by 'drh123';
grant all on django_bbs.* to 'work'@'%' with grant option;
