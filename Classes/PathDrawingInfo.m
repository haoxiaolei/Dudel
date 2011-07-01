//
//  PathDrawingInfo.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "PathDrawingInfo.h"


@implementation PathDrawingInfo
@synthesize path, fillColor, strokeColor;
- (id)initWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s {
	if (self = [self init]) {
		path = [p retain];
		fillColor = [f retain];
		strokeColor = [s retain];
	}
	return self;
}

+ (id)pathDrawingInfoWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s {
	return [[[self alloc] initWithPath:p fillColor:f strokeColor:s] autorelease];
}

- (void)dealloc {
	self.path = nil;
	self.fillColor = nil;
	self.strokeColor = nil;
	[super dealloc];
}

- (void)draw {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	if (self.fillColor) {
		[self.fillColor setFill];
		[self.path fill];
	}
	if (self.strokeColor) {
		[self.strokeColor setStroke];
		[self.path stroke];
	}
	CGContextRestoreGState(context);
}

@end
