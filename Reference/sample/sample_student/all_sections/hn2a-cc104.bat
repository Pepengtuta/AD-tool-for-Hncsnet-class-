dsadd user "cn=hnadsa201,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnadsa201 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnadsa202,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnadsa202 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn2a-cc104,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn2a-cc104,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnadsa201,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local" "cn=hnadsa202,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local"
