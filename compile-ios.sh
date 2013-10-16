#!/bin/bash
(cd project && haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7)
(cd project && haxelib run hxcpp Build.xml -Diphonesim)
