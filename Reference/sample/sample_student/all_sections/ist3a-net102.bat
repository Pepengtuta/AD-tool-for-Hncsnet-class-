dsadd user "cn=istanet301,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istanet301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istanet302,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istanet302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist3a-net102,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist3a-net102,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istanet301,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local" "cn=istanet302,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local"
