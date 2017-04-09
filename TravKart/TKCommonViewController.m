//
//  TKCommonViewController.m
//  TravKart
//
//  Created by AMJITH  on 22/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKCommonViewController.h"
#import "TKFirstViewController.h"
#import "TKHomeViewController.h"
#import "Utility.h"



@interface TKCommonViewController ()<UIWebViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *HomewebView;

@end

@implementation TKCommonViewController


- (IBAction)backButtonAction:(id)sender {
    
    if ([_HomewebView canGoBack]) {
        [_HomewebView goBack];
    }
    else{
//        self.HomewebView.delegate   =   nil;
//        self.HomewebView    =   nil;
//        [self performSegueWithIdentifier:@"common_Push" sender:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];

    }

}

//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    TKFirstViewController *vc = [segue destinationViewController];
//}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}



-(void) viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    
    
    int indexVal        =   [[Utility getfromplist:@"index" plist:@"TravKart_Info"] intValue];
    NSString *urlString;
    
    self.HomewebView.delegate   =   self;
    
    switch (indexVal) {
        case 111:
            self.titleLabel.text    =   @"My Bookings";
            urlString   =   [NSString stringWithFormat:@"http://www.travkart.com/mobapp/my_bookings_app.php?&type=%@&appuserid=%@",userType,userID];
            break;

        
        case  112:
            self.titleLabel.text    =   @"Favorites";
            urlString   =   [NSString stringWithFormat:@"http://www.travkart.com/mobapp/my_favourites.php?&type=%@&appuserid=%@",userType,userID];
            break;

            
        case 0:
            self.titleLabel.text    =   @"My Profile";
            urlString   =  [NSString stringWithFormat:@"http://www.travkart.com/mobapp/edit-my-profile.php?&type=%@&appuserid=%@",userType,userID];
            break;

        case 7:
            
            self.titleLabel.text    =   @"Theme Holidays";
            urlString   =  [NSString stringWithFormat:@"http://www.travkart.com/mobapp/theme-holidays-app.php?&type=%@&appuserid=%@",userType,userID];
            
            break;
        
        case 8:
            self.titleLabel.text    =   @"Domestic Packages";

            urlString   =   [NSString stringWithFormat:@"http://www.travkart.com/mobapp/domestic.php?&type=%@&appuserid=%@",userType,userID];

            break;
        
        case 9:
            
            self.titleLabel.text    =   @"International Packages";

            urlString   =  [NSString stringWithFormat:@"http://www.travkart.com/mobapp/international.php?&type=%@&appuserid=%@",userType,userID];

            break;
            
        case 10:
            
            self.titleLabel.text    =   @"Trending Holidays";

            urlString   =  [NSString stringWithFormat:@"http://www.travkart.com/mobapp/trending_holiday-app.php?&type=%@&appuserid=%@",userType,userID];
            
            break;
            
        case 11:
            
            //section
            break;
            
        case 12:
            self.titleLabel.text    =   @"Contact Us";

            urlString = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/contact-us.php?&type=%@&appuserid=%@",userType,userID];


            break;
            
        case 13:
        
            {
                self.titleLabel.text    =   @"Like us on Facebook";
            
                NSURL *facebookURL = [NSURL URLWithString:@"https://www.facebook.com/travkart/?ref=br_rs"];
                
                if([[UIApplication sharedApplication] canOpenURL:facebookURL])
                {
                [[UIApplication sharedApplication] openURL:facebookURL];
                }
                else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com"]];
                }
            //likeus
            }
            

            break;
            
        case 14:
            
            self.titleLabel.text    =   @"Refer and Earn";

            //refer and earn
            break;
            
        case 15:
            

            //others
            break;
            
        case 16:
            
            self.titleLabel.text    =   @"Share TravKart";
                        //refertofriend
            
            break;
            
        case 17:
            
            self.titleLabel.text    =   @"Rate the App";
            

            //rate app
            break;
            
        case 18:
            
            self.titleLabel.text    =   @"About Us";
            

            urlString = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/about-us-nw.php?&type=%@&appuserid=%@",userType,userID];

            break;
            
        case 19:
            
            self.titleLabel.text    =   @"Terms and Conditions";
            

            urlString = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/user_agreement.php?&type=%@&appuserid=%@",userType,userID];
            
            break;
            
        case 20:
            
            self.titleLabel.text    =   @"Privacy Policy";
            

            urlString = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/privacy.php?&type=%@&appuserid=%@",userType,userID];

            break;
            
        default:
            break;
    }
    
    
    if ([Utility reachable]) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.HomewebView loadRequest:requestObj];
        
    }
    else{
        
        CGRect frame = [self.HomewebView frame];
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
    
//    NSURL *currentURL   =   webView.request.URL;
    NSString *tempUrl   =   [NSString stringWithFormat:@"%@",webView.request.URL];
    NSArray *tempStr    =   [tempUrl componentsSeparatedByString:@"?"];
    NSArray *tempValue  =   [[tempStr objectAtIndex:1] componentsSeparatedByString:@"&"];
    NSArray *bookID     =   [[tempValue objectAtIndex:0] componentsSeparatedByString:@"="];
    NSArray *pkgID      =   [[tempValue objectAtIndex:1] componentsSeparatedByString:@"="];

    NSString *bookIDStr =   [bookID objectAtIndex:1];
    NSString *pkgIDStr  =   [pkgID objectAtIndex:1];

    if (![bookIDStr isEqualToString:@""]) {
        
        UIAlertView *alert  =   [[UIAlertView alloc] initWithTitle:@"Travkart" message:@"Do you want to download itinerary" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    activityIndicator.hidden    =   YES;
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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
