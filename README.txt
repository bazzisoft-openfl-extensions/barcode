
USAGE
-----
Add the following to your project.xml:
    
    <android target-sdk-version="14" />
    <template path="../../barcode-0.1/templates/MainActivity.java" rename="src/my/app/package/MainActivity.java" if="android" />

    
    
GOTCHAS
-------
Your Info.plist must support all device orientations for this to work, at least
on the iOS simulator. If you're targeting a single orientation, override the Info.plist
template and set all orientations there.