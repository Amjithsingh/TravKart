//
//  TKOffersViewController.m
//  TravKart
//
//  Created by AMJITH  on 20/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKOffersViewController.h"
#import "TKFirstViewController.h"
#import "Utility.h"

@interface TKOffersViewController ()
{
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UIWebView *homeWebView;

@end

@implementation TKOffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonAction:(id)sender {
    
    if ([_homeWebView canGoBack]) {
        [_homeWebView goBack];
    }
    else{
//        [self performSegueWithIdentifier:@"back_Offers" sender:self];
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

    self.homeWebView.delegate   =   self;
    if ([Utility reachable]) {
        
        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/last_minutes_app.php?&type=%@&appuserid=%@",userType,userID ];
        
        
        //@"http://www.travkart.com/mobapp/index.php?mobileapp=1&type=agent&appuserid=324";
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.homeWebView loadRequest:requestObj];
        
    }
    else{
        
        CGRect frame = [self.homeWebView frame];
        UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
        noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
        [self.view addSubview:noInternet];
        
    }
    
    
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    //self.activityLoaderView.hidden  =   NO;
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setColor:[UIColor orangeColor]];
    
    activityIndicator.frame = CGRectMake(200.0, 200.0, 100.0, 40.0);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
    
    [activityIndicator startAnimating];
    //[self.webLoader startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    
    //self.activityLoaderView.hidden  =   NO;
    //[self.webLoader stopAnimating];
    
    activityIndicator.hidden    =   YES;
    
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
