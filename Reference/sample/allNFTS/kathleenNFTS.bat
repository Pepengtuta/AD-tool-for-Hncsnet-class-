@echo off
set TEACHER=kathleen
for %%F in (
    "\\DC1\26271stSem\hn2a-ct3"
    "\\DC1\26271stSem\hn2a-pf101"
    "\\DC1\26271stSem\hn3a-ct5"
    "\\DC1\26271stSem\hn3a-hnrsawt"
) do (
    icacls %%F /grant "asukalibo\%TEACHER%:(OI)(CI)M" /T
    echo [OK] %TEACHER% added to %%F
)
echo Done!