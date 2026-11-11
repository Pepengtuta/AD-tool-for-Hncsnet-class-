dsadd user "cn=istaias401,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaias401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istaias402,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaias402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist4a-ias102,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist4a-ias102,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istaias401,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local" "cn=istaias402,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local"
