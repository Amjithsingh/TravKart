//
//  ViewController.m
//  TravKart
//
//  Created by Dunamis on 06/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "ViewController.h"
#import "Constants.pch"
#import "GDataXMLNode.h"
#import "XMLReader.h"
#import "UserDetails+CoreDataClass.h"
#import "Utility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@import Firebase;
@import GoogleSignIn;


@interface ViewController ()<GIDSignInDelegate,
GIDSignInUIDelegate,NSURLConnectionDelegate,FBSDKLoginButtonDelegate>
{
    NSString *user_type;
    NSMutableData *xmlData;
}
@property (weak, nonatomic) IBOutlet UIView *fb_View;
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end



@implementation ViewController


- (IBAction)registerBtn_action:(id)sender {
    
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Select User Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Guest",@"Agent", nil];
    
    [action showInView:self.view];
    
    
//    if (_segmentControl.selected == 0) {
//        user_type   =   @"guest";
//        
//        [self performSegueWithIdentifier:@"registration" sender:self];
//    }
//    else{
//        user_type   =   @"agent";
//    }

}

#pragma mark - ActionSheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) {
        
        user_type   =   @"guest";
        
        [self performSegueWithIdentifier:@"registration" sender:self];
        
    }else if( buttonIndex == 1 ) {
        
        user_type   =   @"agent";
        [self performSegueWithIdentifier:@"registrationAgent" sender:self];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipActionHandler:) name:@"pushtoHomeVC" object:nil];
    
    
    //[GIDSignIn sharedInstance].uiDelegate = self;
    //[[GIDSignIn sharedInstance] signIn];
    
    
//    [GIDSignIn sharedInstance].uiDelegate = self;
//    [[GIDSignIn sharedInstance] signIn];
//    

    [GIDSignIn sharedInstance].uiDelegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveToggleAuthUINotification:)
     name:@"ToggleAuthUINotification"
     object:nil];
    
    
    
    
    // Extend the code sample provided in "7. Add Facebook Login Button Code"
    // In your viewDidLoad method:
    //_loginButton    =   [[FBSDKLoginButton alloc] init];
//    FBSDKLoginButton *login =   [[FBSDKLoginButton alloc] init];
//    [self.view addSubview:login];
//    login.center     = self.view.center;
//    login.delegate      =   self;
//    
    //_loginButton.delegate = self;
    
    

////    _loginButton.readPermissions =
//    @[@"public_profile", @"email", @"user_friends"];
//    
    
    
    // TODO(developer) Configure the sign-in button look/feel
    // ...
}
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (error == nil) {
        // ...
        
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                         .tokenString];
        
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      // ...
                                      if (error) {
                                          // ...
                                          NSLog(@"%@",user.displayName);
                                          FIRUser  *user = [FIRAuth auth].currentUser;
                                          NSString *name = user.displayName;
                                          NSString *email = user.email;
                                          NSString *photoUrl  =   user.photoURL;
                                          
                                          [self sendDetailsToServer:name withPassword:nil];
                                          return;
                                      }}] ;
        
    }
    
         else {
        NSLog(error.localizedDescription);
    }
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    NSLog(@"Customer details: %@ %@ %@ %@", userId, idToken, name, email);
    // ...
}




- (void) receiveToggleAuthUINotification:(NSNotification *) notification {
    if ([notification.name isEqualToString:@"ToggleAuthUINotification"]) {
        //[self toggleAuthUI];
        //self.statusText.text = notification.userInfo[@"statusText"];
        
//        if ([FIRAuth auth].currentUser) {
            // User is signed in.
            NSLog(@"user signedIn");
            
            FIRUser  *user = [FIRAuth auth].currentUser;
            NSString *name = user.displayName;
            NSString *email = user.email;
            NSString *photoUrl  =   user.photoURL;
            
            [self sendDetailsToServer:name withPassword:nil];
            //NSString *email = user.email;
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            // ...
            
//          <logdata><name>webcrs android</name><email>webcrsdevelopersandroid@gmail.com</email><imageurl>null</imageurl><Number>null</Number><type>guest</type></logdata>

            
//        }
//        else{
//            
//            UIAlertView *alert  =   [[UIAlertView alloc] initWithTitle:@"TravKart" message:@"Login Unsuccessful! Please Try to Login again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alert show];
//            
//        }

    
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    //NSString *userType  = [prefs stringForKey:@"User_type"];
    
    if (![userID isEqualToString: @"0"]) {
        [self performSegueWithIdentifier:@"GoToMainViewController" sender:self];

    }

}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
//
//
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (managedObjectContext != nil) return managedObjectContext;
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        
//        managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return managedObjectContext;
//}
//



- (IBAction)googleSignin_btn:(id)sender {

//    [[[FIRAuth auth] signInWithCredential:credential
//                              completion:^(FIRUser *user, NSError *error) {
//                                  // ...
//                                  if (error) {
//                                      // ...
//                                      return;
//                                  }}]

}

/*
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        // ...
        
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
            NSLog(@"Credential done");
        }];
        
    } else{
        // ...
        }
}
*/
 
- (void)signInWithCredential:(FIRAuthCredential *)credential
                  completion:(nullable FIRAuthResultCallback)completion;
{
    
}

- (IBAction)skipActionHandler:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:user_type forKey:@"User_type"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"agentID"];
       [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"userID"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self performSegueWithIdentifier:@"GoToMainViewController" sender:self];
}

-(void) sendDetailsToServer:(NSString *)emailId withPassword: (NSString *)password
{
    
    // 1
//    NSURL *url = [NSURL URLWithString:@Login_Url];
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
   
    if (_segmentControl.selected == 0) {
        user_type   =   @"guest";
    }
    else{
        user_type   =   @"agent";
    }
    NSString *xmlString;
    
    NSString *urlString;
    
    
//    if ([FIRAuth auth].currentUser) {
        // User is signed in.
        NSLog(@"user signedIn");
        
        urlString   =   @"http://www.travkart.com/xml_google_login.php";
        
        FIRUser *user = [FIRAuth auth].currentUser;
        NSString *name = user.displayName;
        NSString *email = user.email;
        NSString *photoUrl  =   user.photoURL;
    
        xmlString   =  [NSString stringWithFormat:@"<logdata><name>%@</name><email>%@</email><imageurl>%@</imageurl><Number>null</Number><type>%@</type></logdata>",name,email,photoUrl,user_type];

//    }
//    else{
//        
//        urlString   =  @Login_Url;
//        xmlString = [NSString stringWithFormat:@"<logdata><Email>%@</Email><Password>%@</Password><type>%@</type></logdata>",self.emailID_txt.text,self.userID_txt.text,user_type];;
//        
//
//    }
    
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml"
   forHTTPHeaderField:@"Content-type"];
    
       [request setValue:[NSString stringWithFormat:@"%lu",
                       (unsigned long)[xmlString length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[xmlString 
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *con=[NSURLConnection connectionWithRequest:request delegate:self];

//    [[NSURLConnection alloc]
//     initWithRequest:request
//     delegate:self];
    
    
    
    
    
    
    
    // 2
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    request.HTTPMethod = @"POST";
    
    // 3
    //NSDictionary *dictionary = @{@"key1": @"value1"};
//    
//    NSDictionary *params  =   [[NSDictionary alloc] init];
//    [params setValue:emailId forKey:@"Email"];
//    [params setValue:password forKey:@"Password"];
//    [params setValue:user_type forKey:@"user_type"];
    
    //NSDictionary *params  =   [[NSDictionary alloc] initWithObjectsAndKeys:emailId,@"Email", password,@"Password", @"guest",@"user_type", nil];
    
    
//    NSString *params  =   [NSString stringWithFormat:@"<logdata><Email>rinu.ms09@gmail.com</Email><Password>asd</Password><type>agent</type></logdata>"];
//    
//    
//    NSError *error = nil;
//    NSData *data = [NSJSONSerialization dataWithJSONObject:params
//                                                   options:kNilOptions error:&error];
//    
//    if (!error) {
//        // 4
//        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
//                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
//                                                                       
//                                                                       
//                                                                       NSError *error1;
//                                                                       NSDictionary *dict=[XMLReader dictionaryForXMLData:data error:&error1];
//                                                                    
//                                                                       
//                                                                       // Handle response here
//                                                                       NSLog(@"login successful");
//                                                                   }];
//        
//        // 5
//        [uploadTask resume];
//    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    xmlData=[[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error1;
    NSDictionary *dict=[XMLReader dictionaryForXMLData:xmlData error:&error1];
    
    NSMutableArray *userArray   =   [[NSMutableArray alloc] init];
    [userArray addObject:[dict objectForKey:@"USERRESULT"]];
    
    
    //NSString *valueToSave = @"someValue";
    [[NSUserDefaults standardUserDefaults] setObject:user_type forKey:@"User_type"];
    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"AGENTID"] forKey:@"agentID"];
    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"MARKUPCLASS"] forKey:@"markupclass"];
    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USEREMAIL"] forKey:@"usermail"];
    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERID"] forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERMOBILE"]  forKey:@"usermobile"];
    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERNAME"] forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERPHONE"] forKey:@"userphone"];
    [[NSUserDefaults standardUserDefaults] setObject:   [[userArray objectAtIndex:0]valueForKey:@"USERPHOTO"] forKey:@"userphoto"];
     [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"is_master_user"] forKey:@"is_master_user"];
 
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    if ([[[userArray objectAtIndex:0]valueForKey:@"AGENTID"] isEqualToString:@"0"]) {
        
        UIAlertView *alert  =   [[UIAlertView alloc] initWithTitle:@"Travkart" message:@"Invalid Username or Password" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
    }
    else{
        
        [self performSegueWithIdentifier:@"GoToMainViewController" sender:self];

    }
    
    
    
    
    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    
//    NSManagedObject *details = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:[self managedObjectContext]];
//    
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"AGENTID"] forKey:@"agentID"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"MARKUPCLASS"] forKey:@"markupclass"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"USEREMAIL"] forKey:@"usermail"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"USERID"] forKey:@"userID"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"USERMOBILE"] forKey:@"usermobile"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"USERNAME"] forKey:@"username"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"USERPHONE"] forKey:@"userphone"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"USERPHOTO"] forKey:@"userphoto"];
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"is_master_user"] forKey:@"is_master"];
//    
    
//    [details setValue:[[userArray objectAtIndex:0]valueForKey:@"USERPHONE"] forKey:@"company"];

    
    
    
//    UserDetails *details    =   [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:context];
//    details.agentID         =   [[userArray objectAtIndex:0]valueForKey:@"AGENTID"];
//    details.markupclass     =   [[userArray objectAtIndex:0]valueForKey:@"MARKUPCLASS"];
//    details.usermail        =   [[userArray objectAtIndex:0]valueForKey:@"USEREMAIL"];
//    details.userID          =   [[userArray objectAtIndex:0]valueForKey:@"USERID"];
//    details.usermobile      =   [[userArray objectAtIndex:0]valueForKey:@"USERMOBILE"];
//    details.username        =   [[userArray objectAtIndex:0]valueForKey:@"USERNAME"];
//    details.userphone       =   [[userArray objectAtIndex:0]valueForKey:@"USERPHONE"];
//    details.userphoto       =   [[userArray objectAtIndex:0]valueForKey:@"USERPHOTO"];
//    details.is_master       =   [[userArray objectAtIndex:0]valueForKey:@"is_master_user"];
    
    
    //NSManagedObjectContext *context = [self managedObjectContext];
//    NSError *error = nil;
//    if (![context save:&error])
//    {
//        NSLog(@"%@",error);
//        
//    }
//    else
//    {
//        NSLog(@"%@",error);
// 
//    }

//    details.usermail      =   [[userArray objectAtIndex:0]valueForKey:@"phone"];
//    details.usermail      =   [[userArray objectAtIndex:0]valueForKey:@"phone"];

    NSLog(@"%@",dict);
    
    
    
}
//
//[[[FIRAuth auth] signInWithCredential:credential
//                          completion:^(FIRUser *user, NSError *error) {
//                              // ...
//                              if (error) {
//                                  // ...
//                                  return;
//                              }}]
// 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)userloginSubmit:(id)sender {
    
    if ([self.userID_txt.text isEqualToString:@""]) {
        NSLog(@"no email");
        
    }
    else if ([self.emailID_txt.text isEqualToString:@""])
    {
        NSLog(@"No password");
    }
    else{
        
        
        if (_segmentControl.selected == 0) {
            user_type   =   @"guest";
        }
        else{
            user_type   =   @"agent";
        }

        NSString *xmlString;
        
        NSString *urlString;
        
        urlString   =  @Login_Url;
        xmlString = [NSString stringWithFormat:@"<logdata><Email>%@</Email><Password>%@</Password><type>%@</type></logdata>",self.emailID_txt.text,self.userID_txt.text,user_type];;
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                        initWithURL:[NSURL
                                                     URLWithString:urlString]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/xml"
       forHTTPHeaderField:@"Content-type"];
        
        [request setValue:[NSString stringWithFormat:@"%lu",
                           (unsigned long)[xmlString length]]
       forHTTPHeaderField:@"Content-length"];
        
        [request setHTTPBody:[xmlString
                              dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *con=[NSURLConnection connectionWithRequest:request delegate:self];


        //[self sendDetailsToServer:self.emailID_txt.text withPassword:self.userID_txt.text];
        
    }
    
    
    
    
}
- (IBAction)fb_loginManage:(id)sender {
    
//    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//
//    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
//    shareButton .frame = CGRectMake(0,40,250,40);
//    shareButton.shareContent = content;
//    
//    [self.fb_View addSubview:shareButton];
//    [self.view addSubview:_fb_View];

    
    if ([FBSDKAccessToken currentAccessToken])
        
    {
        
//        [self createFbShareButton];
//        
//        [self shareImage];
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile",@"email"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 
                 
                 FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                  credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                                  .tokenString];
                 
                 [[FIRAuth auth] signInWithCredential:credential
                                           completion:^(FIRUser *user, NSError *error) {
                                               // ...
                                               if (error) {
                                                   FIRUser  *user = [FIRAuth auth].currentUser;
                                                   NSString *name = user.displayName;
                                                   NSString *email = user.email;
                                                   NSString *photoUrl  =   user.photoURL;

                                                   //return;
                                               }}] ;

                 
                 
                
                 [self sendDetailsToServer:nil withPassword:nil];

                 NSLog(@"Logged in");
                 //[self shareImage];
                 
             }
         }];
    }

}
@end
