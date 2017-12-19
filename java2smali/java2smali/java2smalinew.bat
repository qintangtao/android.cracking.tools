@echo off
set PATH=%cd%;%PATH%;
set WORKPATH=%~dp0
set CLASSPATH=%WORKPATH%\classes
set LIBPATH=%WORKPATH%\lib
set SOURCEPATH=%WORKPATH%\java
set SMALIPATH=%WORKPATH%\smali
set DEXPATH=%WORKPATH%\classes.dex

::echo %WORKPATH%
::echo %CLASSPATH%
::echo %LIBPATH%
::echo %SOURCEPATH%
::echo %SMALIPATH%

if exist %CLASSPATH% (
	rd /s /q %CLASSPATH%
)
md %CLASSPATH%

if exist %SMALIPATH% (
	rd /s /q %SMALIPATH%
)
md %SMALIPATH%

echo =======================================================
echo java2class
javac -classpath %LIBPATH%\android.jar -d %CLASSPATH% %1
echo returnCode %ERRORLEVEL%
if "%ERRORLEVEL%" == "0" (
	echo =======================================================
	echo class2dex
	java -jar %LIBPATH%\dx.jar --dex --output=%DEXPATH% %CLASSPATH%
	echo returnCode %ERRORLEVEL%
	if "%ERRORLEVEL%" == "0" (
		echo =======================================================
		echo dex2smali
		java -jar %LIBPATH%\baksmali.jar -o %SMALIPATH% %DEXPATH%
		echo returnCode %ERRORLEVEL%
		if "%ERRORLEVEL%" == "0" (
				echo 转换成功
		)
	)
)


if exist %CLASSPATH% (
	rd /s /q %CLASSPATH%
)
if exist %DEXPATH% (
	del /f /a /q %DEXPATH%
)
