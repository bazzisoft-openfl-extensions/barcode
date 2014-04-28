#include "Barcode.h"
#include "../iphone/BarcodeIPhone.h"


namespace barcode
{
    void Initialize()
    {
        #ifdef IPHONE
        iphone::InitializeIPhone();
        #endif
    }

    bool ScanBarcode()
    {
        #ifdef IPHONE
        return iphone::ScanBarcode();
        #else
        return false;
        #endif
    }
}