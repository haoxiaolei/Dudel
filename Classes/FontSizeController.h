//
//  FontSizeController.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/5/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FontSizeController : UIViewController {
	IBOutlet UITextView *textView;
	IBOutlet UISlider *slider;
	IBOutlet UILabel *label;
	UIFont *font;
}
@property (nonatomic, retain) UIFont *font;
- (void)takeIntValueFrom:(id)sender;

@end
