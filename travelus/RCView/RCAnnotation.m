//
//  RCAnnotation.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/25.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCAnnotation.h"

@implementation RCAnnotation
@synthesize coordinate = _coordinate;

- (id)initWithPOI:(POI *)poi {
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake([poi.latitude doubleValue], [poi.longitude doubleValue]);
        _title = poi.name;
        _subtitle = poi.memo;
    }
    return self;
}
@end
