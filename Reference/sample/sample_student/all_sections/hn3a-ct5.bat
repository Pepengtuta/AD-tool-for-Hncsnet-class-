dsadd user "cn=hnactp301,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnactp301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnactp302,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnactp302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn3a-ct5,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn3a-ct5,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnactp301,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local" "cn=hnactp302,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local"
