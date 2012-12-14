//
//  MyNSEvent.h
//  ScreenCapture
//
//  Created by Christian Sonntag on 20.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/NSEvent.h>


@interface MyNSEvent : NSEvent 

+(int) clickAtLocation: (NSPoint) pt;

@end
