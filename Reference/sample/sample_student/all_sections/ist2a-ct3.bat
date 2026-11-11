dsadd user "cn=istacth201,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istacth201 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istacth202,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istacth202 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist2a-ct3,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist2a-ct3,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istacth201,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local" "cn=istacth202,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local"
