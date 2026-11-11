dsadd user "cn=hnanet301,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnanet301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnanet302,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnanet302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn3a-net102,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn3a-net102,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnanet301,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local" "cn=hnanet302,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local"
