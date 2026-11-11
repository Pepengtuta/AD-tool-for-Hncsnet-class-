dsadd user "cn=hnactw101,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnactw101 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnactw102,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnactw102 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn1a-ct1,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn1a-ct1,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnactw101,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local" "cn=hnactw102,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local"
