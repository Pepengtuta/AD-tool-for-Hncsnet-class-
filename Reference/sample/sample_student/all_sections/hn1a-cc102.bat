dsadd user "cn=hnacp101,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnacp101 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnacp102,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnacp102 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn1a-cc102,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn1a-cc102,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnacp101,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local" "cn=hnacp102,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local"
