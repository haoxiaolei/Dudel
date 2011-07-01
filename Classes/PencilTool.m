//
//  PencilTool.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "PencilTool.h"
#import "PathDrawingInfo.h"
#import "SynthesizeSingleton.h"

@implementation PencilTool
@synthesize delegate;
SYNTHESIZE_SINGLETON_FOR_CLASS(PencilTool);
- init {
	if ((self = [super init])) {
		trackingTouches = [[NSMutableArray array] retain];
		startPoints = [[NSMutableArray array] retain];
		paths = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)activate
{

}

- (void)deactivate
{
	[trackingTouches removeAllObjects];
	[startPoints removeAllObjects];
	[paths removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UIView *touchedView = [delegate viewForUseWithTool:self];
	for (UITouch *touch in [event allTouches]) {
		[trackingTouches addObject:touch];
		CGPoint location = [touch locationInView:touchedView];
		[startPoints addObject:[NSValue valueWithCGPoint:location]];
		UIBezierPath *path = [UIBezierPath bezierPath];
		path.lineCapStyle = kCGLineCapRound;
		[path moveToPoint:location];
		[path setLineWidth:delegate.strokeWidth];
		[path addLineToPoint:location];
		[paths addObject:path];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self deactivate];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in [event allTouches]) {
		NSUInteger touchIndex = [trackingTouches indexOfObject:touch];
		if (touchIndex != NSNotFound) {
			UIBezierPath *path = [paths objectAtIndex:touchIndex];
			PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:[UIColor clearColor] strokeColor:delegate.strokeColor];
			[delegate addDrawable:info];
			[trackingTouches removeObjectAtIndex:touchIndex];
			[startPoints removeObjectAtIndex:touchIndex];
			[paths removeObjectAtIndex:touchIndex];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UIView *touchedView = [delegate viewForUseWithTool:self];
	for (UITouch *touch in [event allTouches]) {
		NSUInteger touchIndex = [trackingTouches indexOfObject:touch];
		if(touchIndex != NSNotFound)
		{
			CGPoint location = [touch locationInView:touchedView];
			UIBezierPath *path = [paths objectAtIndex:touchIndex];
			[path addLineToPoint:location];
		}
	}
}

- (void)drawTemporary
{
	for (UIBezierPath *path in paths) {
		[delegate.strokeColor setStroke];
		[path stroke];
	}
}

- (void)dealloc
{
	[trackingTouches release];
	[startPoints release];
	[paths release];
	self.delegate = nil;
	[super dealloc];
}

@end

