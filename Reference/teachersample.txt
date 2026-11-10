@echo off
dsadd ou "ou=teachers,dc=asukalibo,dc=local"
dsadd user "cn=juan,ou=teachers,dc=asukalibo,dc=local" -fn Juan -ln Dela_Cruz -pwd p@ssw0rd -mustchpwd yes

dsadd user "cn=Angelika,ou=teachers,dc=asukalibo,dc=local" -fn Angelika -ln Gervacio -pwd p@ssw0rd -mustchpwd yes
dsadd user "cn=kathleen,ou=teachers,dc=asukalibo,dc=local" -fn "Kathleen joy" -ln Trinidad -pwd p@ssw0rd -mustchpwd yes

dsadd user "cn=Chrystler,ou=teachers,dc=asukalibo,dc=local" -fn Chrystler -ln Orbien -pwd p@ssw0rd -mustchpwd yes
pause