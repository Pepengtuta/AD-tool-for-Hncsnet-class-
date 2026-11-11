dsadd user "cn=hnacth201,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnacth201 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnacth202,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnacth202 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn2a-ct3,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn2a-ct3,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnacth201,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local" "cn=hnacth202,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local"
