//
//  RCAppDelegate.m
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import "RCAppDelegate.h"

#import "RCMainViewController.h"
#define ISIMPORT @"ImportPOI"

@implementation RCAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - import data
- (void)importTestData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"kml" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *itineraryTitle = [resultDict objectForKey:@"title"];
    NSNumber *itineraryID = [resultDict objectForKey:@"id"];

    /* import all itinerary date */
    NSArray *allday = @[@"2013-09-17", @"2013-09-18", @"2013-09-19", @"2013-09-20", @"2013-09-21", @"2013-09-22", @"2013-09-23"];
    for (NSString *dateString in allday) {
        NSDate *date = [NSDate dateWithString:dateString];
        NSLog(@"%@",date);
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itineraryID == %@ AND calendar == %@", itineraryID, date];
        [request setPredicate:predicate];
        NSArray *array = [CONTEXT executeFetchRequest:request error:nil];
        Itinerary *itinerary = [array lastObject];
        if (itinerary == nil) {
            itinerary = [NSEntityDescription insertNewObjectForEntityForName:@"Itinerary" inManagedObjectContext:CONTEXT];
        }
        itinerary.titile = itineraryTitle;
        itinerary.itineraryID = itineraryID;
        itinerary.calendar = date;
        itinerary.detail = @"";
        [CONTEXT save:nil];
    }

    /* add or merge poi */
    NSArray *poisArray = [resultDict objectForKey:@"pois"];
    for (NSDictionary * dict in poisArray) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"POI"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"poiID==%@", [dict objectForKey:@"id"]];
        [request setPredicate:predicate];
        NSArray *array = [CONTEXT executeFetchRequest:request error:nil];
        POI *poi = [array lastObject];
        if (poi == nil) {
            poi = [NSEntityDescription insertNewObjectForEntityForName:@"POI" inManagedObjectContext:CONTEXT];
        }
        poi.name = [dict objectForKey:@"name"];
        poi.latitude = [dict objectForKey:@"latitude"];
        poi.longitude = [dict objectForKey:@"longitude"];
        poi.memo = [dict objectForKey:@"description"];
        poi.sequence = [dict objectForKey:@"sequence"];
        poi.poiID = [dict objectForKey:@"id"];
        NSString *dateString = [dict objectForKey:@"date"];
        if (dateString) {
            NSDate *date = [NSDate dateWithString:dateString];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itineraryID == %@ AND calendar == %@", itineraryID, date];
            [request setPredicate:predicate];
            NSArray *array = [CONTEXT executeFetchRequest:request error:nil];
            Itinerary *itinerary = [array lastObject];
            if (itinerary == nil) {
                itinerary = [NSEntityDescription insertNewObjectForEntityForName:@"Itinerary" inManagedObjectContext:CONTEXT];
            }
            itinerary.titile = itineraryTitle;
            itinerary.itineraryID = itineraryID;
            itinerary.calendar = date;
            itinerary.detail = @"";
            NSPredicate *poiPredicate = [NSPredicate predicateWithBlock:^BOOL(POI *poiItem, NSDictionary *bindings) {
                if (poiItem.poiID == poi.poiID)
                    return YES;
                else
                    return NO;
            }];
            NSArray *itemArray = [[itinerary.pois allObjects]filteredArrayUsingPredicate:poiPredicate];
            if (![itemArray count]) {
                [itinerary addPoisObject:poi];
            }
        }
    [CONTEXT save:nil];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:ISIMPORT];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self managedObjectContext];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:ISIMPORT]) {
        [self importTestData];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"travelus" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"travelus.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

@implementation NSDate (format)
+ (NSDate *)dateWithString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
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