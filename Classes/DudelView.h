//
//  DudelView.h
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DudelViewDelegate

- (void)drawTemporary;

@end


@interface DudelView : UIView {
	NSMutableArray *drawables;
	IBOutlet id <DudelViewDelegate> delegate;
}
@property (nonatomic, retain) NSMutableArray *drawables;

@end
