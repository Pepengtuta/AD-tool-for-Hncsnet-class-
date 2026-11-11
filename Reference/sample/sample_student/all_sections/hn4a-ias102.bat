dsadd user "cn=hnaias401,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnaias401 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnaias402,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnaias402 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn4a-ias102,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn4a-ias102,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnaias401,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local" "cn=hnaias402,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local"
