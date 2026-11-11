dsadd user "cn=hnacap401,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnacap401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnacap402,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnacap402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn4a-cap102,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn4a-cap102,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnacap401,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local" "cn=hnacap402,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local"
