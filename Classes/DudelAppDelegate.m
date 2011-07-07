//
//  DudelAppDelegate.m
//  Dudel
//
//  Created by Hao Xiaolei on 6/30/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "DudelAppDelegate.h"
#import "DudelViewController.h"
#import "FileListViewController.h"
#import "FileList.h"

@implementation DudelAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize fileListViewController;
@synthesize splitViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch. 
    [self.window addSubview:splitViewController.view];
    [self.window makeKeyAndVisible];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileListControllerSelectedFile:) name:FileListControllerSelectedFile object:fileListViewController];
	return YES;
}

- (void)fileListControllerSelectedFile:(NSNotification *)n {
	NSString *oldFilename = [FileList sharedFileList].currentFile;
	[viewController saveCurrentToFile:oldFilename];
	NSString *filename = [[n userInfo] objectForKey:FileListControllerFilename];
	[FileList sharedFileList].currentFile = filename;
	[viewController loadFromFile:filename];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end
