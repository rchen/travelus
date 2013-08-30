//
//  RCMainViewController.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCMainViewController.h"
#import "RCAppDelegate.h"
#import "RCAnnotation.h"
#import "RCDetailListViewController.h"

#define METERS_PER_MILE 500
@interface NSString (format)
+ (NSString *)stringWithDate:(NSDate *)date;
@end

@interface RCMainViewController ()
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableDictionary *distanceMap;
@property (nonatomic, strong)CLLocation *userLocation;
@end

@implementation RCMainViewController
@synthesize dataArray;
@synthesize distanceMap;
@synthesize userLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchRequest:) name:@"com.travelus.filter" object:nil];
    if ([CLLocationManager locationServicesEnabled]) {
    }
    self.userLocation = [[CLLocation alloc]initWithLatitude:35.681381 longitude:139.766083];
    [self fetchRequest:nil];
    self.distanceMap = [[NSMutableDictionary alloc]init];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"com.travelus.filter" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)fetchRequest:(NSNotification *)filter {
    NSString *titleString = @"東京行-%@";
    /* remove all annotation */
    for (id poi in self.mapView.annotations)
        if ([poi isKindOfClass:[RCAnnotation class]])
            [self.mapView removeAnnotation:poi];
    /* filter */
    if (filter.userInfo == nil) {
        self.title = [NSString stringWithFormat:titleString, @"全部行程"];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
        self.dataArray = [CONTEXT executeFetchRequest:request error:nil];
        /* sort */
        self.dataArray = [dataArray sortedArrayUsingComparator:^NSComparisonResult(POI *obj1, POI *obj2){
            if (obj1.distance > obj2.distance)
                return NSOrderedDescending;
            else
                return NSOrderedAscending;
        }];
    } else {
        Itinerary *itinerary = [filter.userInfo objectForKey:@"itinerary"];
        self.title = [NSString stringWithFormat:titleString, [NSString stringWithDate:itinerary.calendar]];
        
        self.dataArray = [[itinerary.pois allObjects]sortedArrayUsingComparator:^NSComparisonResult(POI *obj1, POI *obj2){
            if (obj1.sequence > obj2.sequence)
                return NSOrderedDescending;
            else
                return NSOrderedAscending;
        }];
    }
    // get distance and sort
    if ([dataArray count] != 0) {
        for (POI *poi in dataArray) {
            /* get distance */
            CLLocation *poiLocation = [[CLLocation alloc]initWithLatitude:[poi.latitude doubleValue]  longitude:[poi.longitude doubleValue]];
            CLLocationDistance distance = [poiLocation distanceFromLocation:userLocation];
            poi.distance = distance;
            RCAnnotation *annotation = [[RCAnnotation alloc]initWithPOI:poi];
            [self.mapView addAnnotation:annotation];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if ([dataArray count] != 0) {
        POI *poi = [dataArray objectAtIndex:0];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([poi.latitude doubleValue], [poi.longitude doubleValue]);
        [self goToRegion: coordinate];
    }
}

- (void)goToRegion:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1 * METERS_PER_MILE,1 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(RCFlipsideViewController *)controller
{
    [self.flipsidePopoverController dismissPopoverAnimated:YES];
    self.flipsidePopoverController = nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.flipsidePopoverController = popoverController;
        popoverController.delegate = self;
    } else if ([[segue identifier]isEqualToString:@"DataList"]) {
        RCDetailListViewController *controller = [segue destinationViewController];
        controller.dataArray = dataArray;
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}
#pragma mark - MKMapViewDeleget
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[RCAnnotation class]]) {
        static NSString *identifier = @"RCAnnotation";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.pinColor = MKPinAnnotationColorPurple;
//            /**/
//			UILabel* lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 22, 14)];
//			lblNumber.textColor = [UIColor blackColor];
//			lblNumber.textAlignment = UITextAlignmentCenter;
//			lblNumber.font = [UIFont systemFontOfSize:14];
//			lblNumber.backgroundColor = [UIColor clearColor];
//			lblNumber.tag = 99;
//            lblNumber.text = @"A";
//			[annotationView addSubview:lblNumber];
//            annotationView.image = [UIImage imageNamed:@"location"];
        } else {
            annotationView.annotation = annotation;
        }
//        UILabel *lbNumber = (UILabel *)[annotationView viewWithTag:99];
//        int asciiCode = 65; 
//        lbNumber.text = [NSString stringWithFormat:@"%c", asciiCode + ((RCAnnotation *)annotation).cnt];
        return annotationView;
    }
    return nil;
}
@end
@implementation NSString (format)
+ (NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}
@end
