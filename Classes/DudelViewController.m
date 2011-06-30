//
//  DudelViewController.m
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "DudelViewController.h"

#import "DudelView.h"

@implementation DudelViewController
@synthesize currentTool, fillColor, strokeColor, strokeWidth;

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
	
	self.fillColor = [UIColor lightGrayColor];
	self.strokeColor = [UIColor blackColor];
	self.strokeWidth = 2.0;
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
	
}

- (void)deselectAllToolButtons
{
	
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

@end