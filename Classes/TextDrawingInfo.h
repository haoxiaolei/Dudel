//
//  TextDrawingInfo.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"

@interface TextDrawingInfo : NSObject <Drawable> {
	UIBezierPath *path;
	UIColor *strokeColor;
	UIFont *font;
	NSString *text;
}
@property (nonatomic, retain) UIBezierPath *path;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;

- (id)initWithPath:(UIBezierPath *)p text:(NSString *)t strokeColor:(UIColor *)s font:(UIFont *)f;
+ (id)textDrawingInfoWithPath:(UIBezierPath *)p text:(NSString *)t strokeColor:(UIColor *)s font:(UIFont *)f;

@end
