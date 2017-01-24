//
//  TKSecondViewController.m
//  TravKart
//
//  Created by AMJITH  on 16/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKSecondViewController.h"
#import "TKFirstViewController.h"

@interface TKSecondViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *homeWebView;

@end

@implementation TKSecondViewController


- (IBAction)backButtonAction:(id)sender {
    
    if ([_homeWebView canGoBack]) {
        [_homeWebView goBack];
    }
    else{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];

//        [self performSegueWithIdentifier:@"back_Flash" sender:self];
//
    }
}

//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    TKFirstViewController *vc = [segue destinationViewController];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self addLeftMenuButton];
    
}
-(void) viewWillAppear:(BOOL)animated
{
//    http://www.travkart.com/mobapp/package-listing.php?flashtype=flash&type=”user_type”&appuserid=”user_id”
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    
    
    NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/package-listing.php?flashtype=flash&type=%@&appuserid=%@",userType,userID];
    
    
    //@"http://www.travkart.com/mobapp/index.php?mobileapp=1&type=agent&appuserid=324";
    
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.homeWebView loadRequest:requestObj];
}

- (IBAction)openSideMenuAction:(id)sender {
    /*
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuRight atIndexPath:indexPath];
     */
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];

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
