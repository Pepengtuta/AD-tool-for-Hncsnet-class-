@echo off
setlocal enabledelayedexpansion

REM ===== CONFIG =====
set SHAREPATH=\\FileServer\25262ndSem
set "DOMAIN=ASUKALIBO"

REM ===== LOOP THROUGH EACH SECTION FOLDER =====
for /d %%S in ("%SHAREPATH%\*") do (
    echo Processing Section: %%~nxS

    REM ===== LOOP THROUGH EACH USER FOLDER INSIDE SECTION =====
    for /d %%U in ("%%S\*") do (
        set "USERNAME=%%~nxU"

        REM ===== SKIP COMMON FOLDER =====
        if /i not "!USERNAME!"=="Common" (
            echo Setting permissions for: !USERNAME!

            icacls "%%U" /inheritance:r >nul
            icacls "%%U" /grant "!DOMAIN!\!USERNAME!:(OI)(CI)F" >nul
            icacls "%%U" /grant "Administrators:(OI)(CI)F" >nul
            icacls "%%U" /grant "SYSTEM:(OI)(CI)F" >nul

            echo DONE: !USERNAME!
            echo ------------------------------
        )
    )
)

echo ALL PERMISSIONS FIXED
pause