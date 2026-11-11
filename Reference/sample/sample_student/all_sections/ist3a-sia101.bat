dsadd user "cn=istasia301,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istasia301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istasia302,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istasia302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist3a-sia101,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist3a-sia101,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istasia301,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local" "cn=istasia302,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local"
