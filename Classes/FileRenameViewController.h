//
//  FileRenameViewController.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/7/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FileRenameViewControllerDelegate;

@interface FileRenameViewController : UIViewController <UITextFieldDelegate> {
	id <FileRenameViewControllerDelegate> delegate;
	NSString *originalFilename;
	NSString *changedFilename;
	IBOutlet UILabel *textLabel;
	IBOutlet UITextField *textField;
}
@property (nonatomic, retain) id <FileRenameViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *originalFilename;
@property (nonatomic, copy) NSString *changedFilename;

@end

@protocol FileRenameViewControllerDelegate

- (void)fileRenameViewController:(FileRenameViewController *)c didRename:(NSString *)oldFilename to:(NSString *)newFilename;

@end

