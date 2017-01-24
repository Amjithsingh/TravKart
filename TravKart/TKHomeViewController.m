//
//  TKHomeViewController.m
//  TravKart
//
//  Created by AMJITH  on 16/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKHomeViewController.h"
@import GoogleSignIn;
@import Firebase;



@interface TKHomeViewController ()

- (void)openSideMenuFromLeft;

@end

@implementation TKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSideMenuFromLeft) name:@"OpenSideMenuNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootView) name:@"poptoroot" object:nil];
    
    
//    if ([FIRAuth auth].currentUser) {
//        // User is signed in.
//        
//        FIRUser *user = [FIRAuth auth].currentUser;
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
//                                        initWithURL:[NSURL
//                                                     URLWithString:@"http://www.travkart.com/xml_google_login.php"]];
//        
//        [request setHTTPMethod:@"POST"];
//        [request setValue:@"text/xml"
//       forHTTPHeaderField:@"Content-type"];
//        
//        NSString *xmlString = [NSString stringWithFormat:@"<logdata><name>%@</name><email>%@</email><imageurl>%@</imageurl><Number>%@</Number><type>%@</type></logdata>"];;
//        
//        [request setValue:[NSString stringWithFormat:@"%lu",
//                           (unsigned long)[xmlString length]]
//       forHTTPHeaderField:@"Content-length"];
//        
//        [request setHTTPBody:[xmlString
//                              dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSURLConnection *con=[NSURLConnection connectionWithRequest:request delegate:self];
//
//        // ...
//    } else {
//        // No user is signed in.
//        // ...
//    }

    
}


-(void) popToRootView
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

- (void)openSideMenuFromLeft {
    [self openLeftMenuAnimated:true];
}

/*----------------------------------------------------*/
#pragma mark - Overriden Methods -
/*----------------------------------------------------*/

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        
        case 0:
            identifier = @"showFirstVC";
            break;
        case 1:
            identifier = @"showFirstVC";
            break;
        case 2:
            identifier = @"showSecondVC";
            break;
        case 3:
            identifier = @"showThirdVC";
            break;
        case 4:
            identifier = @"showFourthVC";
            break;
            
        case 5:
            identifier = @"common_Identifier";
            break;
        case 6:
            identifier = @"common_Identifier";
            break;
        case 7:
            identifier = @"common_Identifier";
            break;
        case 8:
            identifier = @"common_Identifier";
            break;
        case 9:
            identifier = @"common_Identifier";
            break;
        case 10:
            identifier = @"common_Identifier";
            break;
        case 11:
            identifier = @"common_Identifier";
            break;
        case 12:
            identifier = @"common_Identifier";
            break;
        case 13:
            identifier = @"common_Identifier";
            break;
        case 14:
            identifier = @"common_Identifier";
            break;
        case 15:
            identifier = @"common_Identifier";
            break;
        case 16:
            identifier = @"common_Identifier";
            break;
        case 17:
            identifier = @"common_Identifier";
            break;
        case 18:
            identifier = @"common_Identifier";
            break;
        case 19:
            identifier = @"common_Identifier";
            break;
        case 20:
            identifier = @"common_Identifier";
            break;
        case 21:
            identifier = @"common_Identifier";
            break;
        case 22:
            identifier = @"common_Identifier";
            break;
            
    }
    
    return identifier;
}

- (CGFloat)leftMenuWidth
{
    return 260;
}


// Enabling Deepnes on left menu
- (BOOL)deepnessForLeftMenu
{
    return YES;
}

/*
 * NOTE! If you override this method, then segueIdentifierForIndexPathInLeftMenu will be ignored
 * Return instantiated navigation controller that will opened
 * when cell at indexPath will be selected from left menu
 * @param indexPath of left menu table
 * @return UINavigationController instance for input indexPath
 */

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
