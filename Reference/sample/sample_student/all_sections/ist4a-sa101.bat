dsadd user "cn=istasam401,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istasam401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istasam402,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istasam402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist4a-sa101,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist4a-sa101,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istasam401,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local" "cn=istasam402,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local"
