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
@interface RegistrationViewController ()<NSURLConnectionDelegate>
{
    NSMutableData *xmlData;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)postRegisterDetails:(id)sender {
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@RegisterUrl]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml"
   forHTTPHeaderField:@"Content-type"];
    
    NSString *xmlString = [NSString stringWithFormat:@"<logdata><Firstname>%@</Firstname><Lastname>%@</Lastname><Reference>%@</Reference><Email>%@</Email><Number>%@</Number><password>%@</password></logdata>",_firtsName,_secondName,_referCode,_email,_mobile,_password];
    
    [request setValue:[NSString stringWithFormat:@"%lu",
                       (unsigned long)[xmlString length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[xmlString
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *con=[NSURLConnection connectionWithRequest:request delegate:self];
    
    
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
    [[NSUserDefaults standardUserDefaults] setObject:@"guest" forKey:@"User_type"];
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

    
    NSLog(@"%@", dict);
    
}


- (IBAction)alreadyMember:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
