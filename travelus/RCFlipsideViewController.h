//
//  RCFlipsideViewController.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCFlipsideViewController;

@protocol RCFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(RCFlipsideViewController *)controller;
@end

@interface RCFlipsideViewController : UIViewController

@property (weak, nonatomic) id <RCFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
