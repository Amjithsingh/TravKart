//
//  RegistrationViewController.m
//  TravKart
//
//  Created by AMJITH  on 21/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Constants.pch"
#import "XMLReader.h"
#import "Utility.h"
@interface RegistrationViewController ()<NSURLConnectionDelegate,UITextFieldDelegate>
{
    NSMutableData *xmlData;
    UITextField *otpField;
    NSString *otpTmp;
    NSMutableArray *userArray;
}
@property (weak, nonatomic) IBOutlet UITextField *firtsName;
@property (weak, nonatomic) IBOutlet UITextField *secondName;
@property (weak, nonatomic) IBOutlet UITextField *referCode;
@property (weak, nonatomic) IBOutlet UITextField *promoCOde;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation RegistrationViewController


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.firtsName.delegate     =   self;
    self.secondName.delegate    =   self;
    self.referCode.delegate     =   self;
    _promoCOde.delegate  =   self;
    _email.delegate     =   self;
    _mobile.delegate     =   self;
    _password.delegate     =   self;
    _confirmPassword.delegate     =   self;
}

-(BOOL) validateEmailId
{
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if ([emailTest evaluateWithObject:_email.text] == NO)
    {
        
        return NO;
        
        
    }
    else{
        return YES;
    }
}
- (IBAction)postRegisterDetails:(id)sender {
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@RegisterUrl]];
    
    if ([Utility reachable]) {
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/xml"
       forHTTPHeaderField:@"Content-type"];
        
        
        
        NSString *xmlString = [NSString stringWithFormat:@"<logdata><Firstname>%@</Firstname><Lastname>%@</Lastname><Reference>%@</Reference><Email>%@</Email><Number>%@</Number><password>%@</password></logdata>",_firtsName.text,_secondName.text,_referCode.text,_email.text,_mobile.text,_password.text];
        
        [request setValue:[NSString stringWithFormat:@"%lu",
                           (unsigned long)[xmlString length]]
       forHTTPHeaderField:@"Content-length"];
        
        [request setHTTPBody:[xmlString
                              dataUsingEncoding:NSUTF8StringEncoding]];
        if ([self validateEmailId]) {
            
            NSURLConnection *con=[NSURLConnection connectionWithRequest:request delegate:self];

        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Travkart" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];

        }
    }
    else{
        
        
        UIAlertView *alert  =   [[UIAlertView alloc] initWithTitle:@"Travkart" message:@"Please check your internet coneectivity" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        

        
    }
    
    
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
    
    if (!(dict == nil)) {
        
        userArray   =   [[NSMutableArray alloc] init];
        [userArray addObject:[dict objectForKey:@"SMSRESULT"]];
//        [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERID"] forKey:@"userID"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
        if ([[[userArray objectAtIndex:0]valueForKey:@"OTACODE"] isEqualToString:@"0"]) {
            
            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"TravKart" message:@"already registered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [dialog show];
        }
        
        else{
            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter OTP" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            //        [dialog setDelegate:self];
            //        [dialog setTitle:@"Enter OTP"];
            //        [dialog setMessage:@" "];
            //        [dialog addButtonWithTitle:@"Cancel"];
            //        [dialog addButtonWithTitle:@"OK"];
            
            //        otpField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
            //        [otpField setBackgroundColor:[UIColor grayColor]];
            //        [dialog addSubview:otpField];
            
            [dialog show];
            
            CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 100.0);
            [dialog setTransform: moveUp];

        }
       
    }

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *strOtp    = [[userArray objectAtIndex:0]valueForKey:@"OTACODE"];
    
    if (buttonIndex == 1)
    {
        if ([[[alertView textFieldAtIndex:0]text] isEqualToString:strOtp ]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERID"] forKey:@"userID"];
            [[NSUserDefaults standardUserDefaults] setObject:self.email.text forKey:@"usermail"];
            [[NSUserDefaults standardUserDefaults] setObject:self.firtsName.text forKey:@"username"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self performSegueWithIdentifier:@"gotohome" sender:self];
            //[self.navigationController popViewControllerAnimated:NO];
            NSLog(@"loginSuccess!");
            
        }
    }
}


- (IBAction)alreadyMember:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
