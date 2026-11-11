dsadd user "cn=hnarst301,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnarst301 -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=hnarst302,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local" -fn Lab9 -ln hnarst302 -pwd p@ssw0rd -mustchpwd yes
dsadd group "cn=hn3a-hnrsawt,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local" -secgrp yes -scope g
dsmod group "cn=hn3a-hnrsawt,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local" -addmbr "cn=hnarst301,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local" "cn=hnarst302,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local"
