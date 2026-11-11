@echo off
set TEACHER=angelika
for %%F in (
    "\\DC1\26271stSem\hn3a-im101"
    "\\DC1\26271stSem\hn3a-net102"
    "\\DC1\26271stSem\hn3a-sia101"
    "\\DC1\26271stSem\hn4a-cap102"
) do (
    icacls %%F /grant "asukalibo\%TEACHER%:(OI)(CI)M" /T
    echo [OK] %TEACHER% added to %%F
)
echo Done!