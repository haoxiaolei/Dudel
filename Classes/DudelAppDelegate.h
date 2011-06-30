//
//  DudelAppDelegate.h
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DudelViewController;

@interface DudelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DudelViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DudelViewController *viewController;

@end

