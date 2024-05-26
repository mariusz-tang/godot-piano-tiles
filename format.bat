@echo off
gdlint ./scripts/
if %ERRORLEVEL%==0 gdformat ./scripts/ --line-length=80
pause