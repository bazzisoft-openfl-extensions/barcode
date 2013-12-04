@echo off
del /q ndll\Windows\*.*
cd project
rmdir /s /q obj
haxelib run hxcpp Build.xml -Dwindows
pause