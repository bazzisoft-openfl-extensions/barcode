#!/bin/bash
(cd .. && ./compile-ios.sh) && ./copy-ios-deps.sh && openfl update project.xml ios -simulator $@

