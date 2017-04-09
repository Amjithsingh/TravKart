//
//  TKRemoteImageTableViewCell.h
//  TravKart
//
//  Created by AMJITH  on 21/02/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKRemoteImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notification_title;
@property (weak, nonatomic) IBOutlet UILabel *notification_desc;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImage;
@end
