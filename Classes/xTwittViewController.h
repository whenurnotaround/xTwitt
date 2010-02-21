//
//  xTwittViewController.h
//  xTwitt
//
//  Created by Yongpisanpop Papon on 2/21/10.
//  Copyright NAIST 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGTwitterEngine.h"

@interface xTwittViewController : UIViewController <MGTwitterEngineDelegate> {
	
	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	
	MGTwitterEngine *twitterEngine;

}
@property(nonatomic, retain) UITextField *username;
@property(nonatomic, retain) UITextField *password;

-(IBAction)login;

@end

