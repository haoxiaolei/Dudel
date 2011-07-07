//
//  DudelViewController.m
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "DudelViewController.h"

#import "DudelView.h"
#import "PencilTool.h"
#import "TextTool.h"
#import "FontListController.h"
#import "FontSizeController.h"
#import "FileList.h"
#import "ActionsMenuController.h"


@implementation DudelViewController
@synthesize currentTool, fillColor, strokeColor, strokeWidth, font, currentPopover;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.currentTool = [PencilTool sharedPencilTool];
	self.fillColor = [UIColor lightGrayColor];
	self.strokeColor = [UIColor blackColor];
	self.strokeWidth = 2.0;
	self.font = [UIFont systemFontOfSize:24.0];
	
	// reload default document
//	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *filename = [[dirs objectAtIndex:0] stringByAppendingPathComponent:@"Untitled.dudeldoc"];
	NSString *filename = [FileList sharedFileList].currentFile;
	[self loadFromFile:filename];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
	
}

- (void)applicationWillTerminate:(NSNotification *)n {
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filename = [[dirs objectAtIndex:0] stringByAppendingPathComponent:@"Untitled.dudeldoc"];
	[self saveCurrentToFile:filename];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.currentTool = nil;
	self.fillColor = nil;
	self.strokeColor = nil;
}


- (void)dealloc {
	self.currentTool = nil;
	self.fillColor = nil;
	self.strokeColor = nil;
	self.currentPopover = nil;
    [super dealloc];
}

#pragma mark Functions

- (IBAction)touchFreehandItem:(id)sender
{

}

- (IBAction)touchEllipseItem:(id)sender
{
	
}

- (IBAction)touchRectangleItem:(id)sender
{
	
}

- (IBAction)touchLineItem:(id)sender
{
	
}

- (IBAction)touchPencilItem:(id)sender
{
	self.currentTool = [PencilTool sharedPencilTool];
}

- (IBAction)touchTextItem:(id)sender
{
	self.currentTool = [TextTool sharedTextTool];
	[self deselectAllToolButtons];
}

- (void)deselectAllToolButtons
{
	return;
}

// 只在 列表选项选定后再触发 通过通知.
- (void)fontListControllerDidSelect:(NSNotification *)notification {
	FontListController *flc = [notification object];
	UIPopoverController *popoverController = flc.container;
	[popoverController dismissPopoverAnimated:YES];
	[self handleDismissedPopoverController:popoverController];
	self.currentPopover = nil;
}

- (void)setupNewPopoverControllerForViewController:(UIViewController *)vc {
	if (self.currentPopover) {
		[self.currentPopover dismissPopoverAnimated:YES];
		[self handleDismissedPopoverController:self.currentPopover];
	}
	self.currentPopover = [[[UIPopoverController alloc] initWithContentViewController:vc] autorelease];
	self.currentPopover.delegate = self;
}

- (IBAction)popoverFontName:(id)sender {
	FontListController *flc = [[[FontListController alloc] initWithStyle:UITableViewStylePlain] autorelease];
	flc.selectedFontName = self.font.fontName;
	[self setupNewPopoverControllerForViewController:flc];
	flc.container = self.currentPopover;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontListControllerDidSelect:) name:FontListControllerDidSelect object:flc];
	[self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)popoverFontSize:(id)sender {
	FontSizeController *fsc = [[[FontSizeController alloc] initWithNibName:nil bundle:nil] autorelease];
	fsc.font = self.font;
	[self setupNewPopoverControllerForViewController:fsc];
	self.currentPopover.popoverContentSize = fsc.view.frame.size;
	[self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)popoverStrokeWidth:(id)sender {
}
- (IBAction)popoverStrokeColor:(id)sender {
}
- (IBAction)popoverFillColor:(id)sender {
}

- (void)popoverActionsMenu:(id)sender {
	ActionsMenuController *amc = [[[ActionsMenuController alloc] initWithNibName:nil bundle:nil] autorelease];
	[self setupNewPopoverControllerForViewController:amc];
	amc.container = self.currentPopover;
	self.currentPopover.popoverContentSize = CGSizeMake(320, 44 * 5);
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionsMenuControllerDidSelect:) name:ActionsMenuControllerDidSelect object:amc];
	[self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)actionsMenuControllerDidSelect:(NSNotification *)notification {
	ActionsMenuController *amc = [notification object];
	UIPopoverController *popoverController = amc.container;
	[popoverController dismissPopoverAnimated:YES];
	[self handleDismissedPopoverController:popoverController];
	self.currentPopover = nil;
}

- (void)createDocument {
	[self saveCurrentToFile:[FileList sharedFileList].currentFile];
	[[FileList sharedFileList] createAndSelectNewUntitled];
	dudelView.drawables = [NSMutableArray array];
	[dudelView setNeedsDisplay];
}

- (void)deleteCurrentDocumentWithConfirmation {
	[[[[UIAlertView alloc] initWithTitle:@"Delete current Dudel" message:@"This will remove your current drawing completely. Are you sure you want to do that?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete it!", nil] autorelease] show];
}

- (void)renameCurrentDocument {
	FileRenameViewController *controller = [[[FileRenameViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	controller.delegate = self;
	controller.modalPresentationStyle = UIModalPresentationFormSheet;
	controller.originalFilename = [FileList sharedFileList].currentFile;
	[self presentModalViewController:controller animated:YES];
}

- (void)showAppInfo {

}

- (void)sendPdfEmail {
	
}

#pragma mark FileRenameViewController Delegate Methods
- (void)fileRenameViewController:(FileRenameViewController *)c didRename:(NSString *)oldFilename to:(NSString *)newFilename {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		[[FileList sharedFileList] deleteCurrentFile];
		[self loadFromFile:[FileList sharedFileList].currentFile];
	}
}

- (void)setCurrentTool:(id <Tool>)t
{
	[currentTool deactivate];
	if(t != currentTool)
	{
		[currentTool release];
		currentTool = [t retain];
		currentTool.delegate = self;
		[self deselectAllToolButtons];
	}
	[currentTool activate];
	[dudelView setNeedsDisplay];
}

#pragma mark -
#pragma mark ToolDelegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[currentTool touchesBegan:touches withEvent:event];
	[dudelView setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[currentTool touchesCancelled:touches withEvent:event];
	[dudelView setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[currentTool touchesEnded:touches withEvent:event];
	[dudelView setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[currentTool touchesMoved:touches withEvent:event];
	[dudelView setNeedsDisplay];
}

- (void)addDrawable:(id <Drawable>)d
{
	[dudelView.drawables addObject:d];
	[dudelView setNeedsDisplay];
}

- (UIView *)viewForUseWithTool:(id <Tool>)t
{
	return self.view;
}

- (void)drawTemporary
{
	[self.currentTool drawTemporary];
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate Methods

- (void)handleDismissedPopoverController:(UIPopoverController *)popoverController {
	if ([popoverController.contentViewController isMemberOfClass:[FontListController class]]) {
		FontListController *flc = (FontListController *)popoverController.contentViewController;
		self.font = [UIFont fontWithName:flc.selectedFontName size:self.font.pointSize];
	} else if ([popoverController.contentViewController isMemberOfClass:[FontSizeController class]]) {
		FontSizeController *fsc = (FontSizeController *)popoverController.contentViewController;
		self.font =fsc.font;
	} else if ([popoverController.contentViewController isMemberOfClass:[ActionsMenuController class]]) {
		ActionsMenuController *amc = (ActionsMenuController *)popoverController.contentViewController;
		switch (amc.selection) {
			case NewDocument:
				[self createDocument];
				break;
			case RenameDocument:
				[self renameCurrentDocument];
				break;
			case DeleteDocument:
				[self deleteCurrentDocumentWithConfirmation];
				break;
			case EmailPdf:
				[self sendPdfEmail];
				break;
			case ShowAppInfo:
				[self showAppInfo];
				break;

			default:
				break;
		}
	}
	self.currentPopover = nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[self handleDismissedPopoverController:popoverController];
}

- (BOOL)saveCurrentToFile:(NSString *)filename {
	return [NSKeyedArchiver archiveRootObject:dudelView.drawables toFile:filename];
}

- (BOOL)loadFromFile:(NSString *)filename {
	id root = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
	if (root) {
		dudelView.drawables = root;
	}
	[dudelView setNeedsLayout];
	return (root != nil);
}

#pragma mark -
#pragma mark UISplitViewControllerDelegate Methods

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
	NSMutableArray *newItems = [[toolbar.items mutableCopy] autorelease];
	[newItems insertObject:barButtonItem atIndex:0];
	UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	[newItems insertObject:spacer atIndex:1];
	[toolbar setItems:newItems animated:YES];
	barButtonItem.title = @"My Dudels";
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	NSMutableArray *newItems = [[toolbar.items mutableCopy] autorelease];
	if ([newItems containsObject:barButtonItem]) {
		[newItems removeObject:barButtonItem];
		[newItems removeObjectAtIndex:0];
		[toolbar setItems:newItems animated:YES];
	}
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController
{
	if (self.currentPopover) {
		[self.currentPopover dismissPopoverAnimated:YES];
		[self handleDismissedPopoverController:self.currentPopover];
	}
	self.currentPopover = pc;
}

@end