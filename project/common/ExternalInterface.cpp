#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Barcode.h"


using namespace barcode;



static value barcode_scan_barcode()
{
    return alloc_bool(ScanBarcode());
}
DEFINE_PRIM (barcode_scan_barcode, 0);



extern "C" void barcode_main ()
{
    val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT(barcode_main);



extern "C" int barcode_register_prims()
{
    Initialize();
    return 0;
}