@echo off
set TEACHER=juan
for %%F in (
    "\\DC1\26271stSem\hn1a-cc101"
    "\\DC1\26271stSem\hn1a-cc102"
    "\\DC1\26271stSem\hn1a-ct1"
    "\\DC1\26271stSem\hn2a-cc104"
) do (
    icacls %%F /grant "asukalibo\%TEACHER%:(OI)(CI)M" /T
    echo [OK] %TEACHER% added to %%F
)
echo Done!