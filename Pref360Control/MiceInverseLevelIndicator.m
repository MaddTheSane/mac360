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
	NSBitmapImageRep *tmpRef = [[NSBitmapImageRep alloc] initWithFocusedViewRect:dirtyRect];
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext: [NSGraphicsContext graphicsContextWithBitmapImageRep:tmpRef]];
	[super drawRect:dirtyRect];
	[NSGraphicsContext restoreGraphicsState];
}

@end
