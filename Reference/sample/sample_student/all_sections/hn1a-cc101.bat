dsadd user "cn=hnainc101,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnainc101 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnainc102,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnainc102 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn1a-cc101,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn1a-cc101,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnainc101,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local" "cn=hnainc102,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local"
