#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "BarcodeIPhone.h"
#include "ExtensionKit.h"
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
// Delegate for notifications from the ZBar library.
//
@interface ZBarReaderDelegate : NSObject <ZBarReaderDelegate>
{
}
- (void) dismissReader:(UIImagePickerController*)reader;
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

    // raise an OpenFL event BarcodeScannedEvent.BARCODE_SCANNED
    extensionkit::DispatchEventToHaxe("barcode.event.BarcodeScannedEvent",
                                      extensionkit::CSTRING, "barcode_barcode_scanned",
                                      extensionkit::CSTRING, [symbol.typeName UTF8String],
                                      extensionkit::CSTRING, [symbol.data UTF8String],
                                      extensionkit::CEND);

    // dismiss with a slight delay to avoid conflicting with the reader view still updating
    [self performSelector:@selector(dismissReader:) withObject:reader afterDelay:0.0f];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)reader
{
    printf("Barcode scanning cancelled.\n");

    // raise an OpenFL event BarcodeScannedEvent.BARCODE_SCANNED
    extensionkit::DispatchEventToHaxe("barcode.event.BarcodeScannedEvent",
                                      extensionkit::CSTRING, "barcode_barcode_scan_cancelled",
                                      extensionkit::CEND);

    [self dismissReader:reader];
}

- (void) dismissReader:(UIImagePickerController*)reader
{
    // dismiss the controller (NB dismiss from the *reader*!)
    ((ZBarReaderViewController*) reader).readerDelegate = nil;
    [reader dismissViewControllerAnimated:YES completion:nil];
    [self release];
}
@end


namespace barcode
{
    namespace iphone
    {
        void InitializeIPhone()
        {
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
            reader.readerDelegate = [[ZBarReaderDelegate alloc] init];
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
}