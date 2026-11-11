dsadd user "cn=istacp101,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istacp101 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istacp102,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istacp102 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist1a-cc102,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist1a-cc102,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istacp101,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local" "cn=istacp102,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local"
