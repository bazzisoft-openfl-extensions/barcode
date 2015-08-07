Barcode
=======

### Real-time barcode scanning for iOS + Android

This extension provides real-time barcode scanning functionality for iOS and Android, 
directly from the device's camera.

In iOS, it uses the [ZBarSDK](http://zbar.sourceforge.net/iphone/) and the scanner is
integrated as a view inside the app.

In Android, it uses the [Google/ZXing Barcode Scanner](https://play.google.com/store/apps/details?id=com.google.zxing.client.android) app as a service. This app
must be installed separately for barcode scanning to work. The extension provides
an indication if it's not installed when attempting to scan.


Dependencies
------------

- This extension requires inclusion of `extensionkit` which must be available in a folder
  beside this one.
  
- On iOS, this extension requires extra resources to be added to the app. Manually add the imagery from
  `barcode/project/iphone/ZBarSDK/Resources` into the top-level Resources group in XCode.

  
Installation
------------

    git clone https://github.com/bazzisoft-openfl-extensions/extensionkit
    git clone https://github.com/bazzisoft-openfl-extensions/barcode
    lime rebuild extensionkit [linux|windows|mac|android|ios]
    lime rebuild barcode [linux|windows|mac|android|ios]


Usage
-----

### project.xml

    <include path="/path/to/extensionkit" />
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

Manually add the imagery from `barcode/project/iphone/ZBarSDK/Resources` 
into the top-level Resources group in XCode.
