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
extern "C" int nativeplatform_register_prims() 
{     
    printf("Barcode extension initializing...\n");
    return 0; 
}

extern "C" void EntryPoint() 
{
    // Doesn't seem to be called.
}
DEFINE_ENTRY_POINT(EntryPoint);



static value ScanBarcode()
{
    return alloc_null();
}
DEFINE_PRIM(ScanBarcode, 0);

