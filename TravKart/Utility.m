//
//  Utility.m
//  JaguarXF
//
//  Created by DEEPAK VR on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//checking from sanil



#import "Utility.h"
//#import "PCA_FetchingData.h"
#import "Constants.pch"

@implementation Utility

//+(BOOL)reachable
//{
//    Reachability *r                 = [Reachability reachabilityWithHostName:@"google.com"];
//    NetworkStatus internetStatus    = [r currentReachabilityStatus];
//    if(internetStatus == NotReachable) {
//        return NO;
//    }
//    return YES;
//}



+(void)checkTimestampUpdate:(UINavigationController*)controllerNav
{
    
    NSString *resID     =   [Utility getfromplist:@"rs_id" plist:@"DynaFP-Plist"];
    NSDictionary *post  =   [[NSDictionary alloc] initWithObjectsAndKeys:resID,@"rs_id", nil];
    
    
    //    NSDictionary *foodDict  =   [[NSDictionary alloc] initWithObjectsAndKeys:self.waiterName.text,@"code",self.waiterPswd.text,@"password", self.tableCode.text,@"table", [Utility getfromplist:@"rs_id" plist:@"DynaFP-Plist"], @"rs_id",  nil];
    
    //if ([self reachable]) {
        // 1
        NSURL *url = [NSURL URLWithString:@"serverUrl"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        // 2
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        // 3
        //NSDictionary *dictionary = @{@"key1": @"value1"};
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:post
                                                       options:kNilOptions error:&error];
        
        NSMutableString *urlString      =   [[NSMutableString alloc]initWithFormat:@"data= %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
        NSData *postData                =   [urlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        //PCA_FetchingData *PCA_fetch  = [[PCA_FetchingData alloc]init];
        
        
        
        
        if (!error) {
            // 4
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                       fromData:postData completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                           // Handle response here
                                                                           
                                                                           if (!(data == nil)) {
                                                                               NSDictionary *result            =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                                               NSString *strTimestamp = [[result valueForKey:@"Timestamp"] objectAtIndex:0];
                                                                               
                                                                               
                                                                               if ([strTimestamp isEqualToString:[self getfromplist:@"menu_TimeStamp" plist:@"DynaFP-Plist"]]) {
                                                                                   [self addtoplist:@"shouldUpdateMenu" key:@"no" plist:@"DynaFP-Plist"];
                                                                                   
                                                                                   NSLog(@"no update needed");
                                                                               }
                                                                               else{
       //                                                                            [PCA_fetch fetchingDataFromServer:serverUrl withView:controllerNav.view withMessage:@"Downloading data.."];
                                                                                   
                                                                                   [self addtoplist:@"shouldUpdateMenu" key:@"yes" plist:@"DynaFP-Plist"];
                                                                                   NSLog(@"update needed");
                                                                                   
                                                                               }
                                                                               
                                                                           }
                                                                           
                                                                       }];
            
            // 5
            [uploadTask resume];
        }
        
   // }
    
    
    
}









+(void)deleteFromPlist:(NSString *)keyName plistName:(NSString *)plistName
{
    NSString * category1applicationDocumentsDir     =   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath                             =   [category1applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];
    NSMutableDictionary *plist                      =   [NSMutableDictionary dictionaryWithContentsOfFile:storePath]; //[NSMutableDictionary dictionaryWithCOntentsOfFile:storePath];
    [plist removeObjectForKey:keyName];
    [plist writeToFile:storePath atomically:YES];
}


//--------------------Core Data------------------------

+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


+(NSArray *)fetchingFromDataBase:(NSString *)DB_name
{
    NSManagedObjectContext  * context     =   [self managedObjectContext];
    NSFetchRequest  * fetchRequest        =   [[NSFetchRequest alloc]init];
    NSEntityDescription * entity          =   [NSEntityDescription entityForName:DB_name inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError     * error;
    NSArray     * fetchedObjects          =   [context executeFetchRequest:fetchRequest error:&error];
    
    //NSSortDescriptor *sort                =   [NSSortDescriptor sortDescriptorWithKey:@"sort_order" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    //NSArray *sortedArray                  =   [fetchedObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return fetchedObjects;
    
    //return fetchedObjects;

}

+(NSArray *)fetchFromDataBase:(NSString *)DB_name fieldName:(NSString *)field andvalue:(NSString *)value
{
    NSManagedObjectContext  * context     =   [self managedObjectContext];
    NSFetchRequest  * fetchRequest        =   [[NSFetchRequest alloc]init];
    NSEntityDescription * entity          =   [NSEntityDescription entityForName:DB_name inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //    [fetchRequest setReturnsDistinctResults:YES];
    //    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSString *str = [NSString stringWithFormat:@"%@==%@",field,value];
    
    NSLog(@"str--> %@",str);
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@=%@",field,value]]];
    NSError     * error;
    NSArray     * fetchedObjects          =   [context executeFetchRequest:fetchRequest error:&error];
    
    //NSSortDescriptor *sort                =   [NSSortDescriptor sortDescriptorWithKey:@"p_id"ascending:YES selector:@selector(caseInsensitiveCompare:)];
    //NSArray *sortedArray                  =   [fetchedObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return fetchedObjects;
}

+(NSArray *)fetchFromDataBase:(NSString *)DB_name firstField:(NSString *)field1 withValue:(NSString *)value1 secondField:(NSString *)field2 withValue:(NSString *)value2
{
    NSManagedObjectContext  * context     =   [self managedObjectContext];
    NSFetchRequest  * fetchRequest        =   [[NSFetchRequest alloc]init];
    NSEntityDescription * entity          =   [NSEntityDescription entityForName:DB_name inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    //    [fetchRequest setReturnsDistinctResults:YES];
    //    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSString *str = [NSString stringWithFormat:@"%@==%@ AND %@ CONTAINS %@",field1,value1,field2,value2];
    
    //NSPredicate *p = [NSPredicate predicateWithFormat:@"studentsToClass.className = %@ AND studentsToExamRecord.result = %@",  @"5th", @"Pass"];
    NSLog(@"str--> %@",str);
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@==%@ AND %@ CONTAINS %@",field1,value1,field2,value2]]];
    NSError     * error;
    NSArray     * fetchedObjects          =   [context executeFetchRequest:fetchRequest error:&error];
    
    NSSortDescriptor *sort                =   [NSSortDescriptor sortDescriptorWithKey:@"sort_order" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortedArray                  =   [fetchedObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    return sortedArray;
}

+(void)deleteOrderDB:(NSString *)DB_name
{
    NSManagedObjectContext *context       = [self managedObjectContext];
    NSFetchRequest *fetchRequestDelete    = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity           = [NSEntityDescription entityForName:DB_name inManagedObjectContext:context]; //OrderDB
   [fetchRequestDelete setEntity:entity];
 
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequestDelete error:&error];
 
    for (NSManagedObject *managedObject in items)
    {
          [context deleteObject:managedObject];
    }
    if (![context save:&error])
    {

    }
}

+(void)deleteFromDataBase:(NSString *)DBname andFieldName:(NSString *)fieldName
{
    NSManagedObjectContext   *context         = [self managedObjectContext];
    NSFetchRequest           *fetchRequest    = [[NSFetchRequest alloc]init];
    NSEntityDescription      *detail          = [NSEntityDescription entityForName:DBname inManagedObjectContext:context];
    NSError                  *error;
    [fetchRequest setEntity:detail];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"fudID=%@",fieldName]];
    NSArray *itemsTodelete      = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in itemsTodelete)
    {
        [context deleteObject:managedObject];
    }
    if (![context save:&error])
    {
        
    }
    
    
}


+(NSBundle*)local:(NSString*)buttontag
{
    
    NSString *path; 
    NSBundle* languageBundle;
   // NSInteger i=[buttontag intValue];
    
    path            = nil;
    languageBundle  = nil;
    
    switch ([buttontag intValue])
    {
            
        case 1:
            path= [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];  
            languageBundle = [NSBundle bundleWithPath:path];
            break;
        case 2:
            path= [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];  
            languageBundle = [NSBundle bundleWithPath:path];           
            break;
        case 3:
            path= [[NSBundle mainBundle] pathForResource:@"ru" ofType:@"lproj"];  
            languageBundle = [NSBundle bundleWithPath:path];
            break;
    }
    
    return languageBundle;
    
}

+(void)addtoplist:(id)Value key:(NSString *)key plist:(NSString *)plist{
  
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [path objectAtIndex:0];
    NSString *finalPath = [documentsDirectoryPath stringByAppendingPathComponent:[plist stringByAppendingString:@".plist"] ];
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: finalPath]) 
    {
        NSString *bundle = [[NSBundle mainBundle]pathForResource:plist ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: finalPath error:nil];
        bundle = nil;
    }    
    
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
    [plistDict setValue:Value forKey:key];
    [plistDict writeToFile:finalPath atomically: YES];
   
    path                    = nil;
    documentsDirectoryPath  = nil;
    finalPath               = nil;
    fileManager             = nil;
    plistDict               = nil;
    
  
}

//
//+(NSMutableArray *)RotatingimagesModel:(NSString *)color{
//    
//    NSString *modelcolorname=color;
//    NSString *str;
//    NSString *rertnstr;
//    int i;
//    NSMutableArray *array=[[NSMutableArray alloc]init];
//    
//    for (i=1; i<=4; i++) {
//        str=[NSString stringWithFormat:@"%d",i];
//        str=[str stringByAppendingFormat:@".png"];
//        rertnstr=[modelcolorname stringByAppendingFormat:str];
//        [array addObject:rertnstr];
//    }
//    return array;
//}


+(NSString *)getfromplist:(NSString *)key plist:(NSString *)plist
{
    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [path1 objectAtIndex:0];
     NSString *finalPath1 = [documentsDirectoryPath stringByAppendingPathComponent:[plist stringByAppendingString:@".plist"]];
   
    NSMutableDictionary* plistDict1 = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath1];
    NSString *value;
    value = [plistDict1 valueForKey:key];
    
    path1                   = nil;
    documentsDirectoryPath  = nil;
    finalPath1              = nil;
    plistDict1              = nil;
    
    return value;
    value                   = nil;
  
}
+ (void)animateViewWhenFrameChanged:(UIImageView *)imageView newFrame:(CGRect)frame 
                  animationDuration:(float)animationDurationValue{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDurationValue];
    imageView.alpha=1;
	imageView.frame = frame; 
	[UIView commitAnimations];
    
}
// Animate the change frame of view from old position to new position.
+ (void)animateImageViewWhenFrameChanged:(UIView *)imageView newFrame:(CGRect)frame 
                       animationDuration:(float)animationDurationValue animationDelegate:(id)delegate animationDelay:(float)delay nextMethod:(SEL)selector{
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
	[UIView setAnimationDuration:animationDurationValue];
    imageView.alpha=1;
	imageView.frame = frame; 
	[UIView commitAnimations];
}
// Animate the view Fade In.
+ (void)animateImageViewFadeIn:(UIView *)imageView  animationDuration:(float)animationDurationValue animationDelegate:(id)delegate animationDelay:(float)delay nextMethod:(SEL)selector{
    imageView.alpha=0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
	[UIView setAnimationDuration:animationDurationValue];
    imageView.alpha=1.0; 
	[UIView commitAnimations];
}
// Animate the view Fade Out.
+ (void)animateImageViewFadeOut:(UIView *)imageView  animationDuration:(float)animationDurationValue animationDelegate:(id)delegate animationDelay:(float)delay nextMethod:(SEL)selector{
    imageView.alpha=1.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDelegate:delegate];
    [UIView setAnimationDidStopSelector:selector];
	[UIView setAnimationDuration:animationDurationValue];
    imageView.alpha=0.0;
	[UIView commitAnimations];
}

// Animate the view Fade In.
+(void) animateViewFadeIn:(UIImageView *)imageView 
        animationDuration:(float)animationDurationValue {
	
	imageView.alpha = 0.0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDurationValue];
	imageView.alpha = 1.0; 
	[UIView commitAnimations];
}

// Animate the view Fade Out.
+(void) animateViewFadeOut:(UIImageView *)imageView 
         animationDuration:(float)animationDurationValue {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDurationValue];
	imageView.alpha = 0.0; 
	[UIView commitAnimations];
}

// Animate the change frame of view from old position to new position.
+ (void)animateUIViewWhenFrameChanged:(UIView *)imageView newFrame:(CGRect)frame 
                    animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue{
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:animationDelayValue];
	[UIView setAnimationDuration:animationDurationValue];
    imageView.alpha=1;
	imageView.frame = frame; 
	[UIView commitAnimations];
}

// Animate the view Fade In.
+(void) animateUIViewFadeIn:(UIView *)imageView 
          animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue{
	
	imageView.alpha = 0.0;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:animationDelayValue];
	[UIView setAnimationDuration:animationDurationValue];
	imageView.alpha = 1.0; 
	[UIView commitAnimations];
}

// Animate the view Fade Out.
+(void) animateUIViewFadeOut:(UIView *)imageView 
           animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue{
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:animationDelayValue];
	[UIView setAnimationDuration:animationDurationValue];
	imageView.alpha = 0.0; 
	[UIView commitAnimations];
}

// Fuction that provides the view a pulsating effect. This is done by changing the frame size and
// repeating the animation.
+(void)animateViewWithPulseAnimation:(UIImageView *)imageView frame:(CGRect)imageFrame animDuration:(float)duration animationDelay:(float)delay{
	
	[UIView beginAnimations:@"pulse" context:NULL];
	[UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:1e10f];
    [UIView setAnimationDelay:delay];
	[UIView setAnimationDuration:duration];
	imageView.frame = imageFrame;
	[UIView commitAnimations];
}

+(void)animateViewWhenFrameChangedWithRepeateAnimation:(UIView *)imageView frame:(CGRect)imageFrame animDuration:(float)duration animationDelay:(float)delay{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:1e10f];
    [UIView setAnimationDuration:duration];
    imageView.alpha = 1;
    imageView.frame = imageFrame;
    [UIView commitAnimations];
}

//---------chk sum ------------
+ (Byte)CalcCheckSum:(Byte)i data:(NSMutableData *)cmd
{   Byte * cmdByte = (Byte *)malloc(i);
    memcpy(cmdByte, [cmd bytes], i);
    Byte local_cs = 0;
    int j = 0;
    while (i>0) {
        local_cs += cmdByte[j];
        i--;
        j++;
    };
    local_cs = local_cs&0xff;
    return local_cs;
}


+(NSString *)trimmingSecondsFromTime:(NSString *)passedTime
{
    NSString *trimmedTime;
    if([Utility checkingDeviceTimeFormat])
    {
        NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:locale];
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        NSDate *date = [formatter dateFromString:passedTime];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm "];
        trimmedTime = [formatter stringFromDate:date];
        //return trimmedTime;
    }
    else
    {
        NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
                
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
        NSDate *date = [formatter dateFromString:passedTime];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm "];
        trimmedTime = [formatter stringFromDate:date];

    }
    return trimmedTime;
}

+(BOOL)checkingDeviceTimeFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    NSLog(@"%@\n",(is24h ? @"YES" : @"NO"));

    return is24h;
}
+(BOOL)checkFileExistence:(NSString *)fileName
{
    BOOL fileStatus;

    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    
    for ( NSString *aPath in filePathsArray )
    {
        if ([aPath isEqualToString:fileName])
        {
            fileStatus     =       YES;
            return fileStatus;
        }
        else
            fileStatus      =       NO;
    }
    return fileStatus;
}


+ (UIImage *)thumbnailFromVideoURL:(NSURL *)contentURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *error = NULL;
    CMTime time =  CMTimeMakeWithSeconds(10,30);
    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    NSLog(@"error==%@, Refimage==%@", error, refImg);
    
    UIImage *frameImage= [[UIImage alloc] initWithCGImage:refImg];
    return frameImage;
}



@end
