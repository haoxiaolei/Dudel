//
//  TextTool.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface TextTool : NSObject <Tool, UITextViewDelegate> {
	id <ToolDelegate> delegate;
	NSMutableArray *trackingTouches;
	NSMutableArray *startPoints;
	UIBezierPath *completedPath;
	CGFloat viewSlideDistance;
}
@property (nonatomic, retain) UIBezierPath *completedPath;
+ (TextTool *)sharedTextTool;

@end
