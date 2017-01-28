//
//  ViewController.h
//  TravKart
//
//  Created by Dunamis on 06/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, retain) NSDictionary *userinfodata;
@property (weak, nonatomic) IBOutlet UITextField *emailID_txt;
@property (weak, nonatomic) IBOutlet UITextField *userID_txt;
- (IBAction)userloginSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)fb_loginManage:(id)sender;


@end

