//
//  TKNotificationsViewController.m
//  TravKart
//
//  Created by AMJITH  on 20/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKNotificationsViewController.h"
#import "Utility.h"
#import "TKRemoteNotificationTableViewCell.h"
#import "TKRemoteImageTableViewCell.h"

@interface TKNotificationsViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    NSMutableArray *tabDataSource;
    TKRemoteNotificationTableViewCell *tableCell;
    TKRemoteImageTableViewCell *cell;
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UIWebView *notificationWebView;
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@end

@implementation TKNotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.notificationTableView.delegate     =  self;
    self.notificationTableView.dataSource   =   self;
    
    
    
    if (self.fromAppDelegate == YES && ![self.NotificationUrl isEqual:nil]) {
        
        self.notificationTableView.hidden   =   YES;
        self.notificationTitle.hidden       =   YES;
        self.notificationWebView.hidden     =   NO;
        
        
        if ([Utility reachable]) {
            
            NSURL *url = [NSURL URLWithString:self.NotificationUrl];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.notificationWebView loadRequest:requestObj];
            
        }
        else{
            
            CGRect frame = [self.notificationWebView frame];
            UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
            noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
            [self.view addSubview:noInternet];
            
        }

    }
}


- (IBAction)backButtonAction:(id)sender {
    

    if (self.notificationWebView.hidden == NO) {
        
        if ([_notificationWebView canGoBack]) {
            [_notificationWebView goBack];
        }
        else{
            //        [self performSegueWithIdentifier:@"back_Offers" sender:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"poptoroot" object:self];
            
        }
    }
    else{
     
        [self performSegueWithIdentifier:@"gotohomeviewcontroller" sender:self];
    }
    
    
        //        [self performSegueWithIdentifier:@"back_Flash" sender:self];
        //gotohomeviewcontroller
}


-(void) viewWillAppear:(BOOL)animated
{
    
    [self sendDetailsForNotification];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return tabDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
        
        static NSString *simpleTableIdentifier = @"simpleIdentifier";
        
        tableCell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (tableCell == nil) {
            //        tableCell = [[TKRemoteNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TKRemoteNotificationTableViewCell" owner:self options:nil];
            tableCell = [nib objectAtIndex:0];
            
        }
        
        tableCell.notification_title.text =   [[tabDataSource objectAtIndex:indexPath.row] valueForKey:@"notific_title"];
    
    if (!([[[tabDataSource objectAtIndex:indexPath.row] valueForKey:@"notific_desc"] isEqualToString:@"<null>"])) {
        tableCell.notification_desc.text  =   [[tabDataSource objectAtIndex:indexPath.row] valueForKey:@"notific_desc"];
        

    }
    else{
        
    }
    
        return tableCell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    NSString *urlStr    =   [[tabDataSource objectAtIndex:indexPath.row] valueForKey:@"notific_url"];
    
    if(![urlStr isEqualToString:@""])
    {
        self.notificationTableView.hidden   =   YES;
        self.notificationWebView.hidden     =   NO;
        
        
        if ([Utility reachable]) {
            
            
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.notificationWebView loadRequest:requestObj];
            
        }
        else{
            
            CGRect frame = [self.notificationWebView frame];
            UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
            noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
            [self.view addSubview:noInternet];
            
        }

    }
    else{
        
        self.notificationWebView.hidden     =   YES;
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




-(void) sendDetailsForNotification{
    
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    //NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    
    
    //                              userID
    //    userType
    //    tokenID
    //    deviceID
    //
    
    NSDictionary *foodDict  =   [[NSDictionary alloc] initWithObjectsAndKeys: userID,@"userid",nil];
    
    if ([Utility reachable]) {
        // 1
        NSURL *url = [NSURL URLWithString:@"http://www.travkart.com/json_send_notification.php"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        // 2
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        // 3
        //NSDictionary *dictionary = @{@"key1": @"value1"};
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:foodDict
                                                       options:kNilOptions error:&error];
        
        NSMutableString *urlString      =   [[NSMutableString alloc]initWithFormat:@"[%@]",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
        
        NSLog(@"result %@",urlString);
        
        NSData *postData                =   [urlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        
        
        if (!error) {
            // 4
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                       fromData:postData completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                           
                NSDictionary *result            =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                                    
                            
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            tabDataSource   =   (NSMutableArray*)result;
                            
                            [self.notificationTableView reloadData];
                                                                              
                                                                              
                                                });
                    NSLog(@"result %@",result);
                                                                           
                                                                           
            
                }];
            [uploadTask resume];
            
        }
    }
    else{
        UIAlertView *alert  =   [[UIAlertView alloc] initWithTitle:@"Travkart" message:@"Please check your internet coneectivity and try again!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        
        
    }
    
    
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
