//
//  TextTool.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/1/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "TextTool.h"
#import "TextDrawingInfo.h"
#import "SynthesizeSingleton.h"

#define SHADE_TAG	10000

static CGFloat distanceBetween(const CGPoint p1, const CGPoint p2)
{
	return sqrt(pow(p1.x-p2.x, 2) + pow(p1.y-p2.y, 2));
}

@implementation TextTool
@synthesize delegate, completedPath;
SYNTHESIZE_SINGLETON_FOR_CLASS(TextTool);

- init {
	if (self = [super init]) {
		trackingTouches = [[NSMutableArray array] retain];
		startPoints = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)activate {
}

- (void)deactivate {
	[trackingTouches removeAllObjects];
	[startPoints removeAllObjects];
	self.completedPath = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UIView *touchedView = [delegate viewForUseWithTool:self];
	[touchedView endEditing:YES];
	
	UITouch *touch = [[event allTouches] anyObject];
	
	[trackingTouches addObject:touch];
	CGPoint location = [touch locationInView:touchedView];
	[startPoints addObject:[NSValue valueWithCGPoint:location]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UIView *touchedView = [delegate viewForUseWithTool:self];
	for (UITouch *touch in [event allTouches]) {
		NSUInteger touchIndex = [trackingTouches indexOfObject:touch];
		
		if (touchIndex != NSNotFound) {
			CGPoint startPoint = [[startPoints objectAtIndex:touchIndex] CGPointValue];
			CGPoint endPoint = [touch locationInView:touchedView];
			[trackingTouches removeObjectAtIndex:touchIndex];
			[startPoints removeObjectAtIndex:touchIndex];
			
			// Ignore any small region that will not be able to Input any Text.
			if (distanceBetween(startPoint, endPoint) < 5.0) {
				return;
			}
			
			// Create a Gray Shadow Background to Make the UITextView more clear.
			CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
			self.completedPath = [UIBezierPath bezierPathWithRect:rect];
			UIView *backgroundShade = [[[UIView alloc] initWithFrame:touchedView.bounds] autorelease];
			backgroundShade.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
			backgroundShade.tag = SHADE_TAG;
			backgroundShade.userInteractionEnabled = NO;
			[touchedView addSubview:backgroundShade];
			
			// Create the UITextView
			UITextView *textView = [[[UITextView alloc] initWithFrame:rect] autorelease];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
			
			// Process the Keyboard Size
			CGFloat keyboardHeight = 0;
			
			UIInterfaceOrientation orientation = ((UIViewController *)delegate).interfaceOrientation;
			if (UIInterfaceOrientationIsPortrait(orientation)) {
				keyboardHeight = 264;
			}
			else {
				keyboardHeight = 352;
			}
			CGRect viewBounds = touchedView.bounds;
			CGFloat rectMaxY = rect.origin.y + rect.size.height;
			CGFloat availableHeight = viewBounds.size.height - keyboardHeight;
			
			if (rectMaxY > availableHeight) {
				viewSlideDistance = rectMaxY - availableHeight;
			}
			else {
				viewSlideDistance = 0;
			}

			textView.delegate = self;
			[touchedView addSubview:textView];
			
			textView.editable = NO;
			textView.editable = YES;
			[touchedView becomeFirstResponder];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)drawTemporary {
	if (self.completedPath) {
		[delegate.strokeColor setStroke];
		[self.completedPath stroke];
	} else {
		UIView *touchedView = [delegate viewForUseWithTool:self];
		
		for (int i = 0; i < [trackingTouches count]; i++) {
			UITouch *touch = [trackingTouches objectAtIndex:i];
			CGPoint startPoint = [[startPoints objectAtIndex:i] CGPointValue];
			CGPoint endPoint = [touch locationInView:touchedView];
			CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
			UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
			[delegate.strokeColor setStroke];
			[path stroke];
		}
	}

}

- (void)dealloc {
	self.completedPath = nil;
	[trackingTouches release];
	[startPoints release];
	self.delegate = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark KeyBoard Show and Hide
- (void)keyboardWillShow:(NSNotification *)aNotification {
	UIInterfaceOrientation orientation = ((UIViewController *)delegate).interfaceOrientation;
	[UIView beginAnimations:@"viewSlideUp" context:nil];
	UIView *view = [delegate viewForUseWithTool:self];
	CGRect frame = [view frame];
	
	switch (orientation) {
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x -= viewSlideDistance;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x += viewSlideDistance;
			break;
		case UIInterfaceOrientationPortrait:
			frame.origin.y -= viewSlideDistance;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y += viewSlideDistance;
			break;
		default:
			break;
	}
	[view setFrame:frame];
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
	UIInterfaceOrientation orientation = ((UIViewController *)delegate).interfaceOrientation;
	[UIView beginAnimations:@"viewSlideDown" context:nil];
	UIView *view = [delegate viewForUseWithTool:self];
	CGRect frame = [view frame];
	
	switch (orientation) {
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x += viewSlideDistance;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x -= viewSlideDistance;
			break;
		case UIInterfaceOrientationPortrait:
			frame.origin.y += viewSlideDistance;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y -= viewSlideDistance;
			break;
		default:
			break;
	}
	[view setFrame:frame];
	[UIView commitAnimations];
}
#pragma mark -
#pragma mark UITextView Delegate Methods

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSLog(@"textViewDidEndEditing");
	TextDrawingInfo *info = [TextDrawingInfo textDrawingInfoWithPath:completedPath text:textView.text strokeColor:delegate.strokeColor font:delegate.font];
	[delegate addDrawable:info];
	
	self.completedPath = nil;
	UIView *superView = [textView superview];
	[[superView viewWithTag:SHADE_TAG] removeFromSuperview];
	[textView resignFirstResponder];
	[textView removeFromSuperview];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
