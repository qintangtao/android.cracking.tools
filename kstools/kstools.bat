cd %~dp0
set aapt_path=.\aapt.exe
java -Xmx2048m -XX:-UseParallelGC -XX:MinHeapFreeRatio=15 -jar kstools.jar ++hook %~dp0 %1 %aapt_path% 1338303158
adb install -r signed.apk
pause..
