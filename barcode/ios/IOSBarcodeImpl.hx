package barcode.ios;
import cpp.Lib;
import barcode.IBarcodeImpl;


class IOSBarcodeImpl implements IBarcodeImpl
{
    public function new() 
    {
        // Create links to external C functions
        m_cppScanBarcode = cpp.Lib.load("barcode", "ScanBarcode", 0); 
    }
    
    public function ScanBarcode() : Bool
    {
        return m_cppScanBarcode();
    }
    
    private var m_cppScanBarcode:Void -> Bool;
}
