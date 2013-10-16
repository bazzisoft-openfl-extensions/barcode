package barcode;

// Required to dynamically instantiate this class elsewhere
import barcode.event.BarcodeScannedEvent;
import barcode.IBarcodeImpl;
import barcode.NullBarcodeImpl;

#if android
import barcode.android.AndroidBarcodeImpl;
#elseif ios
import barcode.ios.IOSBarcodeImpl;
#end


/**
 * Provides a static interface to native functions of various devices.
 * 
 * Add to your project.xml:
 *   <android target-sdk-version="14" />
 * 
 * JNI Signature Info: http://dev.kanngard.net/Permalinks/ID_20050509144235.html
 */

class Barcode 
{
    public static function Initialize() : IBarcodeImpl
    {
        if (s_instance == null)
        {
#if android
            s_instance = new AndroidBarcodeImpl();
#elseif ios
            s_instance = new IOSBarcodeImpl();
#else
            s_instance = new NullBarcodeImpl();
#end
        }
        else
        {
            throw "Barcode.Initialize(): Barcode was previously initialized.";
        }
        
        return s_instance;
    }
    
    public static function Instance() : IBarcodeImpl
    {
        if (s_instance == null)        
        {
            throw "Barcode needs to be initialized with Initialize() in your main().";
        }
        
        return s_instance;
    }
    
    private static var s_instance:IBarcodeImpl = null;
}