//
//  TextDrawingInfo.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "TextDrawingInfo.h"
#import <CoreText/CoreText.h>

@implementation TextDrawingInfo
@synthesize path, strokeColor, font, text;
- (id)initWithPath:(UIBezierPath *)p text:(NSString *)t strokeColor:(UIColor *)s font:(UIFont *)f
{
	if (self = [self init]) {
		path = [p retain];
		text = [t copy];
		font = [f retain];
		strokeColor = [s retain];
	}
	return self;
}

+ (id)textDrawingInfoWithPath:(UIBezierPath *)p text:(NSString *)t strokeColor:(UIColor *)s font:(UIFont *)f
{
	return [[[self alloc] initWithPath:p text:t strokeColor:s font:f] autorelease];
}

- (void)dealloc
{
	self.path = nil;
	self.strokeColor = nil;
	self.font = nil;
	self.text = nil;
	[super dealloc];
}

- (void)draw
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:self.text] autorelease];
	[attrString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.strokeColor.CGColor range:NSMakeRange(0, [self.text length])];
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
	
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), self.path.CGPath, NULL);
	CFRelease(framesetter);
	if (frame) {
		CGContextSaveGState(context);
		
		CGContextTranslateCTM(context, 0, path.bounds.origin.y);
		CGContextScaleCTM(context, 1, -1);
		CGContextTranslateCTM(context, 0, -(path.bounds.origin.y + path.bounds.size.height));
		
		CTFrameDraw(frame, context);
		CGContextRestoreGState(context);
		CFRelease(frame);
	}
}
@end
