Barcode
=======

This extension provides real-time barcode scanning functionality for iOS and Android, 
directly from the device's camera.

In iOS, it uses the ZBarSDK (http://zbar.sourceforge.net/iphone/) and the scanner is
integrated as a view inside the app.

In Android, it uses the Google/ZXing Barcode Scanner app as a service. This app
must be installed separately for barcode scanning to work. The extension provides
an indication if it's not installed when attempting to scan.


Dependencies
------------

- This extension implicitly includes `extensionkit` which must be available in a folder
  beside this one.
- The extension overrides the Xcode project file `project.pbxproj` in order to include 
  bundle resources required by the ZBarSDK library (iOS only).


Installation
------------

    git clone https://github.com/bazzisoft-openfl-extensions/extensionkit
    git clone https://github.com/bazzisoft-openfl-extensions/barcode
    lime rebuild extensionkit [linux|windows|mac|android|ios]
    lime rebuild barcode [linux|windows|mac|android|ios]


Usage
-----

### project.xml

    <include path="/path/to/barcode" />


### Haxe
    
    class Main extends Sprite
    {
    	public function new()
        {
    		super();

            Barcode.Initialize();

            stage.addEventListener(BarcodeScannedEvent.BARCODE_SCANNED, function(e) { trace(e); } );
            stage.addEventListener(BarcodeScannedEvent.BARCODE_SCAN_CANCELLED, function(e) { trace(e); });
    
            #if !mobile
            // When testing on flash/desktop, ScanBarcode() should return this barcode...
            Barcode.SetFakeScanBarcodeResult("1234-ABCD", "CODE-128");
            #end

            Barcode.ScanBarcode();

            ...
        }
    }


### XCode Project

Currently, the extension uses a hack to add additional bundle resources required
by the ZBarSDK library into the project. It uses a `<template/>` override to
replace the `project.pbxproj` file with additional Resource references and it 
copies the imagery in the `templates/PROJ/Classes` folder.

If you decide to disable this (remove `<template path="templates" />` from the 
extension's `include.xml`), ensure you manually add the imagery from
`barcode/project/iphone/ZBarSDK/Resources` into the top-level Resources
group in XCode.