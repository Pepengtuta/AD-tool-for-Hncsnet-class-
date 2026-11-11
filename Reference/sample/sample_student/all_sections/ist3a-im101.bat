dsadd user "cn=istaads301,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaads301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istaads302,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaads302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist3a-im101,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist3a-im101,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istaads301,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local" "cn=istaads302,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local"
