dsadd user "cn=hnaoop201,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnaoop201 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnaoop202,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnaoop202 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn2a-pf101,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn2a-pf101,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnaoop201,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local" "cn=hnaoop202,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local"
