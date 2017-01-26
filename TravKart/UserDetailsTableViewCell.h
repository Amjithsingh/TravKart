//
//  UserDetailsTableViewCell.h
//  TravKart
//
//  Created by AMJITH  on 17/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *walletImg;
@property (weak, nonatomic) IBOutlet UIImageView *favorites;
@property (weak, nonatomic) IBOutlet UIImageView *bookings;

@end
