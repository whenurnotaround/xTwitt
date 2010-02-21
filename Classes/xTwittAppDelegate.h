//
//  xTwittAppDelegate.h
//  xTwitt
//
//  Created by Yongpisanpop Papon on 2/21/10.
//  Copyright NAIST 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class xTwittViewController;

@interface xTwittAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    xTwittViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet xTwittViewController *viewController;

@end

