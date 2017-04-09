//
//  TKNotificationsViewController.h
//  TravKart
//
//  Created by AMJITH  on 20/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKNotificationsViewController : UIViewController
@property BOOL fromAppDelegate;
@property (weak, nonatomic) IBOutlet UILabel *notificationTitle;
@property NSString *NotificationUrl;

@end
