dsadd user "cn=hnasia301,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnasia301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnasia302,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnasia302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn3a-sia101,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn3a-sia101,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnasia301,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local" "cn=hnasia302,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local"
