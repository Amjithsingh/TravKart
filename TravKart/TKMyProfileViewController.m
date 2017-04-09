//
//  TKMyProfileViewController.m
//  TravKart
//
//  Created by AMJITH  on 19/03/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKMyProfileViewController.h"
#import "Utility.h"


@interface TKMyProfileViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *ProfileWebView;

@end

@implementation TKMyProfileViewController
- (IBAction)openSideBar:(id)sender {
    
      [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated
{
    //   http://www.travkart.com/mobapp/search-budget-mobile.php?&type=”user_type”&appuserid=”user_id”
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    
    self.ProfileWebView.delegate   =   self;
    if ([Utility reachable]) {
        
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/my-profile.php??&type=%@&appuserid=%@",userType,userID ];
        
        
        //@"http://www.travkart.com/mobapp/index.php?mobileapp=1&type=agent&appuserid=324";
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.ProfileWebView loadRequest:requestObj];
        
    }
    else{
        
        CGRect frame = [self.ProfileWebView frame];
        UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
        noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
        [self.view addSubview:noInternet];
        
    }
    
    
    
}



- (IBAction)gotoWallet:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
