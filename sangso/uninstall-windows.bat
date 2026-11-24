@echo off
rem Double-click this file to remove the popup.
schtasks /Delete /TN "ZhugeLiang-Sangso" /F
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\ZhugeLiang-Sangso.lnk" 2>nul
echo Removed.
pause
