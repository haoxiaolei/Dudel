//
//  FileListViewController.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/5/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FileListControllerSelectedFile @"FileListControllerSelectedFile"
#define FileListControllerFilename @"FileListControllerFilename"

@interface FileListViewController : UITableViewController {
	NSString *currentDocumentFilename;
	NSArray *documents;
}
@property (nonatomic, copy) NSString *currentDocumentFilename;
@property (nonatomic, retain) NSArray *documents;

@end
