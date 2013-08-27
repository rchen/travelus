//
//  RCAnnotation.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/25.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "POI.h"

@interface RCAnnotation :NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithPOI:(POI *)poi;
@end
