//
//  POI.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/30.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "POI.h"
#import "Itinerary.h"


@implementation POI

@dynamic latitude;
@dynamic longitude;
@dynamic memo;
@dynamic name;
@dynamic poiID;
@dynamic sequence;
@dynamic itinerary;
@synthesize distance = _distance;

- (void)setDistance:(CLLocationDistance)distance {
    _distance = distance;
}
@end
