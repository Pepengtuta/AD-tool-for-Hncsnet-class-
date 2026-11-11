dsadd user "cn=istaept201,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaept201 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istaept202,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaept202 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist2a-isedpat,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist2a-isedpat,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istaept201,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local" "cn=istaept202,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local"
