@echo off
SET PATH=%PATH%;c:\Android\AndroidSDK\tools;c:\Android\AndroidSDK\platform-tools
adb logcat -c
call openfl test project.xml android
pause
pskill adb
