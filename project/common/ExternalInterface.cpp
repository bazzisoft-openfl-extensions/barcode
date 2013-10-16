#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include <stdio.h>
#include "Barcode.h"


// This is required for some reason at least for iOS
// It seems to be called instead of InitializeExtension on iOS.
extern "C" int barcode_register_prims() 
{     
    printf("Barcode extension initializing...\n");
#ifdef IPHONE
    Barcode::Initialize();
#endif        
    return 0; 
}

extern "C" void BarcodeEntryPoint() 
{
    // Doesn't seem to be called.
}
DEFINE_ENTRY_POINT(BarcodeEntryPoint);



static value ScanBarcode()
{
#ifdef IPHONE
    return alloc_bool(Barcode::ScanBarcode());
#else
    return alloc_bool(false);
#endif    
}
DEFINE_PRIM(ScanBarcode, 0);

