dsadd user "cn=istainc101,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istainc101 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istainc102,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istainc102 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist1a-cc101,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist1a-cc101,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istainc101,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local" "cn=istainc102,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local"
