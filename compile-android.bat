@echo off
del /q ndll\Android\*.*
cd project
rmdir /s /q obj
haxelib run hxcpp Build.xml -Dandroid
pause