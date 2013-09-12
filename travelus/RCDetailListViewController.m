//
//  RCDetailListViewController.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/28.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCDetailListViewController.h"
#import "RCDetailViewController.h"
#import "POI.h"
#import "RCPOICell.h"
#import "RCAppDelegate.h"

@interface RCDetailListViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong)POI *selectedPOI;
@end

@implementation RCDetailListViewController
@synthesize dataArray;
@synthesize editingDisplay;
@synthesize selectedPOI;

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
    if (editingDisplay)
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [self sortDataArray];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sortDataArray {
    self.dataArray = [dataArray sortedArrayUsingComparator:^NSComparisonResult(POI *obj1, POI *obj2){
        return [obj1.sequence compare:obj2.sequence];
    }];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *mutableArray = [dataArray mutableCopy];
        POI *poi = [mutableArray objectAtIndex:indexPath.row];
        [mutableArray removeObjectAtIndex:indexPath.row];
        [CONTEXT deleteObject:poi];
        int cnt = 0;
        for (POI *poi in mutableArray) {
            poi.sequence = [NSNumber numberWithInt:cnt];
            cnt ++;
        }
        [CONTEXT save:nil];
        self.dataArray = [NSArray arrayWithArray:mutableArray];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    POI *movePOI = [dataArray objectAtIndex:fromIndexPath.row];
    NSMutableArray *multableDataArray = [dataArray mutableCopy];
    [multableDataArray removeObjectAtIndex:fromIndexPath.row];
    [multableDataArray insertObject:movePOI atIndex:toIndexPath.row];
    self.dataArray = [NSArray arrayWithArray:multableDataArray];
    int cnt = 0;
    for (POI *poi in dataArray) {
        poi.sequence = [NSNumber numberWithInt:cnt];
        cnt ++;
    }
    [CONTEXT save:nil];
    [self sortDataArray];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPOI = [dataArray objectAtIndex:indexPath.row];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:selectedPOI.name delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"詳細內容", @"查看地圖", @"開啓Google Map", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    [actionSheet showInView:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RCDetailViewController *controller = segue.destinationViewController;
    controller.poi = selectedPOI;
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"Detail" sender:nil];
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"com.travelus.goregion" object:nil userInfo:@{@"poi": selectedPOI}];
            break;
        case 2:
            [self openGoogleRout];
            break;
        default:
            break;
    }
}

- (void)openGoogleRout {
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    CLLocation *location = locationManager.location;
    if (!location) {
        if ([selectedPOI.sequence isEqualToNumber:@0]) {
            location = [[CLLocation alloc]initWithLatitude:35.681381 longitude:139.766083];
        } else {
            POI *previousPOI =  [dataArray objectAtIndex:[dataArray indexOfObject:self.selectedPOI] - 1];
            location = [[CLLocation alloc]initWithLatitude:[previousPOI.latitude doubleValue] longitude:[previousPOI.longitude doubleValue]];
        }
    }
    NSString *mapLink = [NSString stringWithFormat:@"?daddr=%@,%@&saddr=%f,%f", selectedPOI.latitude, selectedPOI.longitude, location.coordinate.latitude, location.coordinate.longitude];
    BOOL openurlflag= [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
    
    if(openurlflag){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://%@",mapLink]]];
    }else{
        NSURL *storyURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps%@",mapLink]];
        
        [[UIApplication sharedApplication] openURL:storyURL];
    }
}
@end
