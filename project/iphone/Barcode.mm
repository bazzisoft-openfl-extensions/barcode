#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "../../../native_platform-0.2/project/include/ExternalInterface.h"
#include "ZBarSDK/Headers/ZBarSDK/ZBarSDK.h"


//
// Function that dynamically implements the NMEAppDelegate.supportedInterfaceOrientationsForWindow
// callback to allow portrait orientation even if app only supports landscape.
// This is required as barcode scanning camera simulator needs portrait mode.
//
static NSUInteger ApplicationSupportedInterfaceOrientationsForWindow(id self, SEL _cmd, UIApplication* application, UIWindow* window)
{
    return UIInterfaceOrientationMaskAll;
}


//
// This class receives notifications from the iOS system.
//

@interface ZBarReaderDelegate : NSObject <ZBarReaderDelegate>
{
}
@end


@implementation ZBarReaderDelegate
- (void) imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol* symbol = nil;
    for (symbol in results)
        // just grab the first barcode
        break;

    // do something useful with the barcode data
    printf("Scanned barcode: type=%s, value=%s\n", [symbol.typeName UTF8String], [symbol.data UTF8String]);

    // dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    // raise an OpenFL event BarcodeScannedEvent.BARCODE_SCANNED
    CallNativeCallbackHandler("barcode.event.BarcodeScannedEvent", 3, CSTRING, "barcode_scanned", CSTRING, [symbol.typeName UTF8String], CSTRING, [symbol.data UTF8String]);
}
@end


static ZBarReaderDelegate* s_zbarReaderDelegate;


namespace Barcode
{
    void Initialize()
    {
        s_zbarReaderDelegate = [[ZBarReaderDelegate alloc] init];
        
        class_addMethod(NSClassFromString(@"NMEAppDelegate"),
                        @selector(application:supportedInterfaceOrientationsForWindow:),
                        (IMP) ApplicationSupportedInterfaceOrientationsForWindow,
                        "I@:@@");
    }
    
    bool ScanBarcode() 
    {
        // Get our topmost view controller
        UIViewController* topViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        
        // Present a barcode reader that scans from the camera feed
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = s_zbarReaderDelegate;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;

        ZBarImageScanner* scanner = reader.scanner;
        // TODO: (optional) additional reader configuration here
        // EXAMPLE: disable rarely used I2/5 to improve performance
        [scanner setSymbology: ZBAR_I25
                 config: ZBAR_CFG_ENABLE
                 to: 0];

        // present and release the controller
        [topViewController presentViewController:reader animated:YES completion:nil];              
        [reader release];

        return true;
    }
}