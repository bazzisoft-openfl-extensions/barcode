#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "../include/ExternalInterface.h"


// We're playing a really silly game here.
// First we setup an observer object to receive NSNotification
// messages, specifically a notification whenever the app becomes
// active. Second, we dynamically add the application:openUrl 
// method to NME's UIApplicationDelegate, and this will be called
// every time the app is launched via a URL in the browser.
// The application:openUrl method sets some static data storing the
// URL it was invoked with, which is then returned by GetLaunchingUri().
// The applicationDidBecomeActive notification resets this stored URL 
// to NULL when the application is launched regularly.
//
// Note we also only return the actual URL once in the first call 
// to GetLaunchingUri() so subsequent resize events don't cause 
// the app to think it was re-launched via a URL.

static const int MAX_URL_SIZE = 1024;
static char s_launchingUri[MAX_URL_SIZE];
static bool s_launchingUriIsValid = false;
static bool s_wasJustLaunchedByUri = false;


//
// Function that dynamically implements the NMEAppDelegate.openURL callback and
// saves the URI application was launched from.
// For some reason we can't get this from a regular notification like above.
//
static BOOL ApplicationOpenURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation)
{
    const char* theUrl = [[url absoluteString] UTF8String];
    strncpy(s_launchingUri, theUrl, MAX_URL_SIZE);
    s_wasJustLaunchedByUri = true;
    s_launchingUriIsValid = true;
    return YES;
}


// 
// Converts a CGRect specified in points & without accounting for device
// orientation into a new CGRect in pixels and in the correct orientation.
//
static CGRect ConvertCGRectToPixelsAndOrientation(const CGRect& rect)
{
    UIWindow* topWindow = [[UIApplication sharedApplication] keyWindow];
    UIView* topView = topWindow.rootViewController.view;    
    CGFloat scaleFactor = topView.contentScaleFactor;
    CGRect resultRect;

    if (UIInterfaceOrientationIsPortrait(topWindow.rootViewController.interfaceOrientation)) 
    {
        resultRect.origin.x = rect.origin.x * scaleFactor;
        resultRect.origin.y = rect.origin.y * scaleFactor;
        resultRect.size.width = rect.size.width * scaleFactor;
        resultRect.size.height = rect.size.height * scaleFactor;
    } 
    else if (UIInterfaceOrientationIsLandscape(topWindow.rootViewController.interfaceOrientation))
    {
        resultRect.origin.x = rect.origin.y * scaleFactor;
        resultRect.origin.y = rect.origin.x * scaleFactor;
        resultRect.size.width = rect.size.height * scaleFactor;
        resultRect.size.height = rect.size.width * scaleFactor;
    }    

    return resultRect;
}


//
// This class receives notifications from the iOS system.
//

@interface NotificationObserver : NSObject 
{
}
- (void)ApplicationDidBecomeActive:(NSNotification *)notification;
- (void)UIKeyboardDidShow:(NSNotification *)notification;
- (void)UIKeyboardDidHide:(NSNotification *)notification;
@end


@implementation NotificationObserver
- (void)ApplicationDidBecomeActive:(NSNotification *)notification
{
    if (s_wasJustLaunchedByUri)
    {
        s_wasJustLaunchedByUri = false;
    }
    else
    {
        s_launchingUriIsValid = false;
    }
}

- (void)UIKeyboardDidShow:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
        
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = ConvertCGRectToPixelsAndOrientation(keyboardRect);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect = ConvertCGRectToPixelsAndOrientation(screenRect);
           
    // Trigger a MobileKeyboardPopupEvent.KEYBOARD_ACTIVATED event
    CallNativeCallbackHandler("native_platform.event.MobileKeyboardPopupEvent", 5, 
                              CSTRING, "mobile_keyboard_popup_activated", 
                              CINT, (int)(screenRect.size.width + 0.5), CINT, (int)(screenRect.size.height + 0.5), 
                              CINT, (int)(keyboardRect.size.height + 0.5), CINT, (int) (screenRect.size.height - keyboardRect.size.height + 0.5));
}

- (void)UIKeyboardDidHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
        
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardRect = ConvertCGRectToPixelsAndOrientation(keyboardRect);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect = ConvertCGRectToPixelsAndOrientation(screenRect);
            
    // Trigger a MobileKeyboardPopupEvent.KEYBOARD_ACTIVATED event
    CallNativeCallbackHandler("native_platform.event.MobileKeyboardPopupEvent", 5, 
                              CSTRING, "mobile_keyboard_popup_deactivated", 
                              CINT, (int)(screenRect.size.width + 0.5), CINT, (int)(screenRect.size.height + 0.5), 
                              CINT, 0, CINT, (int)(screenRect.size.height + 0.5));
}
@end


namespace NativePlatform 
{
    namespace General    
    {
        void Initialize()
        {
            class_addMethod(NSClassFromString(@"NMEAppDelegate"),
                            @selector(application:openURL:sourceApplication:annotation:),
                            (IMP) ApplicationOpenURL,
                            "B@:@@@@");
            
            // Request all necessary notifications
            
            NotificationObserver* notificationObserver = [[NotificationObserver alloc] init];
            
            [[NSNotificationCenter defaultCenter] addObserver:notificationObserver
                selector:@selector(ApplicationDidBecomeActive:)
                name:UIApplicationDidBecomeActiveNotification 
                object:nil];                
                
            [[NSNotificationCenter defaultCenter] addObserver:notificationObserver
                selector:@selector(UIKeyboardDidShow:)
                name:UIKeyboardDidShowNotification 
                object:nil];                

            [[NSNotificationCenter defaultCenter] addObserver:notificationObserver
                selector:@selector(UIKeyboardDidHide:)
                name:UIKeyboardDidHideNotification 
                object:nil];                                
        }
        
        const char* GetLaunchingUri() 
        {
            if (s_launchingUriIsValid)
            {
                s_launchingUriIsValid = false;
                s_wasJustLaunchedByUri = false;
                return s_launchingUri;
            }
            else
            {
                return NULL;
            }
        }
        
        void LaunchUri(const char* uri)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithUTF8String:uri]];
            [[UIApplication sharedApplication] openURL:url];
        }
        
        void ShowPhoneStatusBar(bool on)
        {
            BOOL hide = (on ? NO : YES);
            [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationNone];
        }
    }
}