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

#define METERS_PER_MILE 500

@interface RCMainViewController ()
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation RCMainViewController
@synthesize dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchRequest:) name:@"com.travelus.filter" object:nil];
    if ([CLLocationManager locationServicesEnabled]) {
    }
    [self fetchRequest:nil];
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
    for (id poi in self.mapView.annotations)
        if ([poi isKindOfClass:[RCAnnotation class]])
            [self.mapView removeAnnotation:poi];

    if (filter.userInfo == nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
        self.dataArray = [CONTEXT executeFetchRequest:request error:nil];
        for (POI *poi in dataArray) {
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
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1 * METERS_PER_MILE,1 * METERS_PER_MILE);
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
