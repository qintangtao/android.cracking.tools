@echo off

echo ------------------------------------
call apktool.bat b %1 -o %1-new.apk

echo ------------------------------------
for %%x in (classes*.dex) do (
	del %%x
)

echo ------------------------------------
for %%x in (%1\build\apk\classes*.dex) do (
	xcopy /y %%x .\
)

echo ------------------------------------
for %%x in (classes*.dex) do (
	aapt remove %1.apk %%x
	aapt add %1.apk %%x
)

echo ------------------------------------
del %1-new.apk
for %%x in (classes*.dex) do (
	del %%x
)

echo ------------------------------------
copy /y %1.apk ..\kstools\src.apk

