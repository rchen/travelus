//
//  RCMainViewController.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCFlipsideViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RCMainViewController : UIViewController <RCFlipsideViewControllerDelegate, UIPopoverControllerDelegate, FBLoginViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (nonatomic, strong) IBOutlet FBLoginView *fbLoginView;
@end
