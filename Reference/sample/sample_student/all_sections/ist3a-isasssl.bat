dsadd user "cn=istaasl301,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaasl301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=istaasl302,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln istaasl302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=ist3a-isasssl,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=ist3a-isasssl,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local" -addmbr "cn=istaasl301,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local" "cn=istaasl302,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local"
