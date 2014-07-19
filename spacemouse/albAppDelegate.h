//
//  albAppDelegate.h
//  spacemouse
//
//  Created by Andrew Lovett-Barron on 7/18/14.
//  Copyright (c) 2014 alb. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IOKit/hid/IOHIDManager.h"

@interface albAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

// USB device added callback function
static void Handle_DeviceMatchingCallback(void *inContext,
          IOReturn inResult,
          void *inSender,
          IOHIDDeviceRef inIOHIDDeviceRef);

// USB device removed callback function
static void Handle_DeviceRemovalCallback(void *inContext,
         IOReturn inResult,
         void *inSender,
         IOHIDDeviceRef inIOHIDDeviceRef);

// USB Thing happens spacemouse YEAH!
static void Handle_DeviceDoingSomething(void *inContext,
                IOReturn inResult,
                void *inSender,
                IOHIDDeviceRef inIOHIDDeviceRef);

// Counts the number of devices in the device set (includes all USB devices that match our dictionary)
static long USBDeviceCount(IOHIDManagerRef HIDManager);


@end
