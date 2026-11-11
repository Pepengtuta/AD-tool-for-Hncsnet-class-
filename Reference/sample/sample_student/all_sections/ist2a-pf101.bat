dsadd user "cn=istaoop201,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaoop201 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istaoop202,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaoop202 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist2a-pf101,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist2a-pf101,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istaoop201,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local" "cn=istaoop202,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local"
