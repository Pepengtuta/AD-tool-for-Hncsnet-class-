dsadd user "cn=istactw101,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istactw101 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istactw102,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istactw102 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist1a-ct1,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist1a-ct1,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istactw101,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local" "cn=istactw102,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local"
