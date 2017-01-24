//
//  TKWalletViewController.m
//  TravKart
//
//  Created by AMJITH  on 24/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKWalletViewController.h"

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

    NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/add_cash_app_new.php?&type=%@&appuserid=%@",userType,userID];
    
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.walletWebView loadRequest:requestObj];

}
- (IBAction)backByn_Action:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)segmentSwitch:(id)sender {
    
    NSInteger selectedSegment = self.walletSegmentControl.selectedSegmentIndex;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    

    
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        
        //http://www.travkart.com/mobapp/add_cash_app_new.php?&type=”user_type”&appuserid=”user_id”
        
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/add_cash_app_new.php?&type=%@&appuserid=%@",userType,userID];
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];
        
    }
    else if(selectedSegment == 1){
        //toggle the correct view to be visible
        
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/travcash-transactions-apps.php?&type=%@&appuserid=%@",userType,userID];
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];
        
    //http://www.travkart.com/mobapp/travcash-transactions-apps.php?&type=”user_type”&appuserid=”user_id”

    }
    else
    {
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/wallet-transactions-apps.php?&type=%@&appuserid=%@",userType,userID];
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.walletWebView loadRequest:requestObj];

        
        //http://www.travkart.com/mobapp/wallet-transactions-apps.php?&type=”user_type”&appuserid=”user_id”

    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    self.activityLoaderView.hidden  =   NO;
    [self.webLoader startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
    self.activityLoaderView.hidden  =   NO;
    [self.webLoader stopAnimating];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    
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
