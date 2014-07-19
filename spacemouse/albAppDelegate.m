//
//  albAppDelegate.m
//  spacemouse
//
//  Created by Andrew Lovett-Barron on 7/18/14.
//  Copyright (c) 2014 alb. All rights reserved.
//

#import "albAppDelegate.h"

@implementation albAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    // Insert code here to initialize your application
    
    // Create an HID Manager
    IOHIDManagerRef HIDManager = IOHIDManagerCreate(kCFAllocatorDefault,
        kIOHIDOptionsTypeNone);
    
    // Create a Matching Dictionary
    CFMutableDictionaryRef matchDict = CFDictionaryCreateMutable(kCFAllocatorDefault,
                 2,
                 &kCFTypeDictionaryKeyCallBacks,
                 &kCFTypeDictionaryValueCallBacks);

    // Specify a device manufacturer in the Matching Dictionary
    CFDictionarySetValue(matchDict,
            CFSTR(kIOHIDManufacturerKey),
            CFSTR("3Dconnexion"));
//    NSLog(@"Manf %@",kIOHIDManufacturerKey);

    // Register the Matching Dictionary to the HID Manager
    IOHIDManagerSetDeviceMatching(HIDManager, matchDict);
    
    // Register a callback for USB device detection with the HID Manager
    IOHIDManagerRegisterDeviceMatchingCallback(HIDManager, &Handle_DeviceMatchingCallback, NULL);
    // Register a callback fro USB device removal with the HID Manager
    IOHIDManagerRegisterDeviceRemovalCallback(HIDManager, &Handle_DeviceRemovalCallback, NULL);
    
    IOHIDManagerRegisterInputReportCallback(HIDManager,
       &Handle_DeviceDoingSomething, NULL);
    
    
    // Register the HID Manager on our app’s run loop
    IOHIDManagerScheduleWithRunLoop(HIDManager, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    
    // Open the HID Manager
    IOReturn IOReturn = IOHIDManagerOpen(HIDManager, kIOHIDOptionsTypeNone);
    if(IOReturn) NSLog(@"IOHIDManagerOpen failed.");
    else NSLog(@"IOHIDManagerOpen Success");
}



// New USB device specified in the matching dictionary has been added (callback function)
static void Handle_DeviceMatchingCallback(void *inContext,
                  IOReturn inResult,
                  void *inSender,
                  IOHIDDeviceRef inIOHIDDeviceRef){

// Log the device ID & device count
    NSLog(@"SpaceMouse device: %@\nSpaceMouse device count: %ld",
       (void *)inIOHIDDeviceRef,
        USBDeviceCount(inSender));
    
    NSLog(@"(IOHIDDeviceRef: %p)", inIOHIDDeviceRef);
    
}

// USB device specified in the matching dictionary has been removed (callback function)
static void Handle_DeviceRemovalCallback(void *inContext,
                           IOReturn inResult,
                           void *inSender,
                           IOHIDDeviceRef inIOHIDDeviceRef){

// Log the device ID & device countbr />
    NSLog(@"\nSpaceMouse device added: %p\nSpaceMouse device count: %ld",
          (void *)inIOHIDDeviceRef,
          USBDeviceCount(inSender));
}


// Yolo
static void Handle_DeviceDoingSomething(void *inContext,
                                          IOReturn inResult,
                                          void *inSender,
                                          IOHIDDeviceRef inIOHIDDeviceRef){
    
    // Log the device ID & device count
    NSLog(@"WOO");
//    NSLog(@"SpaceMouse device: %@\nSpaceMouse device count: %ld",
//          (void *)inIOHIDDeviceRef);
//    
//    NSLog(@"(IOHIDDeviceRef: %p)", inIOHIDDeviceRef);
    
}


// Counts the number of devices in the device set (incudes all USB devices that match our dictionary)
static long USBDeviceCount(IOHIDManagerRef HIDManager){

// The device set includes all USB devices that match our matching dictionary. Fetch it.
CFSetRef devSet = IOHIDManagerCopyDevices(HIDManager);
//NSLog(@"Log %@",devSet);
// The devSet will be NULL if there are 0 devices, so only try to count the devices if devSet exists
if(devSet) return CFSetGetCount(devSet);

// There were no matching devices (devSet was NULL), so return a count of 0
return 0;
}
    
@end
