//
//  RCDetailListViewController.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/28.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCDetailListViewController.h"
#import "POI.h"
#import "RCPOICell.h"

@interface RCDetailListViewController ()

@end

@implementation RCDetailListViewController
@synthesize dataArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RCPOICell";
    RCPOICell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [RCPOICell cell];
        cell.userInteractionEnabled = YES;
    }
    POI *poi = [dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = poi.name;
    float distance =  poi.distance / 1000;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%2.1f", distance];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:indexPath.section]
//                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    POI *poi = [dataArray objectAtIndex:indexPath.row];
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    CLLocation *location = locationManager.location;
    if (!location) {
        if (indexPath.row == 0) {
            location = [[CLLocation alloc]initWithLatitude:35.681381 longitude:139.766083];
        } else {
            POI *previousPOI =  [dataArray objectAtIndex:indexPath.row - 1];
            location = [[CLLocation alloc]initWithLatitude:[previousPOI.latitude doubleValue] longitude:[previousPOI.longitude doubleValue]];
        }
    }
    NSString *mapLink = [NSString stringWithFormat:@"?daddr=%@,%@&saddr=%f,%f", poi.latitude, poi.longitude, location.coordinate.latitude, location.coordinate.longitude];
    BOOL openurlflag= [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
    
    if(openurlflag){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://%@",mapLink]]];
    }else{
        NSURL *storyURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps%@",mapLink]];
        
        [[UIApplication sharedApplication] openURL:storyURL];
    }
}

@end
