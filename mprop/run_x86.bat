@echo off
adb push .\libs\x86\mprop /data/local/tmp/
adb shell "chmod 755 /data/local/tmp/mprop"

:: inject & hack
adb shell "/data/local/tmp/mprop"

:: verbose mode ==> dump memory 
:: adb shell "/data/local/tmp/mprop -v" > myprop.txt

:: restore
:: adb shell "/data/local/tmp/mprop -r"
adb shell "setprop selinux.reload_policy 0"
:: change ro.xx property
adb shell "setprop ro.debuggable 1"
adb shell "setprop selinux.reload_policy 1"

pause