//
//  PathDrawingInfo.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"

@interface PathDrawingInfo : NSObject <Drawable> {
	UIBezierPath *path;
	UIColor *fillColor;
	UIColor *strokeColor;
}
@property (nonatomic, retain) UIBezierPath *path;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *strokeColor;

- (id)initWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s;
+ (id)pathDrawingInfoWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s;

@end
