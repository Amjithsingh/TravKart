//
//  TKSearchBudgetViewController.m
//  TravKart
//
//  Created by AMJITH  on 20/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKSearchBudgetViewController.h"
#import "TKFirstViewController.h"


@interface TKSearchBudgetViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *homeWebView;

@end

@implementation TKSearchBudgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonAction:(id)sender {
    if ([_homeWebView canGoBack]) {
        [_homeWebView goBack];
    }
    else{
//        [self performSegueWithIdentifier:@"back_Search" sender:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];

    }

}

//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    TKFirstViewController *vc = [segue destinationViewController];
//}



-(void) viewWillAppear:(BOOL)animated
{
    //   http://www.travkart.com/mobapp/search-budget-mobile.php?&type=”user_type”&appuserid=”user_id”
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];

    
    NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/search-budget-mobile.php?&type=%@&appuserid=%@",userType,userID];
    
    
    //@"http://www.travkart.com/mobapp/index.php?mobileapp=1&type=agent&appuserid=324";
    
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.homeWebView loadRequest:requestObj];
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
