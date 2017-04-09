//
//  InitialViewController.m
//  TravKart
//
//  Created by AMJITH  on 05/02/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "InitialViewController.h"
#import "Utility.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Utility addtoplist:@"0" key:@"index" plist:@"TravKart_Info"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(btn_action) withObject:nil afterDelay:1.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btn_action {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    //NSString *userType  = [prefs stringForKey:@"User_type"];
    
//    if (![userID isEqualToString: @"0"])

    
    if ([userID  isEqual: @"0"]) {
        [self performSegueWithIdentifier:@"loginvc" sender:self];

    }
    else if (userID == nil)
    {
        [self performSegueWithIdentifier:@"loginvc" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"homevc" sender:self];

    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
