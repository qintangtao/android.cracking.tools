@echo off
set PATH=%CD%;%PATH%;
java -jar "%~dp0\smali-2.0.5.jar" %1 %2 %3 %4 %5 %6 %7 %8 %9
