//
//  PencilTool.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"


@interface PencilTool : NSObject <Tool> {
	id <ToolDelegate> delegate;
	NSMutableArray *trackingTouches;
	NSMutableArray *startPoints;
	NSMutableArray *paths;
}
+ (PencilTool *)sharedPencilTool;

@end
