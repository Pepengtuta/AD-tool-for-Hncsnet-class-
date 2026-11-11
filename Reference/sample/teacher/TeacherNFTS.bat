@echo off
set TEACHER=(replacewithteachername)
for %%F in (
    "\\DC1\26271stSem\"
    "\\DC1\26271stSem\"
    "\\DC1\26271stSem\"
    "\\DC1\26271stSem\"
) do (
    icacls %%F /grant "asukalibo\%TEACHER%:(OI)(CI)M" /T
    echo [OK] %TEACHER% added to %%F
)
echo Done!