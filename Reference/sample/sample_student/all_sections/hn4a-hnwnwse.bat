dsadd user "cn=hnawns401,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnawns401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnawns402,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnawns402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn4a-hnwnwse,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn4a-hnwnwse,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnawns401,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local" "cn=hnawns402,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local"
