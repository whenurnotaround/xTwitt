//
//  xTwittAppDelegate.m
//  xTwitt
//
//  Created by Yongpisanpop Papon on 2/21/10.
//  Copyright NAIST 2010. All rights reserved.
//

#import "xTwittAppDelegate.h"
#import "xTwittViewController.h"

@implementation xTwittAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
