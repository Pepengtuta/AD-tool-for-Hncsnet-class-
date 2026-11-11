dsadd user "cn=istatdt401,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istatdt401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istatdt402,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istatdt402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist4a-istwdev,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist4a-istwdev,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istatdt401,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local" "cn=istatdt402,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local"
