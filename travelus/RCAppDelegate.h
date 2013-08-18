//
//  RCAppDelegate.h
//  travelus
//
//  Created by Hsueh Cheng Chen on 13/8/19.
//  Copyright (c) 2013年 Grant Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
