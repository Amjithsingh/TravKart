//
//  TKWalletViewController.h
//  TravKart
//
//  Created by AMJITH  on 24/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKWalletViewController : UIViewController
- (IBAction)walletControl:(id)sender;
- (IBAction)walletBtns:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addMoney;
@property (weak, nonatomic) IBOutlet UIButton *travcash;
@property (weak, nonatomic) IBOutlet UIButton *transactions;

@end
