//
//  MiceInverseLevelIndicator.m
//  Pref360Control
//
//  Created by C.W. Betts on 4/24/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MiceInverseLevelIndicator.h"


@implementation MiceInverseLevelIndicator

- (void)drawRect:(NSRect)dirtyRect
{
	NSBitmapImageRep *tmpRef = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:dirtyRect.size.width pixelsHigh:dirtyRect.size.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:YES colorSpaceName:NSCalibratedRGBColorSpace bitmapFormat:NSAlphaFirstBitmapFormat bytesPerRow:4 * dirtyRect.size.width bitsPerPixel:32];
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext: [NSGraphicsContext graphicsContextWithBitmapImageRep:tmpRef]];
	[super drawRect:dirtyRect];
	[NSGraphicsContext restoreGraphicsState];
	[tmpRef release];
}

@end
