@echo off
net use F: "\\DC1\26271stSem\hn3a-im101" /persistent:yes
net use G: "\\DC1\26271stSem\hn3a-net102" /persistent:yes
net use H: "\\DC1\26271stSem\hn3a-sia101" /persistent:yes
net use I: "\\DC1\26271stSem\hn4a-cap102" /persistent:yes

echo All drives mapped