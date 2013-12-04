#!/bin/bash
rm -f ndll/iPhone/*
(cd project && rm -rf obj)
(cd project && haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7)
(cd project && haxelib run hxcpp Build.xml -Diphonesim)
