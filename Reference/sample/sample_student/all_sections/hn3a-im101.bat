dsadd user "cn=hnaads301,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnaads301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnaads302,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnaads302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn3a-im101,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn3a-im101,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnaads301,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local" "cn=hnaads302,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local"
