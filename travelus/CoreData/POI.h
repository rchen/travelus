//
//  POI.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/24.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Itinerary;

@interface POI : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSDate * daytime;
@property (nonatomic, retain) NSNumber * poiID;
@property (nonatomic, retain) Itinerary *itinerary;

@end
