package barcode;

import barcode.event.BarcodeScannedEvent;
import extensionkit.ExtensionKit;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class Barcode
{
    public inline static var ANDROID_BARCODE_SCANNER_WEB_URL = "https://play.google.com/store/apps/details?id=com.google.zxing.client.android";
    public inline static var ANDROID_BARCODE_SCANNER_STORE_URL = "market://details?id=com.google.zxing.client.android";

    #if cpp
    private static var barcode_scan_barcode = null;
    #end

    #if android
    private static var barcode_scan_barcode_jni = null;
    #end

    private static var s_initialized:Bool = false;
    private static var s_fakeBarcode:String = null;
    private static var s_fakeBarcodeType:String = null;

    public static function Initialize() : Void
    {
        if (s_initialized)
        {
            return;
        }

        s_initialized = true;

        ExtensionKit.Initialize();

        #if cpp
        barcode_scan_barcode = Lib.load("barcode", "barcode_scan_barcode", 0);
        #end

        #if android
        barcode_scan_barcode_jni = JNI.createStaticMethod("org.haxe.extension.barcode.Barcode", "ScanBarcode", "()Z");
        #end
    }

    /**
     * Triggers the native/java barcode scanning functionality. On non-supported platforms,
     * dispatches a simulated BarcodeScannedEvent if SetFakeBarcodeResult() was set.
     *
     * @return true if the barcode reader was successfully launched.
     *         false if:
     *              ANDROID - The Barcode Scanner app is not installed on the device.
     *                        (https://play.google.com/store/apps/details?id=com.google.zxing.client.android)
     *              !MOBILE - SetFakeScanBarcodeResult() was not called previously.
     */
    public static function ScanBarcode() : Bool
    {
        #if android

        var ret = barcode_scan_barcode_jni();
        if (!ret)
        {
            trace("BarcodeScanner app not installed. Install from:\n" + ANDROID_BARCODE_SCANNER_STORE_URL + "\n   -- or --\n" + ANDROID_BARCODE_SCANNER_WEB_URL);
        }
        return ret;

        #elseif (cpp && mobile)

        return barcode_scan_barcode();

        #else

        if (s_fakeBarcode != null)
        {
            SimulateBarcodeScanned(s_fakeBarcode, s_fakeBarcodeType);
            return true;
        }
        else
        {
            trace("Barcode.ScanBarcode() is not supported on this platform.");
            return false;
        }

        #end
    }

    /**
     * Sets a fake barcode to return as a BarcodeScannedEvent when running
     * on a platform that doesn't support barcode scanning.
     */
    public static function SetFakeScanBarcodeResult(barcode:String, barcodeType:String = "") : Void
    {
        s_fakeBarcode = barcode;
        s_fakeBarcodeType = barcodeType;
    }

    /**
     * Dispatches the BarcodeScannedEvent for the given barcode.
     */
    public static function SimulateBarcodeScanned(barcode:String, barcodeType:String = "") : Void
    {
        ExtensionKit.stage.dispatchEvent(new BarcodeScannedEvent(BarcodeScannedEvent.BARCODE_SCANNED, barcodeType, barcode));
    }

    /**
     * Dispatches the BarcodeScannedEvent indicating cancellation of a scan.
     */
    public static function SimulateBarcodeScanCancelled() : Void
    {
        ExtensionKit.stage.dispatchEvent(new BarcodeScannedEvent(BarcodeScannedEvent.BARCODE_SCAN_CANCELLED));
    }

}