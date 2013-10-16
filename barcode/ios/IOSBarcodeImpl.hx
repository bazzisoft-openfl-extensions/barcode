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
    
    public function ScanBarcode() : Void
    {
        return m_cppScanBarcode();
    }
}
