dsadd user "cn=hnasam401,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnasam401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnasam402,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnasam402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn4a-sa101,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn4a-sa101,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnasam401,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local" "cn=hnasam402,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local"
