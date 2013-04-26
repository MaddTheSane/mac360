/*
    MICE Xbox 360 Controller driver for Mac OS X
    Copyright (C) 2006-2013 Colin Munro
    
    DeviceItem.m - implementation of device wrapper class
    
    This file is part of Xbox360Controller.

    Xbox360Controller is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Xbox360Controller is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/
#import "DeviceItem.h"

static NSString* GetDeviceName(io_service_t device)
{
    NSString *deviceName = nil;
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	CFMutableDictionaryRef serviceProperties;
    NSDictionary *properties;
    
    if (IORegistryEntryCreateCFProperties(device, &serviceProperties, kCFAllocatorDefault, kNilOptions) != KERN_SUCCESS)
	{
        [pool drain];
		return nil;
	}
    properties = (NSDictionary*)serviceProperties;
    deviceName = [properties objectForKey:@kIOHIDProductKey];
    if (deviceName == nil)
        deviceName = [properties objectForKey:@"USB Product Name"];
    [deviceName retain];
    CFRelease(serviceProperties);
	[pool drain];
    return [deviceName autorelease];
}

@interface DeviceItem()

@property (retain, readwrite, setter=setDeviceName:) NSString *name;
@property (readwrite, setter=setInterface:) IOHIDDeviceInterface122** hidDevice;
@property (readwrite, setter=setForceFeedback:) FFDeviceObjectReference ffDevice;
@property (readwrite, setter=setDeviceHandle:) io_service_t rawDevice;

@end


@implementation DeviceItem

@synthesize name = deviceName;
@synthesize hidDevice = interface;
@synthesize ffDevice = forceFeedback;
@synthesize rawDevice = deviceHandle;

+ (id)allocateDeviceItemForDevice:(io_service_t)device
{
    DeviceItem *item;
    IOReturn ret;
    IOCFPlugInInterface **plugInInterface;
    SInt32 score=0;
    
    item=[[[DeviceItem alloc] init] autorelease];
    if(item==nil) goto fail;
    ret=IOCreatePlugInInterfaceForService(device,kIOHIDDeviceUserClientTypeID,kIOCFPlugInInterfaceID,&plugInInterface,&score);
    if(ret!=kIOReturnSuccess) goto fail;
    ret=(*plugInInterface)->QueryInterface(plugInInterface,CFUUIDGetUUIDBytes(kIOHIDDeviceInterfaceID122),(LPVOID)&item->interface);
    (*plugInInterface)->Release(plugInInterface);
    if(ret!=kIOReturnSuccess) goto fail;
	FFDeviceObjectReference FFItem = 0;
    FFCreateDevice(device,&FFItem);
	item.ffDevice = FFItem;
    item.rawDevice=device;
    item.name = GetDeviceName(device);
    return item;
fail:
    IOObjectRelease(device);
    return NULL;
}

- (void)dealloc
{
    if(deviceHandle != 0)
        IOObjectRelease(deviceHandle);
    if(interface != NULL)
        (*interface)->Release(interface);
    if(forceFeedback != 0)
        FFReleaseDevice(forceFeedback);
    [deviceName release];
    [super dealloc];
}

- (NSString*)name
{
    return deviceName;
}

- (void)finalize
{
	if(deviceHandle!=0) IOObjectRelease(deviceHandle);
    if(interface!=NULL) (*interface)->Release(interface);
    if(forceFeedback!=0) FFReleaseDevice(forceFeedback);
	[super finalize];
}

@end
