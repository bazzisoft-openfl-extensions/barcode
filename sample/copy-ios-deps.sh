#!/bin/bash

APP_NAME="barcodesample"

# Space separate each libraries,ndll-name
LIBS="native_platform-0.2,nativeplatform barcode-0.1,barcode"

if [ ! -d bin/ios/${APP_NAME}/lib/i386 ]
then
    mkdir -p bin/ios/${APP_NAME}/lib/i386
fi

if [ ! -d bin/ios/${APP_NAME}/lib/i386-debug ]
then
    mkdir -p bin/ios/${APP_NAME}/lib/i386-debug
fi

if [ ! -d bin/ios/${APP_NAME}/lib/armv7 ]
then
    mkdir -p bin/ios/${APP_NAME}/lib/armv7
fi

if [ ! -d bin/ios/${APP_NAME}/lib/armv7-debug ]
then
    mkdir -p bin/ios/${APP_NAME}/lib/armv7-debug
fi

for lib in $LIBS
do
    IFS=","
    set -- $lib
    
    cp -v ../../../haxe_libs/$1/ndll/iPhone/lib$2.iphonesim.a bin/ios/$APP_NAME/lib/i386/lib$2.a
    cp -v ../../../haxe_libs/$1/ndll/iPhone/lib$2.iphonesim.a bin/ios/$APP_NAME/lib/i386-debug/lib$2.a
    cp -v ../../../haxe_libs/$1/ndll/iPhone/lib$2.iphoneos-v7.a bin/ios/$APP_NAME/lib/armv7/lib$2.a
    cp -v ../../../haxe_libs/$1/ndll/iPhone/lib$2.iphoneos-v7.a bin/ios/$APP_NAME/lib/armv7-debug/lib$2.a
done