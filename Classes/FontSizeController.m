    //
//  FontSizeController.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/5/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "FontSizeController.h"


@implementation FontSizeController
@synthesize font;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	textView.font = self.font;
	NSInteger i = self.font.pointSize;
	label.text = [NSString stringWithFormat:@"%d", i];
	slider.value = i;
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
	self.font = nil;
    [super dealloc];
}

- (void)takeIntValueFrom:(id)sender {
	NSInteger size = ((UISlider *)sender).value;
	self.font = [self.font fontWithSize:size];
	textView.font = self.font;
	label.text = [NSString stringWithFormat:@"%d", size];
}


@end
