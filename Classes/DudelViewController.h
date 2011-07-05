//
//  DudelViewController.h
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DudelView.h"
#import "Tool.h"

@interface DudelViewController : UIViewController <ToolDelegate, DudelViewDelegate> {
	id <Tool> currentTool;
	IBOutlet DudelView *dudelView;
	IBOutlet UIBarButtonItem *textButton;
	IBOutlet UIBarButtonItem *freehandButton;
	IBOutlet UIBarButtonItem *ellipseButton;
	IBOutlet UIBarButtonItem *rectangleButton;
	IBOutlet UIBarButtonItem *lineButton;
	IBOutlet UIBarButtonItem *pencilButton;
	UIColor *strokeColor;
	UIColor *fillColor;
	CGFloat strokeWidth;
	UIFont	*font;
}
@property (nonatomic, retain) id <Tool> currentTool;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, retain) UIFont *font;
- (IBAction)touchTextItem:(id)sender;
- (IBAction)touchFreehandItem:(id)sender;
- (IBAction)touchEllipseItem:(id)sender;
- (IBAction)touchRectangleItem:(id)sender;
- (IBAction)touchLineItem:(id)sender;
- (IBAction)touchPencilItem:(id)sender;
- (void)deselectAllToolButtons;

@end

