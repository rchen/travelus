//
//  Itinerary.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/24.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class POI;

@interface Itinerary : NSManagedObject

@property (nonatomic, retain) NSString * titile;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * itineraryID;
@property (nonatomic, retain) NSSet *poi;
@end

@interface Itinerary (CoreDataGeneratedAccessors)

- (void)addPoiObject:(POI *)value;
- (void)removePoiObject:(POI *)value;
- (void)addPoi:(NSSet *)values;
- (void)removePoi:(NSSet *)values;

@end
