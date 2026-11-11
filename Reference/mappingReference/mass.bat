@echo off
setlocal enabledelayedexpansion

REM ===== CONFIG =====
set SHAREPATH=\\FileServer\25262ndSem
REM List of usernames one per line
set USERFILE=logon_names.txt

REM ===== LOOP THROUGH EACH USER =====
for /f "usebackq delims=" %%U in ("%USERFILE%") do (
    set "USERCN=%%U"
    echo ===============================
    echo Processing !USERCN!...

    REM ===== GET FULL USER DN =====
    set "USERDN="
    for /f "delims=" %%D in ('dsquery user -samid !USERCN! 2^>nul') do (
        set "USERDN=%%D"
    )

    if not defined USERDN (
        echo ERROR: User !USERCN! not found in AD
        echo ------------------------------
    ) else (

        REM ===== EXTRACT SECTION =====
        for /f "tokens=2 delims=," %%A in ("!USERDN!") do (
            set "SECTION=%%A"
        )
        set "SECTION=!SECTION:~3!"

        echo User DN: !USERDN!
        echo Section: !SECTION!

        REM ===== CREATE SECTION FOLDER =====
        if not exist "%SHAREPATH%\!SECTION!" mkdir "%SHAREPATH%\!SECTION!"

        REM ===== CREATE COMMON FOLDER =====
        if not exist "%SHAREPATH%\!SECTION!\Common" (
            mkdir "%SHAREPATH%\!SECTION!\Common"
            icacls "%SHAREPATH%\!SECTION!\Common" /inheritance:r >nul
            icacls "%SHAREPATH%\!SECTION!\Common" /grant "Students:(OI)(CI)(RX)" >nul
            icacls "%SHAREPATH%\!SECTION!\Common" /grant "Administrators:(OI)(CI)F" >nul
            icacls "%SHAREPATH%\!SECTION!\Common" /grant "SYSTEM:(OI)(CI)F" >nul
        )

        REM ===== CREATE USER FOLDER =====
        if not exist "%SHAREPATH%\!SECTION!\!USERCN!" mkdir "%SHAREPATH%\!SECTION!\!USERCN!"

        REM ===== SET USER PERMISSIONS =====
        icacls "%SHAREPATH%\!SECTION!\!USERCN!" /inheritance:r >nul
        icacls "%SHAREPATH%\!SECTION!\!USERCN!" /grant "!USERCN!:(OI)(CI)F" >nul
        icacls "%SHAREPATH%\!SECTION!\!USERCN!" /grant "Administrators:(OI)(CI)F" >nul
        icacls "%SHAREPATH%\!SECTION!\!USERCN!" /grant "SYSTEM:(OI)(CI)F" >nul

        REM ===== SECTION LEVEL PERMISSIONS =====
        icacls "%SHAREPATH%\!SECTION!" /inheritance:r >nul
        icacls "%SHAREPATH%\!SECTION!" /grant "Students:(OI)(CI)(RX)" >nul
        icacls "%SHAREPATH%\!SECTION!" /grant "Administrators:(OI)(CI)F" >nul
        icacls "%SHAREPATH%\!SECTION!" /grant "SYSTEM:(OI)(CI)F" >nul

        REM ===== SET HOME DRIVE =====
        dsmod user "!USERDN!" -hmdir "%SHAREPATH%\!SECTION!" -hmdrv H:

        echo DONE for !USERCN!
        echo ------------------------------
    )
)

echo ALL USERS PROCESSED
pause