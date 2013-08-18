//
//  RCMainViewController.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCFlipsideViewController.h"

@interface RCMainViewController : UIViewController <RCFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
