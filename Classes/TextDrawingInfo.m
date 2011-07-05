//
//  TextDrawingInfo.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "TextDrawingInfo.h"
#import <CoreText/CoreText.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] 
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

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

static NSString *fontFaceNameFromString(NSString *attrData) {
	NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
	NSString *faceName = nil;
	if ([attributeDataScanner scanUpToString:@"face=\"" intoString:NULL]) {
		[attributeDataScanner scanString:@"face=\"" intoString:NULL];
		if ([attributeDataScanner scanUpToString:@"\"" intoString:&faceName]) {
			return faceName;
		}
	}
	return nil;
}

static CGFloat fontSizeFromString(NSString *attrData) {
	NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
	NSString *sizeString = nil;
	if ([attributeDataScanner scanUpToString:@"size=\"" intoString:NULL]) {
		[attributeDataScanner scanString:@"size=\"" intoString:NULL];
		if ([attributeDataScanner scanUpToString:@"\"" intoString:&sizeString]) {
			return [sizeString floatValue];
		}
	}
	return 0.0;
}

static UIColor *fontColorFromString(NSString *attrData) {
	NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
	NSString *colorString = nil;
	UIColor *fontColor = nil;
	if ([attributeDataScanner scanUpToString:@"color=\"" intoString:NULL]) {
		[attributeDataScanner scanString:@"color=\"#" intoString:NULL];
		if ([attributeDataScanner scanUpToString:@"\"" intoString:&colorString]) {
			if ([colorString length] == 3) {
				// 3 Bits.
				NSString *stringR = [colorString substringWithRange:NSMakeRange(0, 1)];
				NSString *stringG = [colorString substringWithRange:NSMakeRange(1, 1)];
				NSString *stringB = [colorString substringWithRange:NSMakeRange(2, 1)];
				
				unsigned r, g, b;
				NSScanner *scannerR = [NSScanner scannerWithString:stringR];
				[scannerR scanHexInt:&r];
				NSScanner *scannerG = [NSScanner scannerWithString:stringG];
				[scannerG scanHexInt:&g];
				NSScanner *scannerB = [NSScanner scannerWithString:stringB];
				[scannerB scanHexInt:&b];
				r *= r, g *= g, b *= b;
				
				NSLog(@"R:%d, G:%d, B:%d", r, g, b);
				
				fontColor = RGB(r, g, b);
			} else if ([colorString length] == 6) {
				// 6 Bits.
				NSString *stringR = [colorString substringWithRange:NSMakeRange(0, 2)];
				NSString *stringG = [colorString substringWithRange:NSMakeRange(2, 2)];
				NSString *stringB = [colorString substringWithRange:NSMakeRange(4, 2)];
				
				unsigned r, g, b;
				NSScanner *scannerR = [NSScanner scannerWithString:stringR];
				[scannerR scanHexInt:&r];
				NSScanner *scannerG = [NSScanner scannerWithString:stringG];
				[scannerG scanHexInt:&g];
				NSScanner *scannerB = [NSScanner scannerWithString:stringB];
				[scannerB scanHexInt:&b];
				
				NSLog(@"R:%d, G:%d, B:%d", r, g, b);
				
				fontColor = RGB(r, g, b);
			}
			return fontColor;
		}
	}
	return nil;
}

- (NSAttributedString *)attributedStringFromMarkup:(NSString *)markup {
	NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
	NSString *nextTextChunk = nil;
	NSScanner *markupScanner = [NSScanner scannerWithString:markup];
	CGFloat fontSize = 0.0;
	NSString *fontFace = nil;
	UIColor *fontColor = nil;
	while (![markupScanner isAtEnd]) {
		[markupScanner scanUpToString:@"<" intoString:&nextTextChunk];
		[markupScanner scanString:@"<" intoString:NULL];
		if ([nextTextChunk length] >0) {
			CTFontRef currentFont = CTFontCreateWithName((CFStringRef)(fontFace ? fontFace : self.font.fontName), (fontSize != 0.0 ? fontSize : self.font.pointSize), NULL);
			UIColor *color = fontColor ? fontColor : self.strokeColor;
			NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(id)color.CGColor, kCTForegroundColorAttributeName, (id)currentFont, kCTFontAttributeName, nil];
			NSAttributedString *newPiece = [[[NSAttributedString alloc] initWithString:nextTextChunk attributes:attrs] autorelease];
			[attrString appendAttributedString:newPiece];
			CFRelease(currentFont);
		}
		NSString *elementData = nil;
		[markupScanner scanUpToString:@">" intoString:&elementData];
		[markupScanner scanString:@">" intoString:NULL];
		if (elementData) {
			if ([elementData length] > 3 && [[elementData substringToIndex:4] isEqual:@"font"]) {
				fontFace = fontFaceNameFromString(elementData);
				fontSize = fontSizeFromString(elementData);
				fontColor = fontColorFromString(elementData);
			} else if ([elementData length] > 4 && [[elementData substringToIndex:5] isEqual:@"/font"]) {
				// reset all values
				fontSize = 0.0;
				fontFace = nil;
				fontColor = nil;
			}
		}
	}
	return attrString;
}


- (void)draw
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:self.text] autorelease];
	//[attrString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.strokeColor.CGColor range:NSMakeRange(0, [self.text length])];
	
	NSAttributedString *attrString = [self attributedStringFromMarkup:self.text];
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
