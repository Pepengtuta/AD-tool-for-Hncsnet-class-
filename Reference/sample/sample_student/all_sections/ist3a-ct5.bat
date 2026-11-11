dsadd user "cn=istactp301,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istactp301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istactp302,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istactp302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist3a-ct5,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist3a-ct5,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istactp301,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local" "cn=istactp302,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local"
