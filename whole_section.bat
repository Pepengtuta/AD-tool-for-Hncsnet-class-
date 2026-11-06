@echo off
setlocal enabledelayedexpansion

set "SHAREPATH=\\DC1\26271stSem"
set "DOMAIN=asukalibo"

for %%S in (
    one line per SECTION
) do (

    set "SECTION=%%S"
    
    set "SECTIONPATH=%SHAREPATH%\!SECTION!"
    set "COMMONPATH=!SECTIONPATH!\Common"

    echo.
    echo ========================================
    echo Processing: !SECTION!
    echo ========================================

    if not exist "!SECTIONPATH!" mkdir "!SECTIONPATH!"
    if not exist "!COMMONPATH!" mkdir "!COMMONPATH!"

    icacls "!SECTIONPATH!" /inheritance:r >nul
    icacls "!SECTIONPATH!" /grant "%DOMAIN%\!SECTION!:(OI)(CI)(RX)" || echo ERROR granting !SECTION! on !SECTIONPATH!
    icacls "!SECTIONPATH!" /grant "Administrators:(OI)(CI)(F)" >nul
    icacls "!SECTIONPATH!" /grant "SYSTEM:(OI)(CI)(F)" >nul
    icacls "!SECTIONPATH!" /grant "*S-1-3-0:(OI)(CI)(IO)(F)" >nul

    icacls "!COMMONPATH!" /inheritance:r >nul
    icacls "!COMMONPATH!" /grant "%DOMAIN%\!SECTION!:(OI)(CI)(RX)" || echo ERROR granting !SECTION! on !COMMONPATH!
    icacls "!COMMONPATH!" /grant "Administrators:(OI)(CI)(F)" >nul
    icacls "!COMMONPATH!" /grant "SYSTEM:(OI)(CI)(F)" >nul

    set "MAPPED=0"

    echo Querying AD for users in ou=!SECTION!...
    echo.

    for /f "tokens=1 delims=," %%d in ('dsquery user "ou=!SECTION!,ou=students,dc=asukalibo,dc=local" -limit 0 2^>nul') do (
        for /f "tokens=2 delims==" %%u in ("%%~d") do (
            set "USER=%%u"
            set "USERPATH=!SECTIONPATH!\!USER!"
            if not exist "!USERPATH!" mkdir "!USERPATH!"
            icacls "!USERPATH!" /inheritance:r >nul
            icacls "!USERPATH!" /grant "%DOMAIN%\!USER!:(OI)(CI)(F)" || echo [WARN] icacls failed for !USER!
            icacls "!USERPATH!" /grant "Administrators:(OI)(CI)(F)" >nul
            icacls "!USERPATH!" /grant "SYSTEM:(OI)(CI)(F)" >nul
            icacls "!USERPATH!" /grant "*S-1-3-0:(OI)(CI)(IO)(F)" >nul
            dsmod user "cn=!USER!,ou=!SECTION!,ou=students,dc=asukalibo,dc=local" -hmdir "!SECTIONPATH!" -hmdrv H:
            echo [OK]   Mapped !USER!
            set /a MAPPED+=1
        )
    )

    echo.
    echo Results: !MAPPED! users mapped from AD in !SECTION!
    echo.
)

echo ========================================
echo ALL SECTIONS COMPLETED
echo ========================================
echo.
pause