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
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filename = [[dirs objectAtIndex:0] stringByAppendingPathComponent:@"Untitled.dudeldoc"];
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

@end