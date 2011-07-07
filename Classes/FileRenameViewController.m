    //
//  FileRenameViewController.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/7/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "FileRenameViewController.h"
#import "FileList.h"

@implementation FileRenameViewController
@synthesize delegate;
@synthesize originalFilename;
@synthesize changedFilename;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	textField.text = [[originalFilename lastPathComponent] stringByDeletingPathExtension];
	textLabel.text = @"Please enter a new file name for the current Dudel.";
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[textField becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.delegate = nil;
	self.originalFilename = nil;
	self.changedFilename = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSString *dirPath = [originalFilename stringByDeletingLastPathComponent];
	self.changedFilename = [[dirPath stringByAppendingPathComponent:textField.text] stringByAppendingPathExtension:@"dudeldoc"];
	if ([[FileList sharedFileList].allFiles containsObject:self.changedFilename]) {
		textLabel.text = @"A file with that name already exists! please enter a different file name.";
	} else {
		[[FileList sharedFileList] renameFile:self.originalFilename to:self.changedFilename];
		[delegate fileRenameViewController:self didRename:originalFilename to:changedFilename];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField endEditing:YES];
	return YES;
}

@end
