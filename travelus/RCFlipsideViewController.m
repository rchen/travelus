//
//  RCFlipsideViewController.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCFlipsideViewController.h"
#import "RCAppDelegate.h"

@interface RCFlipsideViewController ()
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation RCFlipsideViewController
@synthesize dataArray;

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
    self.dataArray = [CONTEXT executeFetchRequest:request error:nil];
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
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DateListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"全部行程";
            break;
        default: {
            Itinerary *itinerary = [dataArray objectAtIndex:indexPath.row - 1];
            NSString *dateString = [NSString stringWithDate:itinerary.calendar];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", itinerary.titile, dateString];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *obj_dict = nil;
    if (indexPath.row != 0) {
        obj_dict = @{@"itinerary": [dataArray objectAtIndex:indexPath.row - 1]};
    }
    [self done:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"com.travelus.filter" object:nil userInfo:obj_dict];
}

@end
