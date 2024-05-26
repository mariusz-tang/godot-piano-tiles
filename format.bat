@echo off
gdlint ./scenes/
if %ERRORLEVEL%==0 gdformat ./scenes/ --line-length=80
pause