//
//  AppDelegate.h
//  TravKart
//
//  Created by Dunamis on 06/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CWStatusBarNotification.h"
#import <ZDCChat/ZDCChat.h>

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
@import GoogleSignIn;
//@import ZDCChat;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property(strong,nonatomic)             NSDictionary *dict;

//@property (nonatomic) BOOL notificationIsDismissing;


- (void)saveContext;
//- (void)dismissNotification;


@end

