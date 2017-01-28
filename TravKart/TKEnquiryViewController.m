//
//  TKEnquiryViewController.m
//  TravKart
//
//  Created by AMJITH  on 24/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKEnquiryViewController.h"
#import "Constants.pch"
#import "XMLReader.h"
#import "Utility.h"

@interface TKEnquiryViewController ()<UITextFieldDelegate>
{
    NSString *date;
    NSMutableData *xmlData;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *contactNumber;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *residence;
@property (weak, nonatomic) IBOutlet UITextField *destination;
@property (weak, nonatomic) IBOutlet UITextField *extra;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickDate;
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UIView *popUpDateView;

@end

@implementation TKEnquiryViewController


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)pickDate:(id)sender {

    self.pickDate.hidden    =   NO;
}

- (IBAction)finishedPickingDate:(id)sender {
    
    
    date = [NSString stringWithFormat:@"%@",_pickDate.date];
    _dateText.text  =   [date substringToIndex:13];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _name.delegate   =   self;
    _contactNumber.delegate  =   self;
    _email.delegate  =   self;
    _residence.delegate  =   self;
    _destination.delegate    =   self;
    _extra.delegate  =   self;
    _dateText.delegate   =   self;
    
    
}
- (IBAction)backBtnAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenSideMenuNotification" object:self];

}
- (IBAction)sendToServer:(id)sender {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:sendEnquiry]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml"
   forHTTPHeaderField:@"Content-type"];
    
    date = [NSString stringWithFormat:@"%@",_pickDate.date];
    NSString *formattedDate =   [date substringToIndex:13];
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
    if ([Utility reachable]) {
        
        
        NSString *xmlString = [NSString stringWithFormat:@"<senddata><Firstname>%@</Firstname><ContactNumber>%@</ContactNumber><Email>%@</Email><Destination>%@</Destination><TMonth>%@</TMonth><ddlEnTYear>%@</ddlEnTYear><MoreDetail>%@</MoreDetail></senddata>",_name.text,_contactNumber.text,_email.text,_destination.text,formattedDate,_extra.text];
        
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
