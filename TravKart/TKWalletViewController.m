//
//  TKWalletViewController.m
//  TravKart
//
//  Created by AMJITH  on 24/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKWalletViewController.h"
#import "Utility.h"

@interface TKWalletViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *walletSegmentControl;
@property (weak, nonatomic) IBOutlet UIWebView *walletWebView;
@property (weak, nonatomic) IBOutlet UIView *activityLoaderView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *webLoader;

@end

@implementation TKWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSInteger selectedSegment = self.walletSegmentControl.selectedSegmentIndex;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];

    
    self.walletWebView.delegate = self;
    
    if ([Utility reachable]) {
        
      
        NSString* fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/travcash-transactions-apps.php?&type=%@&appuserid=%@",userType,userID];
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];
        
    }
    else{
        
        CGRect frame = [self.walletWebView frame];
        UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
        noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
        [self.view addSubview:noInternet];
        
    }
    
   
}
- (IBAction)backByn_Action:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];
}

- (IBAction)segmentSwitch:(id)sender {
    
    NSInteger selectedSegment = self.walletSegmentControl.selectedSegmentIndex;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    
    NSString *fullURL;

    
    
    if (selectedSegment == 1) {
        //toggle the correct view to be visible
        
        //http://www.travkart.com/mobapp/add_cash_app_new.php?&type=”user_type”&appuserid=”user_id”
        
        fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/add_cash_app_new.php?&type=%@&appuserid=%@",userType,userID];
        
        
        
    }
    else if(selectedSegment == 0){
        //toggle the correct view to be visible
        
        fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/travcash-transactions-apps.php?&type=%@&appuserid=%@",userType,userID];
        
        
    }
    else
    {
        
        fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/wallet-transactions-apps.php?&type=%@&appuserid=%@",userType,userID];
        
    }
    
    
    if ([Utility reachable]) {
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];
        
    }
    else{
        
        CGRect frame = [self.walletWebView frame];
        UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
        noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
        [self.view addSubview:noInternet];
        
    }

    

}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    self.activityLoaderView.hidden  =   NO;
    [self.webLoader startAnimating];
    [self.view bringSubviewToFront:self.activityLoaderView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
    self.activityLoaderView.hidden  =   YES;
    [self.webLoader stopAnimating];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    
//    CGRect frame = [self.walletWebView frame];
//    UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
//    noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
//    [self.view addSubview:noInternet];
//    

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

- (IBAction)walletControl:(id)sender {
}

- (IBAction)walletBtns:(id)sender {
    
    
    int selectedSegment    =   [sender tag];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    
    
    
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        
        //http://www.travkart.com/mobapp/add_cash_app_new.php?&type=”user_type”&appuserid=”user_id”
        
        [self.addMoney setBackgroundColor:[UIColor orangeColor]];
        [self.addMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.travcash setBackgroundColor:[UIColor whiteColor]];
        [self.travcash setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        [self.transactions setBackgroundColor:[UIColor whiteColor]];
        [self.transactions setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/add_cash_app_new.php?&type=%@&appuserid=%@",userType,userID];
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];
        
    }
    else if(selectedSegment == 1){
        //toggle the correct view to be visible
        
        
        [self.travcash setBackgroundColor:[UIColor orangeColor]];
        [self.travcash setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.addMoney setBackgroundColor:[UIColor whiteColor]];
        [self.addMoney setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
        [self.transactions setBackgroundColor:[UIColor whiteColor]];
        [self.transactions setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/travcash-transactions-apps.php?&type=%@&appuserid=%@",userType,userID];
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];
        
        //http://www.travkart.com/mobapp/travcash-transactions-apps.php?&type=”user_type”&appuserid=”user_id”
        
    }
    else
    {
        
        [self.transactions setBackgroundColor:[UIColor orangeColor]];
        [self.transactions setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
        [self.travcash setBackgroundColor:[UIColor whiteColor]];
        [self.travcash setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        [self.addMoney setBackgroundColor:[UIColor whiteColor]];
        [self.addMoney setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/wallet-transactions-apps.php?&type=%@&appuserid=%@",userType,userID];
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];
        
        
        //http://www.travkart.com/mobapp/wallet-transactions-apps.php?&type=”user_type”&appuserid=”user_id”
        
    }

}
@end
