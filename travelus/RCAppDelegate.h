//
//  RCAppDelegate.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Itinerary.h"
#import "POI.h"

#define CONTEXT ((RCAppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext

@interface RCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@interface NSString (format)
+ (NSString *)stringWithDate:(NSDate *)date;
@end

@interface NSDate (format)
+ (NSDate *)dateWithString:(NSString *)dateString;
@end
