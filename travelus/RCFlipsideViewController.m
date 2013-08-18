//
//  RCFlipsideViewController.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCFlipsideViewController.h"

@interface RCFlipsideViewController ()

@end

@implementation RCFlipsideViewController

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
