//
//  TKReferViewController.m
//  TravKart
//
//  Created by AMJITH  on 25/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKReferViewController.h"
#import "XMLReader.h"
#import "Constants.pch"
#import "Utility.h"

@interface TKReferViewController ()<UITextFieldDelegate>
{
    NSMutableData *xmlData;
}
@property (weak, nonatomic) IBOutlet UITextField *friend_name;
@property (weak, nonatomic) IBOutlet UITextField *email_ID;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *mobile;

@end

@implementation TKReferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.friend_name.delegate   =   self;
    self.email_ID.delegate  =   self;
    self.country.delegate   =   self;
    self.mobile.delegate    =   self;
}

-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString* userID    = [prefs stringForKey:@"userID"];
    
    if ([userID  isEqual: @"0"]) {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"poptoroot" object:nil];
    }
    else if (userID == nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"poptoroot" object:nil];
    }
    else{
        
//        [Utility addtoplist:@"111" key:@"index" plist:@"TravKart_Info"];
//        
//        [self performSegueWithIdentifier:@"common_Identifier" sender:self];
    }
    

   

}




-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];
    

}

- (IBAction)sendToServer:(id)sender {
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    NSString *userID    = [prefs stringForKey:@"userID"];
    NSString *userType  = [prefs stringForKey:@"User_type"];
    
    NSString *referVal  =   @"";
    if ([userType isEqualToString:@"agent"]) {
        referVal    =   @"0";
    }
    else{
        referVal    =   @"1";
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:refer]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml"
   forHTTPHeaderField:@"Content-type"];
    
    
    //    //"<senddata>" +
    //    "<FirstName>" + name] + "</FirstName>" +
    //    "<ContactNumber>" + number]+ "</ContactNumber>" +
    //    "<Email>" + email+ "</Email>" +
    //    "<Destination>" + destination + "</Destination>" +
    //    "<TMonth>" + Month + "</TMonth>" +
    //    "<ddlEnTYear>" +Day + Year + "</ddlEnTYear>" +
    //    "<MoreDetail>" + more_details + "</MoreDetail>" +
    //    "</senddata>"
    //
    
    NSString *xmlString = [NSString stringWithFormat:@"<senddata><userid>%@</userid><type>%@</type><refer>%@</refer><email>%@</email><name>%@</name><mobile>%@</mobile></senddata>",userID,referVal,referVal,_email_ID.text,_friend_name.text,_mobile.text];
    
    if ([Utility reachable]) {
        [request setValue:[NSString stringWithFormat:@"%lu",
                           (unsigned long)[xmlString length]]
       forHTTPHeaderField:@"Content-length"];
        
        [request setHTTPBody:[xmlString
                              dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *con=[NSURLConnection connectionWithRequest:request delegate:self];

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
    
    NSMutableArray *userArray   =   [[NSMutableArray alloc] init];
    //[userArray addObject:[dict objectForKey:@"USERRESULT"]];
    
    
    //    //NSString *valueToSave = @"someValue";
    //    [[NSUserDefaults standardUserDefaults] setObject:@"guest" forKey:@"User_type"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"AGENTID"] forKey:@"agentID"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"MARKUPCLASS"] forKey:@"markupclass"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USEREMAIL"] forKey:@"usermail"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERID"] forKey:@"userID"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERMOBILE"]  forKey:@"usermobile"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERNAME"] forKey:@"username"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"USERPHONE"] forKey:@"userphone"];
    //    [[NSUserDefaults standardUserDefaults] setObject:   [[userArray objectAtIndex:0]valueForKey:@"USERPHOTO"] forKey:@"userphoto"];
    //    [[NSUserDefaults standardUserDefaults] setObject:[[userArray objectAtIndex:0]valueForKey:@"is_master_user"] forKey:@"is_master_user"];
    //
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    //    if ([[[userArray objectAtIndex:0]valueForKey:@"AGENTID"] isEqualToString:@"0"]) {
    //
    //        UIAlertView *alert  =   [[UIAlertView alloc] initWithTitle:@"Travkart" message:@"Invalid Username or Password" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    //        [alert show];
    //    }
    //    else{
    //
    //        [self performSegueWithIdentifier:@"GoToMainViewController" sender:self];
    //        
    //    }
    
    
    NSLog(@"%@", dict);
    
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
