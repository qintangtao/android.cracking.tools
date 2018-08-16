@echo off

del unsigned.apk
del signed.apk

call kstools.bat src.apk

del unsigned.apk
if exist signed.apk (
	adb install -r signed.apk
) else (
	echo 'signed.apk does not exist.'
)