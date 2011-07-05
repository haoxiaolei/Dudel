//
//  FontListController.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/5/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FontListControllerDidSelect @"FontListControllerDidSelect"

@interface FontListController : UITableViewController {
	NSArray *fonts;
	NSString *selectedFontName;
	UIPopoverController *container;
}
@property (nonatomic, retain) NSArray *fonts;
@property (nonatomic, copy) NSString *selectedFontName;
@property (nonatomic, assign) UIPopoverController *container;

@end
