//
//  AppDelegate.m
//  TravKart
//
//  Created by Dunamis on 06/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
    }
    else {
        // iOS 8 or later
        // [START register_for_notifications]
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }

    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    
    /*
     
     //google sign in working copy
    
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;
   
    
    */
    
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
//    FBSDKLoginButton *login =   [[FBSDKLoginButton alloc] init];
//    login.delegate      =   self;
//    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}


//
//- (BOOL)application:(nonnull UIApplication *)application
//            openURL:(nonnull NSURL *)url
//            options:(nonnull NSDictionary<NSString *, id> *)options {
//    
//    
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//    
//    
//}



- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {



}
//
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    
//    if([[url scheme] isEqualToString:@"fb664458543711906"])
//
//    return [[FBSDKApplicationDelegate sharedInstance] application:app
//                                                          openURL:url
//                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//
//    else if ([[url scheme] isEqualToString:@"com.googleusercontent.apps.267540738096-sejd9tbku8f2iudrnvtc0d925juhmdbm"])
//    {
//        return [[GIDSignIn sharedInstance] handleURL:url
//                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//
//    }
//    
//    
//    else{
//        return NO;
//    }
//}
//

//- (BOOL)application:(nonnull UIApplication *)application
//            openURL:(nonnull NSURL *)url
//            options:(nonnull NSDictionary<NSString *, id> *)options {
//    
//
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//
//    
//}




- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
    
//    if([[GIDSignIn sharedInstance] handleURL:url
//                           sourceApplication:sourceApplication
//                                  annotation:annotation])
//    {
//        return YES;
//    }
//    else if([[FBSDKApplicationDelegate sharedInstance] application:application
//                                                           openURL:url
//                                                 sourceApplication:sourceApplication
//                                                        annotation:annotation
//             ])
//    {
//        return  YES;
//    }
//    return NO;
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    //if (error == nil) {
        
                // ...
    if (error == nil) {
       
        NSString *userId     = user.userID;                  // For client-side use only!
        NSString *idToken    = user.authentication.idToken; // Safe to send to the server
        NSString *fullName   = user.profile.name;
        NSString *givenName  = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email      = user.profile.email;
        
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      // ...
                                      if (!error) {
                                          // ...
                                          NSLog(@"%@",user.displayName);
                                          NSDictionary *statusText = @{@"statusText":
                                                                           [NSString stringWithFormat:@"Signed in user: %@",
                                                                            fullName]};
                                          [[NSNotificationCenter defaultCenter]
                                           postNotificationName:@"ToggleAuthUINotification"
                                           object:nil
                                           userInfo:statusText];
                                          return;
                                      }}] ;

       

        // ...
    }
    else {
        // ...
    }
    
    
    
        // [START_EXCLUDE]
                // [END_EXCLUDE]
        
        /* working copy
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            NSLog(@"Credential done");
            NSLog(@"%@", user.email);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoHomeVC" object:self];

        }];
        
    } else{
        // ...
        }
         
         */
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    
    // [START_EXCLUDE]
    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    // [END_EXCLUDE]
    // ...
}





// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
//        CWStatusBarNotification *notification = [CWStatusBarNotification new];
//        notification.notificationAnimationInStyle=CWNotificationAnimationStyleTop;
//        notification.notificationAnimationOutStyle=CWNotificationAnimationStyleTop;
//        notification.notificationStyle=CWNotificationStyleNavigationBarNotification;
//        notification.notificationLabelBackgroundColor = [UIColor blackColor ];
//        notification.notificationLabelTextColor = [UIColor whiteColor];
//        NSDictionary *dict1=[userInfo objectForKey:@"aps"];
//        NSDictionary *dict2=[dict1 objectForKey:@"alert"];
//        NSString *str=[dict2 objectForKey:@"title"];
//        NSString *str2=[dict2 objectForKey:@"body"];
//        [notification displayNotificationWithMessage:[NSString stringWithFormat:@"%@-%@",str,str2] forDuration:5.0f];
        
        
    }
    
    else
    {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
        
        
        // Pring full message.
        NSLog(@"%@", userInfo);
        _dict=userInfo;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"GoToMainViewController"];
        lvc.userinfodata=_dict;
        [(UINavigationController *)self.window.rootViewController pushViewController:lvc animated:NO];
    }
}
// [END receive_message]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm
{
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error)
     {
         if (error != nil) {
             NSLog(@"Unable to connect to FCM. %@", error);
         } else {
             NSLog(@"Connected to FCM.");
         }
     }];
}
// [END connect_to_fcm]


// [START disconnect_from_fcm]
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}
// [END disconnect_from_fcm]


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    
//    
//}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

//
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TravKart" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}

//- (NSManagedObjectContext *)managedObjectContext {
//    
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managedObjectContext = [NSManagedObjectContext new];
//        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
//    }
//    return _managedObjectContext;
//}


- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TravKart"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
