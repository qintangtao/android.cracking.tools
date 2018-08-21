@echo off
set PATH=%CD%;%PATH%;
set PATH="C:\Program Files\Java\jdk1.8.0_121\bin";%PATH%;
java -jar "%~dp0\oat2dex.jar" %1 %2 %3 %4 %5 %6 %7 %8 %9
