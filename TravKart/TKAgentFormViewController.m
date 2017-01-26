//
//  TKAgentFormViewController.m
//  TravKart
//
//  Created by AMJITH  on 24/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKAgentFormViewController.h"
#import "Utility.h"

@interface TKAgentFormViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webViewForm;

@end

@implementation TKAgentFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    if ([Utility reachable]) {
        
        NSString *fullUrl       =   @"http://www.travkart.com/agent-signup-mobapp.php";
        
        NSURL *url = [NSURL URLWithString:fullUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webViewForm loadRequest:requestObj];
        
    }
    else{
        
        CGRect frame = [self.webViewForm frame];
        UIImageView *noInternet =   [[UIImageView alloc] initWithFrame:frame];
        noInternet.image    =   [UIImage imageNamed:@"no_connection_tower.jpg"];
        [self.view addSubview:noInternet];
        
    }
    
}
- (IBAction)closeAgentForm:(id)sender {
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
