//
//  TKRequestCallViewController.m
//  TravKart
//
//  Created by AMJITH  on 24/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKRequestCallViewController.h"
#import "XMLReader.h"
#import "Constants.pch"
#import "Utility.h"

@interface TKRequestCallViewController ()
{
    NSMutableData *xmlData;
    
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userMObile;
@property (weak, nonatomic) IBOutlet UITextField *userCode;

@end



@implementation TKRequestCallViewController





-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userName.delegate  =   self;
    self.userCode.delegate  =   self;
    self.userCode.delegate  =   self;
}
- (IBAction)submitRequest:(id)sender {
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:callBackUrl]];
    
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
    
    
    if ([Utility reachable]) {
        NSString *mobNo =   [NSString stringWithFormat:@"%@,%@",_userCode.text,_userMObile.text ];
        
        NSString *xmlString = [NSString stringWithFormat:@"<senddata><name>%@</name><mobno>%@</mobno></senddata>",_userName.text,mobNo];
        
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
    
    if (dict == nil) {
        
    }
    else{
        
        NSMutableArray *userArray   =   [[NSMutableArray alloc] init];
        //[userArray addObject:[dict objectForKey:@"USERRESULT"]];
        
    }
    
    
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


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
