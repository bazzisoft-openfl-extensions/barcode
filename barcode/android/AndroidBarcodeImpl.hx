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
    
    public function ScanBarcode() : Bool
    {
        var barcodeScanner = JNI.createStaticMethod("com.zerooneinsights.barcode.BarcodeScanner", "ScanBarcode", "()Z", false);
        var result:Bool = barcodeScanner();
        
        if (!result)
        {
            trace("Barcode scanner not installed. Install from:\nmarket://details?id=com.google.zxing.client.android\n   -- or --\nhttps://play.google.com/store/apps/details?id=com.google.zxing.client.android");
        }
        else
        {
            trace("Barcode scanner launched.");
        }
        
        return result;
    }
}