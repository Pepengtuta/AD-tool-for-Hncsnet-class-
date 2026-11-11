dsadd user "cn=istacap401,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istacap401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istacap402,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istacap402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist4a-cap102,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist4a-cap102,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istacap401,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local" "cn=istacap402,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local"
