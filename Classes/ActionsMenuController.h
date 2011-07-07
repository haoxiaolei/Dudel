//
//  ActionsMenuController.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/7/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ActionsMenuControllerDidSelect @"ActionsMenuControllerDidSelect"

typedef enum SelectedActionType {
	NoAction = -1,
	NewDocument,
	RenameDocument,
	DeleteDocument,
	EmailPdf,
	ShowAppInfo
} SelectedActionType;

@interface ActionsMenuController : UITableViewController {
	SelectedActionType selection;
	UIPopoverController *container;
}

@property (readonly) SelectedActionType selection;
@property (nonatomic, assign) UIPopoverController *container;

@end
