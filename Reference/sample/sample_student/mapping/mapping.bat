@echo off
setlocal enabledelayedexpansion

REM ===== CONFIG =====
set SHAREPATH=\\DC1\26271stSem
set DOMAIN=asukalibo
set HOMEDRIVE=H:

REM ===== SECTION: hn1a-cc101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn1a-cc101" mkdir "%SHAREPATH%\hn1a-cc101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn1a-cc101" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn1a-cc101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn1a-cc101\Common" mkdir "%SHAREPATH%\hn1a-cc101\Common"
icacls "%SHAREPATH%\hn1a-cc101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn1a-cc101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnainc101 ---
if not exist "%SHAREPATH%\hn1a-cc101\hnainc101" mkdir "%SHAREPATH%\hn1a-cc101\hnainc101"
icacls "%SHAREPATH%\hn1a-cc101\hnainc101" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc101\hnainc101" /grant "%DOMAIN%\hnainc101:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc101\hnainc101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc101\hnainc101" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnainc101,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn1a-cc101" -hmdrv %HOMEDRIVE%
echo DONE: hnainc101
echo ------------------------------

REM --- User: hnainc102 ---
if not exist "%SHAREPATH%\hn1a-cc101\hnainc102" mkdir "%SHAREPATH%\hn1a-cc101\hnainc102"
icacls "%SHAREPATH%\hn1a-cc101\hnainc102" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc101\hnainc102" /grant "%DOMAIN%\hnainc102:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc101\hnainc102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc101\hnainc102" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnainc102,ou=hn1a-cc101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn1a-cc101" -hmdrv %HOMEDRIVE%
echo DONE: hnainc102
echo ------------------------------

REM ===== SECTION: hn1a-ct1 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn1a-ct1" mkdir "%SHAREPATH%\hn1a-ct1"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn1a-ct1" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-ct1" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn1a-ct1" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-ct1" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn1a-ct1\Common" mkdir "%SHAREPATH%\hn1a-ct1\Common"
icacls "%SHAREPATH%\hn1a-ct1\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-ct1\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn1a-ct1\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-ct1\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnactw101 ---
if not exist "%SHAREPATH%\hn1a-ct1\hnactw101" mkdir "%SHAREPATH%\hn1a-ct1\hnactw101"
icacls "%SHAREPATH%\hn1a-ct1\hnactw101" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-ct1\hnactw101" /grant "%DOMAIN%\hnactw101:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-ct1\hnactw101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-ct1\hnactw101" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnactw101,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn1a-ct1" -hmdrv %HOMEDRIVE%
echo DONE: hnactw101
echo ------------------------------

REM --- User: hnactw102 ---
if not exist "%SHAREPATH%\hn1a-ct1\hnactw102" mkdir "%SHAREPATH%\hn1a-ct1\hnactw102"
icacls "%SHAREPATH%\hn1a-ct1\hnactw102" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-ct1\hnactw102" /grant "%DOMAIN%\hnactw102:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-ct1\hnactw102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-ct1\hnactw102" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnactw102,ou=hn1a-ct1,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn1a-ct1" -hmdrv %HOMEDRIVE%
echo DONE: hnactw102
echo ------------------------------

REM ===== SECTION: hn1a-cc102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn1a-cc102" mkdir "%SHAREPATH%\hn1a-cc102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn1a-cc102" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn1a-cc102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn1a-cc102\Common" mkdir "%SHAREPATH%\hn1a-cc102\Common"
icacls "%SHAREPATH%\hn1a-cc102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn1a-cc102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnacp101 ---
if not exist "%SHAREPATH%\hn1a-cc102\hnacp101" mkdir "%SHAREPATH%\hn1a-cc102\hnacp101"
icacls "%SHAREPATH%\hn1a-cc102\hnacp101" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc102\hnacp101" /grant "%DOMAIN%\hnacp101:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc102\hnacp101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc102\hnacp101" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnacp101,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn1a-cc102" -hmdrv %HOMEDRIVE%
echo DONE: hnacp101
echo ------------------------------

REM --- User: hnacp102 ---
if not exist "%SHAREPATH%\hn1a-cc102\hnacp102" mkdir "%SHAREPATH%\hn1a-cc102\hnacp102"
icacls "%SHAREPATH%\hn1a-cc102\hnacp102" /inheritance:r >nul
icacls "%SHAREPATH%\hn1a-cc102\hnacp102" /grant "%DOMAIN%\hnacp102:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc102\hnacp102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn1a-cc102\hnacp102" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnacp102,ou=hn1a-cc102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn1a-cc102" -hmdrv %HOMEDRIVE%
echo DONE: hnacp102
echo ------------------------------

REM ===== SECTION: hn2a-cc104 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn2a-cc104" mkdir "%SHAREPATH%\hn2a-cc104"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn2a-cc104" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-cc104" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn2a-cc104" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-cc104" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn2a-cc104\Common" mkdir "%SHAREPATH%\hn2a-cc104\Common"
icacls "%SHAREPATH%\hn2a-cc104\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-cc104\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn2a-cc104\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-cc104\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnadsa201 ---
if not exist "%SHAREPATH%\hn2a-cc104\hnadsa201" mkdir "%SHAREPATH%\hn2a-cc104\hnadsa201"
icacls "%SHAREPATH%\hn2a-cc104\hnadsa201" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-cc104\hnadsa201" /grant "%DOMAIN%\hnadsa201:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-cc104\hnadsa201" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-cc104\hnadsa201" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnadsa201,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn2a-cc104" -hmdrv %HOMEDRIVE%
echo DONE: hnadsa201
echo ------------------------------

REM --- User: hnadsa202 ---
if not exist "%SHAREPATH%\hn2a-cc104\hnadsa202" mkdir "%SHAREPATH%\hn2a-cc104\hnadsa202"
icacls "%SHAREPATH%\hn2a-cc104\hnadsa202" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-cc104\hnadsa202" /grant "%DOMAIN%\hnadsa202:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-cc104\hnadsa202" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-cc104\hnadsa202" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnadsa202,ou=hn2a-cc104,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn2a-cc104" -hmdrv %HOMEDRIVE%
echo DONE: hnadsa202
echo ------------------------------

REM ===== SECTION: hn2a-ct3 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn2a-ct3" mkdir "%SHAREPATH%\hn2a-ct3"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn2a-ct3" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-ct3" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn2a-ct3" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-ct3" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn2a-ct3\Common" mkdir "%SHAREPATH%\hn2a-ct3\Common"
icacls "%SHAREPATH%\hn2a-ct3\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-ct3\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn2a-ct3\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-ct3\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnacth201 ---
if not exist "%SHAREPATH%\hn2a-ct3\hnacth201" mkdir "%SHAREPATH%\hn2a-ct3\hnacth201"
icacls "%SHAREPATH%\hn2a-ct3\hnacth201" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-ct3\hnacth201" /grant "%DOMAIN%\hnacth201:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-ct3\hnacth201" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-ct3\hnacth201" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnacth201,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn2a-ct3" -hmdrv %HOMEDRIVE%
echo DONE: hnacth201
echo ------------------------------

REM --- User: hnacth202 ---
if not exist "%SHAREPATH%\hn2a-ct3\hnacth202" mkdir "%SHAREPATH%\hn2a-ct3\hnacth202"
icacls "%SHAREPATH%\hn2a-ct3\hnacth202" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-ct3\hnacth202" /grant "%DOMAIN%\hnacth202:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-ct3\hnacth202" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-ct3\hnacth202" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnacth202,ou=hn2a-ct3,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn2a-ct3" -hmdrv %HOMEDRIVE%
echo DONE: hnacth202
echo ------------------------------

REM ===== SECTION: hn2a-pf101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn2a-pf101" mkdir "%SHAREPATH%\hn2a-pf101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn2a-pf101" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-pf101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn2a-pf101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-pf101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn2a-pf101\Common" mkdir "%SHAREPATH%\hn2a-pf101\Common"
icacls "%SHAREPATH%\hn2a-pf101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-pf101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn2a-pf101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-pf101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnaoop201 ---
if not exist "%SHAREPATH%\hn2a-pf101\hnaoop201" mkdir "%SHAREPATH%\hn2a-pf101\hnaoop201"
icacls "%SHAREPATH%\hn2a-pf101\hnaoop201" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-pf101\hnaoop201" /grant "%DOMAIN%\hnaoop201:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-pf101\hnaoop201" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-pf101\hnaoop201" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnaoop201,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn2a-pf101" -hmdrv %HOMEDRIVE%
echo DONE: hnaoop201
echo ------------------------------

REM --- User: hnaoop202 ---
if not exist "%SHAREPATH%\hn2a-pf101\hnaoop202" mkdir "%SHAREPATH%\hn2a-pf101\hnaoop202"
icacls "%SHAREPATH%\hn2a-pf101\hnaoop202" /inheritance:r >nul
icacls "%SHAREPATH%\hn2a-pf101\hnaoop202" /grant "%DOMAIN%\hnaoop202:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-pf101\hnaoop202" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn2a-pf101\hnaoop202" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnaoop202,ou=hn2a-pf101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn2a-pf101" -hmdrv %HOMEDRIVE%
echo DONE: hnaoop202
echo ------------------------------

REM ===== SECTION: hn3a-net102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn3a-net102" mkdir "%SHAREPATH%\hn3a-net102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn3a-net102" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-net102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-net102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-net102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn3a-net102\Common" mkdir "%SHAREPATH%\hn3a-net102\Common"
icacls "%SHAREPATH%\hn3a-net102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-net102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-net102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-net102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnanet301 ---
if not exist "%SHAREPATH%\hn3a-net102\hnanet301" mkdir "%SHAREPATH%\hn3a-net102\hnanet301"
icacls "%SHAREPATH%\hn3a-net102\hnanet301" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-net102\hnanet301" /grant "%DOMAIN%\hnanet301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-net102\hnanet301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-net102\hnanet301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnanet301,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-net102" -hmdrv %HOMEDRIVE%
echo DONE: hnanet301
echo ------------------------------

REM --- User: hnanet302 ---
if not exist "%SHAREPATH%\hn3a-net102\hnanet302" mkdir "%SHAREPATH%\hn3a-net102\hnanet302"
icacls "%SHAREPATH%\hn3a-net102\hnanet302" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-net102\hnanet302" /grant "%DOMAIN%\hnanet302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-net102\hnanet302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-net102\hnanet302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnanet302,ou=hn3a-net102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-net102" -hmdrv %HOMEDRIVE%
echo DONE: hnanet302
echo ------------------------------

REM ===== SECTION: hn3a-ct5 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn3a-ct5" mkdir "%SHAREPATH%\hn3a-ct5"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn3a-ct5" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-ct5" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-ct5" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-ct5" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn3a-ct5\Common" mkdir "%SHAREPATH%\hn3a-ct5\Common"
icacls "%SHAREPATH%\hn3a-ct5\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-ct5\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-ct5\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-ct5\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnactp301 ---
if not exist "%SHAREPATH%\hn3a-ct5\hnactp301" mkdir "%SHAREPATH%\hn3a-ct5\hnactp301"
icacls "%SHAREPATH%\hn3a-ct5\hnactp301" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-ct5\hnactp301" /grant "%DOMAIN%\hnactp301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-ct5\hnactp301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-ct5\hnactp301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnactp301,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-ct5" -hmdrv %HOMEDRIVE%
echo DONE: hnactp301
echo ------------------------------

REM --- User: hnactp302 ---
if not exist "%SHAREPATH%\hn3a-ct5\hnactp302" mkdir "%SHAREPATH%\hn3a-ct5\hnactp302"
icacls "%SHAREPATH%\hn3a-ct5\hnactp302" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-ct5\hnactp302" /grant "%DOMAIN%\hnactp302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-ct5\hnactp302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-ct5\hnactp302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnactp302,ou=hn3a-ct5,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-ct5" -hmdrv %HOMEDRIVE%
echo DONE: hnactp302
echo ------------------------------

REM ===== SECTION: hn3a-hnrsawt =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn3a-hnrsawt" mkdir "%SHAREPATH%\hn3a-hnrsawt"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn3a-hnrsawt" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-hnrsawt" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn3a-hnrsawt\Common" mkdir "%SHAREPATH%\hn3a-hnrsawt\Common"
icacls "%SHAREPATH%\hn3a-hnrsawt\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnarst301 ---
if not exist "%SHAREPATH%\hn3a-hnrsawt\hnarst301" mkdir "%SHAREPATH%\hn3a-hnrsawt\hnarst301"
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst301" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst301" /grant "%DOMAIN%\hnarst301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnarst301,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-hnrsawt" -hmdrv %HOMEDRIVE%
echo DONE: hnarst301
echo ------------------------------

REM --- User: hnarst302 ---
if not exist "%SHAREPATH%\hn3a-hnrsawt\hnarst302" mkdir "%SHAREPATH%\hn3a-hnrsawt\hnarst302"
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst302" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst302" /grant "%DOMAIN%\hnarst302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-hnrsawt\hnarst302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnarst302,ou=hn3a-hnrsawt,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-hnrsawt" -hmdrv %HOMEDRIVE%
echo DONE: hnarst302
echo ------------------------------

REM ===== SECTION: hn3a-sia101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn3a-sia101" mkdir "%SHAREPATH%\hn3a-sia101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn3a-sia101" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-sia101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-sia101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-sia101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn3a-sia101\Common" mkdir "%SHAREPATH%\hn3a-sia101\Common"
icacls "%SHAREPATH%\hn3a-sia101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-sia101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-sia101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-sia101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnasia301 ---
if not exist "%SHAREPATH%\hn3a-sia101\hnasia301" mkdir "%SHAREPATH%\hn3a-sia101\hnasia301"
icacls "%SHAREPATH%\hn3a-sia101\hnasia301" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-sia101\hnasia301" /grant "%DOMAIN%\hnasia301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-sia101\hnasia301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-sia101\hnasia301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnasia301,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-sia101" -hmdrv %HOMEDRIVE%
echo DONE: hnasia301
echo ------------------------------

REM --- User: hnasia302 ---
if not exist "%SHAREPATH%\hn3a-sia101\hnasia302" mkdir "%SHAREPATH%\hn3a-sia101\hnasia302"
icacls "%SHAREPATH%\hn3a-sia101\hnasia302" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-sia101\hnasia302" /grant "%DOMAIN%\hnasia302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-sia101\hnasia302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-sia101\hnasia302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnasia302,ou=hn3a-sia101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-sia101" -hmdrv %HOMEDRIVE%
echo DONE: hnasia302
echo ------------------------------

REM ===== SECTION: hn3a-im101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn3a-im101" mkdir "%SHAREPATH%\hn3a-im101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn3a-im101" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-im101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-im101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-im101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn3a-im101\Common" mkdir "%SHAREPATH%\hn3a-im101\Common"
icacls "%SHAREPATH%\hn3a-im101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-im101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn3a-im101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-im101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnaads301 ---
if not exist "%SHAREPATH%\hn3a-im101\hnaads301" mkdir "%SHAREPATH%\hn3a-im101\hnaads301"
icacls "%SHAREPATH%\hn3a-im101\hnaads301" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-im101\hnaads301" /grant "%DOMAIN%\hnaads301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-im101\hnaads301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-im101\hnaads301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnaads301,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-im101" -hmdrv %HOMEDRIVE%
echo DONE: hnaads301
echo ------------------------------

REM --- User: hnaads302 ---
if not exist "%SHAREPATH%\hn3a-im101\hnaads302" mkdir "%SHAREPATH%\hn3a-im101\hnaads302"
icacls "%SHAREPATH%\hn3a-im101\hnaads302" /inheritance:r >nul
icacls "%SHAREPATH%\hn3a-im101\hnaads302" /grant "%DOMAIN%\hnaads302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-im101\hnaads302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn3a-im101\hnaads302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnaads302,ou=hn3a-im101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn3a-im101" -hmdrv %HOMEDRIVE%
echo DONE: hnaads302
echo ------------------------------

REM ===== SECTION: hn4a-cap102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn4a-cap102" mkdir "%SHAREPATH%\hn4a-cap102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn4a-cap102" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-cap102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-cap102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-cap102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn4a-cap102\Common" mkdir "%SHAREPATH%\hn4a-cap102\Common"
icacls "%SHAREPATH%\hn4a-cap102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-cap102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-cap102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-cap102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnacap401 ---
if not exist "%SHAREPATH%\hn4a-cap102\hnacap401" mkdir "%SHAREPATH%\hn4a-cap102\hnacap401"
icacls "%SHAREPATH%\hn4a-cap102\hnacap401" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-cap102\hnacap401" /grant "%DOMAIN%\hnacap401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-cap102\hnacap401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-cap102\hnacap401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnacap401,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-cap102" -hmdrv %HOMEDRIVE%
echo DONE: hnacap401
echo ------------------------------

REM --- User: hnacap402 ---
if not exist "%SHAREPATH%\hn4a-cap102\hnacap402" mkdir "%SHAREPATH%\hn4a-cap102\hnacap402"
icacls "%SHAREPATH%\hn4a-cap102\hnacap402" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-cap102\hnacap402" /grant "%DOMAIN%\hnacap402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-cap102\hnacap402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-cap102\hnacap402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnacap402,ou=hn4a-cap102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-cap102" -hmdrv %HOMEDRIVE%
echo DONE: hnacap402
echo ------------------------------

REM ===== SECTION: hn4a-hnwnwse =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn4a-hnwnwse" mkdir "%SHAREPATH%\hn4a-hnwnwse"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn4a-hnwnwse" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-hnwnwse" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn4a-hnwnwse\Common" mkdir "%SHAREPATH%\hn4a-hnwnwse\Common"
icacls "%SHAREPATH%\hn4a-hnwnwse\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnawns401 ---
if not exist "%SHAREPATH%\hn4a-hnwnwse\hnawns401" mkdir "%SHAREPATH%\hn4a-hnwnwse\hnawns401"
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns401" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns401" /grant "%DOMAIN%\hnawns401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnawns401,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-hnwnwse" -hmdrv %HOMEDRIVE%
echo DONE: hnawns401
echo ------------------------------

REM --- User: hnawns402 ---
if not exist "%SHAREPATH%\hn4a-hnwnwse\hnawns402" mkdir "%SHAREPATH%\hn4a-hnwnwse\hnawns402"
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns402" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns402" /grant "%DOMAIN%\hnawns402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-hnwnwse\hnawns402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnawns402,ou=hn4a-hnwnwse,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-hnwnwse" -hmdrv %HOMEDRIVE%
echo DONE: hnawns402
echo ------------------------------

REM ===== SECTION: hn4a-ias102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn4a-ias102" mkdir "%SHAREPATH%\hn4a-ias102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn4a-ias102" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-ias102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-ias102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-ias102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn4a-ias102\Common" mkdir "%SHAREPATH%\hn4a-ias102\Common"
icacls "%SHAREPATH%\hn4a-ias102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-ias102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-ias102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-ias102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnaias401 ---
if not exist "%SHAREPATH%\hn4a-ias102\hnaias401" mkdir "%SHAREPATH%\hn4a-ias102\hnaias401"
icacls "%SHAREPATH%\hn4a-ias102\hnaias401" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-ias102\hnaias401" /grant "%DOMAIN%\hnaias401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-ias102\hnaias401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-ias102\hnaias401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnaias401,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-ias102" -hmdrv %HOMEDRIVE%
echo DONE: hnaias401
echo ------------------------------

REM --- User: hnaias402 ---
if not exist "%SHAREPATH%\hn4a-ias102\hnaias402" mkdir "%SHAREPATH%\hn4a-ias102\hnaias402"
icacls "%SHAREPATH%\hn4a-ias102\hnaias402" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-ias102\hnaias402" /grant "%DOMAIN%\hnaias402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-ias102\hnaias402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-ias102\hnaias402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnaias402,ou=hn4a-ias102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-ias102" -hmdrv %HOMEDRIVE%
echo DONE: hnaias402
echo ------------------------------

REM ===== SECTION: hn4a-sa101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\hn4a-sa101" mkdir "%SHAREPATH%\hn4a-sa101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\hn4a-sa101" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-sa101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-sa101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-sa101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\hn4a-sa101\Common" mkdir "%SHAREPATH%\hn4a-sa101\Common"
icacls "%SHAREPATH%\hn4a-sa101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-sa101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\hn4a-sa101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-sa101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: hnasam401 ---
if not exist "%SHAREPATH%\hn4a-sa101\hnasam401" mkdir "%SHAREPATH%\hn4a-sa101\hnasam401"
icacls "%SHAREPATH%\hn4a-sa101\hnasam401" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-sa101\hnasam401" /grant "%DOMAIN%\hnasam401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-sa101\hnasam401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-sa101\hnasam401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnasam401,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-sa101" -hmdrv %HOMEDRIVE%
echo DONE: hnasam401
echo ------------------------------

REM --- User: hnasam402 ---
if not exist "%SHAREPATH%\hn4a-sa101\hnasam402" mkdir "%SHAREPATH%\hn4a-sa101\hnasam402"
icacls "%SHAREPATH%\hn4a-sa101\hnasam402" /inheritance:r >nul
icacls "%SHAREPATH%\hn4a-sa101\hnasam402" /grant "%DOMAIN%\hnasam402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-sa101\hnasam402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\hn4a-sa101\hnasam402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=hnasam402,ou=hn4a-sa101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\hn4a-sa101" -hmdrv %HOMEDRIVE%
echo DONE: hnasam402
echo ------------------------------

REM ===== SECTION: ist1a-cc101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist1a-cc101" mkdir "%SHAREPATH%\ist1a-cc101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist1a-cc101" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist1a-cc101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist1a-cc101\Common" mkdir "%SHAREPATH%\ist1a-cc101\Common"
icacls "%SHAREPATH%\ist1a-cc101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist1a-cc101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istainc101 ---
if not exist "%SHAREPATH%\ist1a-cc101\istainc101" mkdir "%SHAREPATH%\ist1a-cc101\istainc101"
icacls "%SHAREPATH%\ist1a-cc101\istainc101" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc101\istainc101" /grant "%DOMAIN%\istainc101:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc101\istainc101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc101\istainc101" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istainc101,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist1a-cc101" -hmdrv %HOMEDRIVE%
echo DONE: istainc101
echo ------------------------------

REM --- User: istainc102 ---
if not exist "%SHAREPATH%\ist1a-cc101\istainc102" mkdir "%SHAREPATH%\ist1a-cc101\istainc102"
icacls "%SHAREPATH%\ist1a-cc101\istainc102" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc101\istainc102" /grant "%DOMAIN%\istainc102:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc101\istainc102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc101\istainc102" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istainc102,ou=ist1a-cc101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist1a-cc101" -hmdrv %HOMEDRIVE%
echo DONE: istainc102
echo ------------------------------

REM ===== SECTION: ist1a-cc102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist1a-cc102" mkdir "%SHAREPATH%\ist1a-cc102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist1a-cc102" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist1a-cc102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist1a-cc102\Common" mkdir "%SHAREPATH%\ist1a-cc102\Common"
icacls "%SHAREPATH%\ist1a-cc102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist1a-cc102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istacp101 ---
if not exist "%SHAREPATH%\ist1a-cc102\istacp101" mkdir "%SHAREPATH%\ist1a-cc102\istacp101"
icacls "%SHAREPATH%\ist1a-cc102\istacp101" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc102\istacp101" /grant "%DOMAIN%\istacp101:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc102\istacp101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc102\istacp101" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istacp101,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist1a-cc102" -hmdrv %HOMEDRIVE%
echo DONE: istacp101
echo ------------------------------

REM --- User: istacp102 ---
if not exist "%SHAREPATH%\ist1a-cc102\istacp102" mkdir "%SHAREPATH%\ist1a-cc102\istacp102"
icacls "%SHAREPATH%\ist1a-cc102\istacp102" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-cc102\istacp102" /grant "%DOMAIN%\istacp102:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc102\istacp102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-cc102\istacp102" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istacp102,ou=ist1a-cc102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist1a-cc102" -hmdrv %HOMEDRIVE%
echo DONE: istacp102
echo ------------------------------

REM ===== SECTION: ist1a-ct1 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist1a-ct1" mkdir "%SHAREPATH%\ist1a-ct1"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist1a-ct1" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-ct1" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist1a-ct1" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-ct1" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist1a-ct1\Common" mkdir "%SHAREPATH%\ist1a-ct1\Common"
icacls "%SHAREPATH%\ist1a-ct1\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-ct1\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist1a-ct1\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-ct1\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istactw101 ---
if not exist "%SHAREPATH%\ist1a-ct1\istactw101" mkdir "%SHAREPATH%\ist1a-ct1\istactw101"
icacls "%SHAREPATH%\ist1a-ct1\istactw101" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-ct1\istactw101" /grant "%DOMAIN%\istactw101:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-ct1\istactw101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-ct1\istactw101" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istactw101,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist1a-ct1" -hmdrv %HOMEDRIVE%
echo DONE: istactw101
echo ------------------------------

REM --- User: istactw102 ---
if not exist "%SHAREPATH%\ist1a-ct1\istactw102" mkdir "%SHAREPATH%\ist1a-ct1\istactw102"
icacls "%SHAREPATH%\ist1a-ct1\istactw102" /inheritance:r >nul
icacls "%SHAREPATH%\ist1a-ct1\istactw102" /grant "%DOMAIN%\istactw102:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-ct1\istactw102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist1a-ct1\istactw102" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istactw102,ou=ist1a-ct1,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist1a-ct1" -hmdrv %HOMEDRIVE%
echo DONE: istactw102
echo ------------------------------

REM ===== SECTION: ist2a-isedpat =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist2a-isedpat" mkdir "%SHAREPATH%\ist2a-isedpat"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist2a-isedpat" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-isedpat" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-isedpat" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-isedpat" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist2a-isedpat\Common" mkdir "%SHAREPATH%\ist2a-isedpat\Common"
icacls "%SHAREPATH%\ist2a-isedpat\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-isedpat\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-isedpat\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-isedpat\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istaept201 ---
if not exist "%SHAREPATH%\ist2a-isedpat\istaept201" mkdir "%SHAREPATH%\ist2a-isedpat\istaept201"
icacls "%SHAREPATH%\ist2a-isedpat\istaept201" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-isedpat\istaept201" /grant "%DOMAIN%\istaept201:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-isedpat\istaept201" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-isedpat\istaept201" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaept201,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-isedpat" -hmdrv %HOMEDRIVE%
echo DONE: istaept201
echo ------------------------------

REM --- User: istaept202 ---
if not exist "%SHAREPATH%\ist2a-isedpat\istaept202" mkdir "%SHAREPATH%\ist2a-isedpat\istaept202"
icacls "%SHAREPATH%\ist2a-isedpat\istaept202" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-isedpat\istaept202" /grant "%DOMAIN%\istaept202:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-isedpat\istaept202" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-isedpat\istaept202" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaept202,ou=ist2a-isedpat,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-isedpat" -hmdrv %HOMEDRIVE%
echo DONE: istaept202
echo ------------------------------

REM ===== SECTION: ist2a-pf101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist2a-pf101" mkdir "%SHAREPATH%\ist2a-pf101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist2a-pf101" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-pf101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-pf101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-pf101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist2a-pf101\Common" mkdir "%SHAREPATH%\ist2a-pf101\Common"
icacls "%SHAREPATH%\ist2a-pf101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-pf101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-pf101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-pf101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istaoop201 ---
if not exist "%SHAREPATH%\ist2a-pf101\istaoop201" mkdir "%SHAREPATH%\ist2a-pf101\istaoop201"
icacls "%SHAREPATH%\ist2a-pf101\istaoop201" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-pf101\istaoop201" /grant "%DOMAIN%\istaoop201:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-pf101\istaoop201" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-pf101\istaoop201" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaoop201,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-pf101" -hmdrv %HOMEDRIVE%
echo DONE: istaoop201
echo ------------------------------

REM --- User: istaoop202 ---
if not exist "%SHAREPATH%\ist2a-pf101\istaoop202" mkdir "%SHAREPATH%\ist2a-pf101\istaoop202"
icacls "%SHAREPATH%\ist2a-pf101\istaoop202" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-pf101\istaoop202" /grant "%DOMAIN%\istaoop202:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-pf101\istaoop202" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-pf101\istaoop202" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaoop202,ou=ist2a-pf101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-pf101" -hmdrv %HOMEDRIVE%
echo DONE: istaoop202
echo ------------------------------

REM ===== SECTION: ist2a-cc104 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist2a-cc104" mkdir "%SHAREPATH%\ist2a-cc104"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist2a-cc104" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-cc104" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-cc104" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-cc104" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist2a-cc104\Common" mkdir "%SHAREPATH%\ist2a-cc104\Common"
icacls "%SHAREPATH%\ist2a-cc104\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-cc104\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-cc104\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-cc104\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istadsa201 ---
if not exist "%SHAREPATH%\ist2a-cc104\istadsa201" mkdir "%SHAREPATH%\ist2a-cc104\istadsa201"
icacls "%SHAREPATH%\ist2a-cc104\istadsa201" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-cc104\istadsa201" /grant "%DOMAIN%\istadsa201:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-cc104\istadsa201" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-cc104\istadsa201" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istadsa201,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-cc104" -hmdrv %HOMEDRIVE%
echo DONE: istadsa201
echo ------------------------------

REM --- User: istadsa202 ---
if not exist "%SHAREPATH%\ist2a-cc104\istadsa202" mkdir "%SHAREPATH%\ist2a-cc104\istadsa202"
icacls "%SHAREPATH%\ist2a-cc104\istadsa202" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-cc104\istadsa202" /grant "%DOMAIN%\istadsa202:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-cc104\istadsa202" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-cc104\istadsa202" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istadsa202,ou=ist2a-cc104,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-cc104" -hmdrv %HOMEDRIVE%
echo DONE: istadsa202
echo ------------------------------

REM ===== SECTION: ist2a-ct3 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist2a-ct3" mkdir "%SHAREPATH%\ist2a-ct3"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist2a-ct3" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-ct3" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-ct3" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-ct3" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist2a-ct3\Common" mkdir "%SHAREPATH%\ist2a-ct3\Common"
icacls "%SHAREPATH%\ist2a-ct3\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-ct3\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist2a-ct3\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-ct3\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istacth201 ---
if not exist "%SHAREPATH%\ist2a-ct3\istacth201" mkdir "%SHAREPATH%\ist2a-ct3\istacth201"
icacls "%SHAREPATH%\ist2a-ct3\istacth201" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-ct3\istacth201" /grant "%DOMAIN%\istacth201:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-ct3\istacth201" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-ct3\istacth201" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istacth201,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-ct3" -hmdrv %HOMEDRIVE%
echo DONE: istacth201
echo ------------------------------

REM --- User: istacth202 ---
if not exist "%SHAREPATH%\ist2a-ct3\istacth202" mkdir "%SHAREPATH%\ist2a-ct3\istacth202"
icacls "%SHAREPATH%\ist2a-ct3\istacth202" /inheritance:r >nul
icacls "%SHAREPATH%\ist2a-ct3\istacth202" /grant "%DOMAIN%\istacth202:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-ct3\istacth202" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist2a-ct3\istacth202" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istacth202,ou=ist2a-ct3,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist2a-ct3" -hmdrv %HOMEDRIVE%
echo DONE: istacth202
echo ------------------------------

REM ===== SECTION: ist3a-net102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist3a-net102" mkdir "%SHAREPATH%\ist3a-net102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist3a-net102" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-net102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-net102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-net102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist3a-net102\Common" mkdir "%SHAREPATH%\ist3a-net102\Common"
icacls "%SHAREPATH%\ist3a-net102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-net102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-net102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-net102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istanet301 ---
if not exist "%SHAREPATH%\ist3a-net102\istanet301" mkdir "%SHAREPATH%\ist3a-net102\istanet301"
icacls "%SHAREPATH%\ist3a-net102\istanet301" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-net102\istanet301" /grant "%DOMAIN%\istanet301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-net102\istanet301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-net102\istanet301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istanet301,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-net102" -hmdrv %HOMEDRIVE%
echo DONE: istanet301
echo ------------------------------

REM --- User: istanet302 ---
if not exist "%SHAREPATH%\ist3a-net102\istanet302" mkdir "%SHAREPATH%\ist3a-net102\istanet302"
icacls "%SHAREPATH%\ist3a-net102\istanet302" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-net102\istanet302" /grant "%DOMAIN%\istanet302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-net102\istanet302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-net102\istanet302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istanet302,ou=ist3a-net102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-net102" -hmdrv %HOMEDRIVE%
echo DONE: istanet302
echo ------------------------------

REM ===== SECTION: ist3a-sia101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist3a-sia101" mkdir "%SHAREPATH%\ist3a-sia101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist3a-sia101" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-sia101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-sia101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-sia101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist3a-sia101\Common" mkdir "%SHAREPATH%\ist3a-sia101\Common"
icacls "%SHAREPATH%\ist3a-sia101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-sia101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-sia101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-sia101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istasia301 ---
if not exist "%SHAREPATH%\ist3a-sia101\istasia301" mkdir "%SHAREPATH%\ist3a-sia101\istasia301"
icacls "%SHAREPATH%\ist3a-sia101\istasia301" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-sia101\istasia301" /grant "%DOMAIN%\istasia301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-sia101\istasia301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-sia101\istasia301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istasia301,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-sia101" -hmdrv %HOMEDRIVE%
echo DONE: istasia301
echo ------------------------------

REM --- User: istasia302 ---
if not exist "%SHAREPATH%\ist3a-sia101\istasia302" mkdir "%SHAREPATH%\ist3a-sia101\istasia302"
icacls "%SHAREPATH%\ist3a-sia101\istasia302" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-sia101\istasia302" /grant "%DOMAIN%\istasia302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-sia101\istasia302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-sia101\istasia302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istasia302,ou=ist3a-sia101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-sia101" -hmdrv %HOMEDRIVE%
echo DONE: istasia302
echo ------------------------------

REM ===== SECTION: ist3a-im101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist3a-im101" mkdir "%SHAREPATH%\ist3a-im101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist3a-im101" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-im101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-im101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-im101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist3a-im101\Common" mkdir "%SHAREPATH%\ist3a-im101\Common"
icacls "%SHAREPATH%\ist3a-im101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-im101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-im101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-im101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istaads301 ---
if not exist "%SHAREPATH%\ist3a-im101\istaads301" mkdir "%SHAREPATH%\ist3a-im101\istaads301"
icacls "%SHAREPATH%\ist3a-im101\istaads301" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-im101\istaads301" /grant "%DOMAIN%\istaads301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-im101\istaads301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-im101\istaads301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaads301,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-im101" -hmdrv %HOMEDRIVE%
echo DONE: istaads301
echo ------------------------------

REM --- User: istaads302 ---
if not exist "%SHAREPATH%\ist3a-im101\istaads302" mkdir "%SHAREPATH%\ist3a-im101\istaads302"
icacls "%SHAREPATH%\ist3a-im101\istaads302" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-im101\istaads302" /grant "%DOMAIN%\istaads302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-im101\istaads302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-im101\istaads302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaads302,ou=ist3a-im101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-im101" -hmdrv %HOMEDRIVE%
echo DONE: istaads302
echo ------------------------------

REM ===== SECTION: ist3a-isasssl =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist3a-isasssl" mkdir "%SHAREPATH%\ist3a-isasssl"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist3a-isasssl" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-isasssl" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-isasssl" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-isasssl" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist3a-isasssl\Common" mkdir "%SHAREPATH%\ist3a-isasssl\Common"
icacls "%SHAREPATH%\ist3a-isasssl\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-isasssl\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-isasssl\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-isasssl\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istaasl301 ---
if not exist "%SHAREPATH%\ist3a-isasssl\istaasl301" mkdir "%SHAREPATH%\ist3a-isasssl\istaasl301"
icacls "%SHAREPATH%\ist3a-isasssl\istaasl301" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-isasssl\istaasl301" /grant "%DOMAIN%\istaasl301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-isasssl\istaasl301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-isasssl\istaasl301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaasl301,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-isasssl" -hmdrv %HOMEDRIVE%
echo DONE: istaasl301
echo ------------------------------

REM --- User: istaasl302 ---
if not exist "%SHAREPATH%\ist3a-isasssl\istaasl302" mkdir "%SHAREPATH%\ist3a-isasssl\istaasl302"
icacls "%SHAREPATH%\ist3a-isasssl\istaasl302" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-isasssl\istaasl302" /grant "%DOMAIN%\istaasl302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-isasssl\istaasl302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-isasssl\istaasl302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaasl302,ou=ist3a-isasssl,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-isasssl" -hmdrv %HOMEDRIVE%
echo DONE: istaasl302
echo ------------------------------

REM ===== SECTION: ist3a-ct5 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist3a-ct5" mkdir "%SHAREPATH%\ist3a-ct5"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist3a-ct5" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-ct5" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-ct5" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-ct5" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist3a-ct5\Common" mkdir "%SHAREPATH%\ist3a-ct5\Common"
icacls "%SHAREPATH%\ist3a-ct5\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-ct5\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist3a-ct5\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-ct5\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istactp301 ---
if not exist "%SHAREPATH%\ist3a-ct5\istactp301" mkdir "%SHAREPATH%\ist3a-ct5\istactp301"
icacls "%SHAREPATH%\ist3a-ct5\istactp301" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-ct5\istactp301" /grant "%DOMAIN%\istactp301:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-ct5\istactp301" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-ct5\istactp301" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istactp301,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-ct5" -hmdrv %HOMEDRIVE%
echo DONE: istactp301
echo ------------------------------

REM --- User: istactp302 ---
if not exist "%SHAREPATH%\ist3a-ct5\istactp302" mkdir "%SHAREPATH%\ist3a-ct5\istactp302"
icacls "%SHAREPATH%\ist3a-ct5\istactp302" /inheritance:r >nul
icacls "%SHAREPATH%\ist3a-ct5\istactp302" /grant "%DOMAIN%\istactp302:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-ct5\istactp302" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist3a-ct5\istactp302" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istactp302,ou=ist3a-ct5,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist3a-ct5" -hmdrv %HOMEDRIVE%
echo DONE: istactp302
echo ------------------------------

REM ===== SECTION: ist4a-sa101 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist4a-sa101" mkdir "%SHAREPATH%\ist4a-sa101"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist4a-sa101" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-sa101" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-sa101" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-sa101" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist4a-sa101\Common" mkdir "%SHAREPATH%\ist4a-sa101\Common"
icacls "%SHAREPATH%\ist4a-sa101\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-sa101\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-sa101\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-sa101\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istasam401 ---
if not exist "%SHAREPATH%\ist4a-sa101\istasam401" mkdir "%SHAREPATH%\ist4a-sa101\istasam401"
icacls "%SHAREPATH%\ist4a-sa101\istasam401" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-sa101\istasam401" /grant "%DOMAIN%\istasam401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-sa101\istasam401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-sa101\istasam401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istasam401,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-sa101" -hmdrv %HOMEDRIVE%
echo DONE: istasam401
echo ------------------------------

REM --- User: istasam402 ---
if not exist "%SHAREPATH%\ist4a-sa101\istasam402" mkdir "%SHAREPATH%\ist4a-sa101\istasam402"
icacls "%SHAREPATH%\ist4a-sa101\istasam402" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-sa101\istasam402" /grant "%DOMAIN%\istasam402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-sa101\istasam402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-sa101\istasam402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istasam402,ou=ist4a-sa101,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-sa101" -hmdrv %HOMEDRIVE%
echo DONE: istasam402
echo ------------------------------

REM ===== SECTION: ist4a-ias102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist4a-ias102" mkdir "%SHAREPATH%\ist4a-ias102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist4a-ias102" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-ias102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-ias102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-ias102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist4a-ias102\Common" mkdir "%SHAREPATH%\ist4a-ias102\Common"
icacls "%SHAREPATH%\ist4a-ias102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-ias102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-ias102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-ias102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istaias401 ---
if not exist "%SHAREPATH%\ist4a-ias102\istaias401" mkdir "%SHAREPATH%\ist4a-ias102\istaias401"
icacls "%SHAREPATH%\ist4a-ias102\istaias401" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-ias102\istaias401" /grant "%DOMAIN%\istaias401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-ias102\istaias401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-ias102\istaias401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaias401,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-ias102" -hmdrv %HOMEDRIVE%
echo DONE: istaias401
echo ------------------------------

REM --- User: istaias402 ---
if not exist "%SHAREPATH%\ist4a-ias102\istaias402" mkdir "%SHAREPATH%\ist4a-ias102\istaias402"
icacls "%SHAREPATH%\ist4a-ias102\istaias402" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-ias102\istaias402" /grant "%DOMAIN%\istaias402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-ias102\istaias402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-ias102\istaias402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istaias402,ou=ist4a-ias102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-ias102" -hmdrv %HOMEDRIVE%
echo DONE: istaias402
echo ------------------------------

REM ===== SECTION: ist4a-cap102 =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist4a-cap102" mkdir "%SHAREPATH%\ist4a-cap102"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist4a-cap102" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-cap102" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-cap102" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-cap102" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist4a-cap102\Common" mkdir "%SHAREPATH%\ist4a-cap102\Common"
icacls "%SHAREPATH%\ist4a-cap102\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-cap102\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-cap102\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-cap102\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istacap401 ---
if not exist "%SHAREPATH%\ist4a-cap102\istacap401" mkdir "%SHAREPATH%\ist4a-cap102\istacap401"
icacls "%SHAREPATH%\ist4a-cap102\istacap401" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-cap102\istacap401" /grant "%DOMAIN%\istacap401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-cap102\istacap401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-cap102\istacap401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istacap401,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-cap102" -hmdrv %HOMEDRIVE%
echo DONE: istacap401
echo ------------------------------

REM --- User: istacap402 ---
if not exist "%SHAREPATH%\ist4a-cap102\istacap402" mkdir "%SHAREPATH%\ist4a-cap102\istacap402"
icacls "%SHAREPATH%\ist4a-cap102\istacap402" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-cap102\istacap402" /grant "%DOMAIN%\istacap402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-cap102\istacap402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-cap102\istacap402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istacap402,ou=ist4a-cap102,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-cap102" -hmdrv %HOMEDRIVE%
echo DONE: istacap402
echo ------------------------------

REM ===== SECTION: ist4a-istwdev =====

REM --- Create section folder ---
if not exist "%SHAREPATH%\ist4a-istwdev" mkdir "%SHAREPATH%\ist4a-istwdev"

REM --- Section-level permissions ---
icacls "%SHAREPATH%\ist4a-istwdev" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-istwdev" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-istwdev" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-istwdev" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- Create Common folder and set permissions ---
if not exist "%SHAREPATH%\ist4a-istwdev\Common" mkdir "%SHAREPATH%\ist4a-istwdev\Common"
icacls "%SHAREPATH%\ist4a-istwdev\Common" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-istwdev\Common" /grant "Students:(OI)(CI)(RX)" >nul
icacls "%SHAREPATH%\ist4a-istwdev\Common" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-istwdev\Common" /grant "SYSTEM:(OI)(CI)F" >nul

REM --- User: istatdt401 ---
if not exist "%SHAREPATH%\ist4a-istwdev\istatdt401" mkdir "%SHAREPATH%\ist4a-istwdev\istatdt401"
icacls "%SHAREPATH%\ist4a-istwdev\istatdt401" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-istwdev\istatdt401" /grant "%DOMAIN%\istatdt401:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-istwdev\istatdt401" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-istwdev\istatdt401" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istatdt401,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-istwdev" -hmdrv %HOMEDRIVE%
echo DONE: istatdt401
echo ------------------------------

REM --- User: istatdt402 ---
if not exist "%SHAREPATH%\ist4a-istwdev\istatdt402" mkdir "%SHAREPATH%\ist4a-istwdev\istatdt402"
icacls "%SHAREPATH%\ist4a-istwdev\istatdt402" /inheritance:r >nul
icacls "%SHAREPATH%\ist4a-istwdev\istatdt402" /grant "%DOMAIN%\istatdt402:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-istwdev\istatdt402" /grant "Administrators:(OI)(CI)F" >nul
icacls "%SHAREPATH%\ist4a-istwdev\istatdt402" /grant "SYSTEM:(OI)(CI)F" >nul
dsmod user "cn=istatdt402,ou=ist4a-istwdev,ou=students,dc=asukalibo,dc=local" -hmdir "%SHAREPATH%\ist4a-istwdev" -hmdrv %HOMEDRIVE%
echo DONE: istatdt402
echo ------------------------------

echo ===== ALL DONE =====
pause
