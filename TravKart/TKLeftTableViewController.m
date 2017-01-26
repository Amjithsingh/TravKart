//
//  TKLeftTableViewController.m
//  TravKart
//
//  Created by AMJITH  on 16/01/17.
//  Copyright © 2017 Dunamis. All rights reserved.
//

#import "TKLeftTableViewController.h"
#import "UserDetailsTableViewCell.h"
#import "DetailTableViewCell.h"
#import "BudgetTableViewCell.h"
#import "FlashSaleTableViewCell.h"
#import "OffersTableViewCell.h"
#import "NotificationTableViewCell.h"
#import "TKCommonViewController.h"
#import "PackageTableViewCell.h"
#import "ThemeTableViewCell.h"
#import "DomesticTableViewCell.h"
#import "InternationalTableViewCell.h"
#import "TrendingTableViewCell.h"
#import "CommunicateTableViewCell.h"
#import "OffersTableViewCell.h"
#import "ContactTableViewCell.h"
#import "LikeUsTableViewCell.h"
#import "ReferTableViewCell.h"
#import "OthersTableViewCell.h"
#import "RateAppTableViewCell.h"
#import "AboutUsTableViewCell.h"
#import "TermsConditionsTableViewCell.h"
#import "PrivacyPolicyTableViewCell.h"

@import Firebase;

@interface TKLeftTableViewController ()
{
    NSString *userID;
    NSString *userName;
    NSString *userMail;
}
//@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation TKLeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([FIRAuth auth].currentUser) {
        // User is signed in.
        NSLog(@"user signedIn");
        // ...
    } else {
        // No user is signed in.
        // ...
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // getting an NSString
    userID    = [prefs stringForKey:@"userID"];
    userName  = [prefs stringForKey:@"username"];
    userMail  = [prefs stringForKey:@"usermail"];

    

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)addImage {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Select image from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From camera",@"From library", nil];
    
    [action showInView:self.view];
}

#pragma mark - ActionSheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 ) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
            pickerView.allowsEditing = YES;
            pickerView.delegate = self;
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:pickerView animated:true];
        }
        
    }else if( buttonIndex == 1 ) {
        
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentModalViewController:pickerView animated:YES];
        
    }
}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    //NSData *imageData = UIImagePNGRepresentation(image);
    //[imageData writeToFile:savedImagePath atomically:NO];
    //[self uploadToServerUsingImage:imageData andFileName:[NSString stringWithFormat:@"%@.jpg",userName]];
    [self dismissModalViewControllerAnimated:true];
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    
//    
//    
//    //UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
//    
//    //myImageView.image = img;
//    
//}

// HTTP method to upload file to web server
- (void)uploadToServerUsingImage:(NSData *)imageData andFileName:(NSString *)filename {
    
    // set this to your server's address
    NSString *urlString = @"http://www.travkart.com/xml_user_photo.php";
    // set the content type, in this case it needs to be: "Content-Type: image/jpg"
    // Extract 'jpg' or 'png' from the last three characters of 'filename'
    if (([filename length] -3 ) > 0) {
        NSString *contentType = [NSString stringWithFormat:@"Content-Type: image/%@", [filename substringFromIndex:[filename length] - 3]];
    }
    
    // allocate and initialize the mutable URLRequest, set URL and method.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    // define the boundary and newline values
    NSString *boundary = @"uwhQ9Ho7y873Ha";
    NSString *kNewLine = @"\r\n";
    
    // Set the URLRequest value property for the HTTP Header
    // Set Content-Type as a multi-part form with boundary identifier
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // prepare a mutable data object used to build message body
    NSMutableData *body = [NSMutableData data];
    
    // set the first boundary
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary, kNewLine] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Set the form type and format
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; userid=\"%@\"; filename=\"%@\"%@", @"uploaded_file", filename, userID, kNewLine] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Now append the image itself.  For some servers, two carriage-return line-feeds are necessary before the image
    [body appendData:[[NSString stringWithFormat:@"%@%@", kNewLine, kNewLine] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[kNewLine dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add the terminating boundary marker & append a newline
    [body appendData:[[NSString stringWithFormat:@"--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[kNewLine dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Setting the body of the post to the request.
    [request setHTTPBody:body];
    
    // TODO: Next three lines are only used for testing using synchronous conn.
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"==> sendSyncReq returnString: %@", returnString);
    
    // You will probably want to replace above 3 lines with asynchronous connection
    //    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}


-(void) walletAction{
 
    [self performSegueWithIdentifier:@"walletSegue" sender:self];
}

-(void)favoritesAction{

    [self performSegueWithIdentifier:@"common_Identifier" sender:self];

}

-(void)bookAction
{
    
    [self performSegueWithIdentifier:@"common_Identifier" sender:self];

    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row  == 0) {
        return 180;
    }
    else{
        return 49;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        UserDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstRowIdentifier" forIndexPath:indexPath];
        
        cell.walletImg.userInteractionEnabled = YES;
        cell.walletImg.tag = indexPath.row;
        
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(walletAction)];
        tapped.numberOfTapsRequired = 1;
        [cell.walletImg addGestureRecognizer:tapped];
        
        
        cell.favorites.userInteractionEnabled = YES;
        cell.favorites.tag = indexPath.row;
        
        UITapGestureRecognizer *tappedFav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoritesAction)];
        tappedFav.numberOfTapsRequired = 1;
        [cell.favorites addGestureRecognizer:tappedFav];
        
        
        
        cell.bookings.userInteractionEnabled = YES;
        cell.bookings.tag = indexPath.row;
        
        UITapGestureRecognizer *tappedBook = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookAction)];
        tappedBook.numberOfTapsRequired = 1;
        [cell.favorites addGestureRecognizer:tappedBook];
        
        
        if ([FIRAuth auth].currentUser) {
            // User is signed in.
            NSLog(@"user signedIn");
            
            FIRUser *user = [FIRAuth auth].currentUser;
            //NSString *email = user.email;
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            cell.userName.text  =   user.displayName;
            cell.userEmailLabel.text = user.email;
            NSURL *photoURL = user.photoURL;
            cell.userImage.image    =   [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
            // ...
        }
        else if (![userID isEqualToString:@"0"])
        {
            cell.userName.text          =   userName;
            cell.userEmailLabel.text    =   userMail;
            
            cell.userImage.userInteractionEnabled = YES;
            cell.userImage.tag = indexPath.row;
            
//            UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
//            tapped.numberOfTapsRequired = 1;
//            [cell.userImage addGestureRecognizer:tapped];
        }
        else {
            cell.userName.text =   @"Guest";
            
            // No user is signed in.
            // ...
        }
        
        
        
        return cell;
        
    }
    else if(indexPath.row == 1) {
        
        // Configure the cell...
        
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondRowIdentifier" forIndexPath:indexPath];
        
        // Configure the cell...

        return cell;
    }
    else if(indexPath.row == 2) {
        
        // Configure the cell...
        
        BudgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdRowIdentifier" forIndexPath:indexPath];
        
        // Configure the cell...
        
        return cell;
    }
    else if(indexPath.row == 3){
        FlashSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FourthRowIdentifier" forIndexPath:indexPath];

        return cell;
    }
    else if(indexPath.row == 4){
        OffersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FifthRowIdentifier" forIndexPath:indexPath];
        
        return cell;
    }
//    else if(indexPath.row == 5){
//        FlashSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SixthRowIdentifier" forIndexPath:indexPath];
//        
//        return cell;
//    }

    else if(indexPath.row == 5){
        NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SixthRowIdentifier" forIndexPath:indexPath];
        
        return cell;

    }
    else if(indexPath.row == 6){
        PackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeventhRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 7){
        ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EighthRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 8){
        DomesticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NinthRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 9){
        InternationalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TenthRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 10){
        TrendingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EleventhRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 11){
        CommunicateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwelfthRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 12){
        ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirteenthRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 13){
        LikeUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FourteenthRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 14){
        ReferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FifteenRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 15){
         OthersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SixteenRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 16){
        ReferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeventeenRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 17){
        RateAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EighteenRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 18){
        AboutUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NineteenRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if(indexPath.row == 19){
        TermsConditionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwentythRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else if (indexPath.row == 20) {
        PrivacyPolicyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwentyFirstRowIdentifier" forIndexPath:indexPath];
        
        return cell;
        
    }
    else{
        
        PrivacyPolicyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwentyFirstRowIdentifier" forIndexPath:indexPath];
        
        return cell;

    }
    


}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
