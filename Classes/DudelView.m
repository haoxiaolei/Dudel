//
//  DudelView.m
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "DudelView.h"

#import "Drawable.h"

@implementation DudelView
@synthesize drawables;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		drawables = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		drawables = [[NSMutableArray alloc] initWithCapacity:100];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
    for (<Drawable> d in drawables) {
		[d draw];
	}
	[delegate drawTemporary];
}


- (void)dealloc {
	[drawables release];
    [super dealloc];
}


@end
