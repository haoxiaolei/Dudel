//
//  Tool.h
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolDelegate;
@protocol Drawable;

@protocol Tool <NSObject>

@property (nonatomic, assign) id <ToolDelegate> delegate;

- (void)activate;
- (void)deactivate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)drawTemporary; 
@end

@protocol ToolDelegate

- (void)addDrawable:(id <Drawable>)d;
- (UIView *)viewForUseWithTool:(id <Tool>)t;
- (UIColor *)strokeColor;
- (UIColor *)fillColor;

@end

