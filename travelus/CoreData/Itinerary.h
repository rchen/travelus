//
//  Itinerary.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/30.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class POI;

@interface Itinerary : NSManagedObject

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * itineraryID;
@property (nonatomic, retain) NSString * titile;
@property (nonatomic, retain) NSDate * calendar;
@property (nonatomic, retain) NSSet *pois;
@end

@interface Itinerary (CoreDataGeneratedAccessors)

- (void)addPoisObject:(POI *)value;
- (void)removePoisObject:(POI *)value;
- (void)addPois:(NSSet *)values;
- (void)removePois:(NSSet *)values;

@end
