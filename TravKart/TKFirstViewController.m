//
//  TKFirstViewController.m
//  TravKart
//
//  Created by AMJITH  on 16/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKFirstViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Utility.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import GoogleSignIn;
@import FirebaseAuth;

@interface TKFirstViewController ()<UIWebViewDelegate,UITextFieldDelegate>
{
    UIActivityIndicatorView* activityIndicator;
}
@property (weak, nonatomic) IBOutlet UIWebView *homeWebView;
@property (weak, nonatomic) IBOutlet UIButton *logi_detail;
- (IBAction)loginOrLogout:(id)sender;

@end

@implementation TKFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addLeftMenuButton];
}
- (IBAction)callAction:(id)sender {
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"+918010038038"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (IBAction)floatingBtnAction:(id)sender {
    
  
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Select an enquiry method" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Request Call Back",@"Send Enquiry",@"Call Us", nil];
    
    [action showInView:self.view];
}

#pragma mark - ActionSheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) {
        
//        user_type   =   @"guest";
        
//        [self performSegueWithIdentifier:@"registration" sender:self];
        
    }else if( buttonIndex == 1 ) {
        
//        user_type   =   @"agent";
//        [self performSegueWithIdentifier:@"registrationAgent" sender:self];
    }
    else if( buttonIndex == 2){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"918010038038"]]];

    }
}


-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];

    
    self.homeWebView.delegate = self;
    
    if ([userID isEqualToString:@"0"]) {
        
        [self.logi_detail setImage:[UIImage imageNamed:@"login_icon_new.png"] forState:UIControlStateNormal];
    }
    else{
        [self.logi_detail setImage:[UIImage imageNamed:@"logo_out.png"] forState:UIControlStateNormal];

    }
    if ([Utility reachable]) {

        NSString *fullURL = [NSString stringWithFormat:@"http://www.travkart.com/mobapp/index.php?mobileapp=1&type=%@&appuserid=%@",userType,userID];
        
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.homeWebView loadRequest:requestObj];
        //self.homeWebView loadRequest:[NSURL req]

    }
    else{
        CGRect frame = [self.homeWebView frame];
        UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
        noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
        [self.view addSubview:noInternet];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







- (IBAction)openSideMenuAction:(id)sender {
    /*
     AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [mainVC openContentViewControllerForMenu:AMSlideMenuRight atIndexPath:indexPath];
     */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginOrLogout:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"User_type"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"agentID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"markupclass"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"usermail"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"usermobile"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"userphone"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"userphoto"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_master_user"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[GIDSignIn sharedInstance] signOut];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    NSError *signOutError;
    [FBSDKAccessToken setCurrentAccessToken:nil];

    
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }else{
        NSLog(@"Successfully Signout");
    }
    // [START_EXCLUDE silent]
    //[self toggleAuthUI];
    // [END_EXCLUDE]
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"poptoroot" object:self];

    //[self performSegueWithIdentifier:@"logout" sender:self];
}
@end
