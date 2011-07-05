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

@interface DudelViewController : UIViewController <ToolDelegate, DudelViewDelegate, UIPopoverControllerDelegate> {
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
	UIPopoverController *currentPopover;
}
@property (nonatomic, retain) id <Tool> currentTool;
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIPopoverController *currentPopover;

- (IBAction)touchTextItem:(id)sender;
- (IBAction)touchFreehandItem:(id)sender;
- (IBAction)touchEllipseItem:(id)sender;
- (IBAction)touchRectangleItem:(id)sender;
- (IBAction)touchLineItem:(id)sender;
- (IBAction)touchPencilItem:(id)sender;
- (void)deselectAllToolButtons;

- (IBAction)popoverFontName:(id)sender;
- (IBAction)popoverFontSize:(id)sender;
- (IBAction)popoverStrokeWidth:(id)sender;
- (IBAction)popoverStrokeColor:(id)sender;
- (IBAction)popoverFillColor:(id)sender;

- (void)handleDismissedPopoverController:(UIPopoverController *)popoverController;
- (BOOL)saveCurrentToFile:(NSString *)filename;
- (BOOL)loadFromFile:(NSString *)filename;
@end

