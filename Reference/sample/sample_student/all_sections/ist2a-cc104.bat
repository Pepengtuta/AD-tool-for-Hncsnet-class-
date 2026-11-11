dsadd user "cn=istadsa201,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istadsa201 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istadsa202,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istadsa202 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist2a-cc104,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist2a-cc104,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istadsa201,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local" "cn=istadsa202,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local"
