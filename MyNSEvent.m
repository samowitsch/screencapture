//
//  MyNSEvent.m
//  ScreenCapture
//
//  Created by Christian Sonntag on 20.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyNSEvent.h"
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

#import "MyNSEvent.h"

@implementation MyNSEvent

+(int) clickAtLocation: (NSPoint) pt {
 
 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 int x = pt.x;
 int y = pt.y;
 
 CGPoint ptCG;
 ptCG.x = x;
 ptCG.y = y;
 
 CGEventRef mouseDownEv = CGEventCreateMouseEvent(NULL,kCGEventLeftMouseDown,ptCG,kCGMouseButtonLeft);
 CGEventPost (kCGHIDEventTap, mouseDownEv);
 
 
 CGEventRef mouseUpEv = CGEventCreateMouseEvent(NULL,kCGEventLeftMouseUp,ptCG,kCGMouseButtonLeft);
 CGEventPost (kCGHIDEventTap, mouseUpEv );
 
 [pool release];
 return 0;    
 
}
@end