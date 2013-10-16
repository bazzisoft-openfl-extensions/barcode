package barcode.android;

import cpp.Lib;
import haxekit.general.Logger.LogLevel;
import barcode.IBarcodeImpl;
import openfl.utils.JNI;


class AndroidBarcodeImpl implements IBarcodeImpl
{
    public function new() 
    {
        // Create links to external C functions
        //m_cppVersion = cpp.Lib.load("Barcode", "Version", 0); 
    }
    
    public function ScanBarcode() : Void
    {
        var barcodeScanner = JNI.createStaticMethod("com.zerooneinsights.barcode.BarcodeScanner", "ScanBarcode", "()V", false);
        barcodeScanner();
    }
}