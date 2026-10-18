@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Manage-Loose-Polish.ps1" -Mode Update -GameRoot "%~dp0."
pause
