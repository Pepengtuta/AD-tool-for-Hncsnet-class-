@echo off

dsadd ou "ou=students,dc=asukalibo,dc=local"

dsadd ou "ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn3a-net102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn3a-im101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist3a-net102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist3a-im101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local"
dsadd ou "ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local"

echo OU structure created.
echo.

call "hn1a-cc101.bat"
echo hn1a-cc101.bat is done
call "hn1a-ct1.bat"
echo hn1a-ct1.bat is done
call "hn1a-cc102.bat"
echo hn1a-cc102.bat is done
call "hn2a-cc104.bat"
echo hn2a-cc104.bat is done
call "hn2a-ct3.bat"
echo hn2a-ct3.bat is done
call "hn2a-pf101.bat"
echo hn2a-pf101.bat is done
call "hn3a-net102.bat"
echo hn3a-net102.bat is done
call "hn3a-ct5.bat"
echo hn3a-ct5.bat is done
call "hn3a-hnrsawt.bat"
echo hn3a-hnrsawt.bat is done
call "hn3a-sia101.bat"
echo hn3a-sia101.bat is done
call "hn3a-im101.bat"
echo hn3a-im101.bat is done
call "hn4a-cap102.bat"
echo hn4a-cap102.bat is done
call "hn4a-hnwnwse.bat"
echo hn4a-hnwnwse.bat is done
call "hn4a-ias102.bat"
echo hn4a-ias102.bat is done
call "hn4a-sa101.bat"
echo hn4a-sa101.bat is done
call "ist1a-cc101.bat"
echo ist1a-cc101.bat is done
call "ist1a-cc102.bat"
echo ist1a-cc102.bat is done
call "ist1a-ct1.bat"
echo ist1a-ct1.bat is done
call "ist2a-isedpat.bat"
echo ist2a-isedpat.bat is done
call "ist2a-pf101.bat"
echo ist2a-pf101.bat is done
call "ist2a-cc104.bat"
echo ist2a-cc104.bat is done
call "ist2a-ct3.bat"
echo ist2a-ct3.bat is done
call "ist3a-net102.bat"
echo ist3a-net102.bat is done
call "ist3a-sia101.bat"
echo ist3a-sia101.bat is done
call "ist3a-im101.bat"
echo ist3a-im101.bat is done
call "ist3a-isasssl.bat"
echo ist3a-isasssl.bat is done
call "ist3a-ct5.bat"
echo ist3a-ct5.bat is done
call "ist4a-sa101.bat"
echo ist4a-sa101.bat is done
call "ist4a-ias102.bat"
echo ist4a-ias102.bat is done
call "ist4a-cap102.bat"
echo ist4a-cap102.bat is done
call "ist4a-istwdev.bat"
echo ist4a-istwdev.bat is done

call "groups.bat"
echo groups.bat is done

echo ===== ALL DONE =====
pause
