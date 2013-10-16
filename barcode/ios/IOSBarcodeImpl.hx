package barcode.ios;
import cpp.Lib;
import barcode.IBarcodeImpl;


class IOSBarcodeImpl implements IBarcodeImpl
{
    public function new() 
    {
        // Create links to external C functions
        //m_cppVersion = cpp.Lib.load("Barcode", "Version", 0); 
    }
    
    public function ScanBarcode() : Void
    {
    }
}
