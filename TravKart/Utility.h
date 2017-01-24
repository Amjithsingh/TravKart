//
//  Utility.h
//  JaguarXF
//
//  Created by DEEPAK VR on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//hellofghfhhgfhfghgfh
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import "AV"

@interface Utility : NSObject


//+(NSMutableArray *)RotatingimagesModel:(NSString *)color;

+(void)checkTimestampUpdate:(UINavigationController*)controllerNav;
+(BOOL)reachable;



+ (Byte)CalcCheckSum:(Byte)i data:(NSMutableData *)cmd;
+(void)deleteFromPlist:(NSString *)keyName plistName:(NSString *)plistName;
+(NSBundle*)local:(NSString*)buttontag;
+(void)addtoplist:(id)Value key:(NSString *)key plist:(NSString *)plist;
+(NSString *)getfromplist:(NSString *)key plist:(NSString *)plist;
+ (void)animateViewWhenFrameChanged:(UIImageView *)imageView newFrame:(CGRect)frame 
                  animationDuration:(float)animationDurationValue;
+ (void)animateImageViewWhenFrameChanged:(UIView *)imageView newFrame:(CGRect)frame 
                       animationDuration:(float)animationDurationValue animationDelegate:(id)delegate animationDelay:(float)delay nextMethod:(SEL)selector;
+ (void)animateImageViewFadeIn:(UIView *)imageView  animationDuration:(float)animationDurationValue animationDelegate:(id)delegate animationDelay:(float)delay nextMethod:(SEL)selector;
+ (void)animateImageViewFadeOut:(UIView *)imageView  animationDuration:(float)animationDurationValue animationDelegate:(id)delegate animationDelay:(float)delay nextMethod:(SEL)selector;
+(void) animateViewFadeIn:(UIImageView *)imageView 
        animationDuration:(float)animationDurationValue;
+(void) animateViewFadeOut:(UIImageView *)imageView 
         animationDuration:(float)animationDurationValue;
+ (void)animateUIViewWhenFrameChanged:(UIView *)imageView newFrame:(CGRect)frame 
                    animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue;
+(void) animateUIViewFadeIn:(UIView *)imageView 
          animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue;
+(void) animateUIViewFadeOut:(UIView *)imageView 
           animationDuration:(float)animationDurationValue animationDelay:(float)animationDelayValue;
+(void)animateViewWithPulseAnimation:(UIImageView *)imageView frame:(CGRect)imageFrame animDuration:(float)duration animationDelay:(float)delay;
+(void)animateViewWhenFrameChangedWithRepeateAnimation:(UIView *)imageView frame:(CGRect)imageFrame animDuration:(float)duration animationDelay:(float)delay;



+(void)deleteFromDataBase:(NSString *)DBname andFieldName:(NSString *)fieldName;

+(NSString *)trimmingSecondsFromTime:(NSString *)passedTime;

+(BOOL)checkingDeviceTimeFormat;

+(NSArray *)fetchingFromDataBase:(NSString *)DB_name;

+(void)deleteOrderDB:(NSString *)DB_name;

+(NSArray *)fetchFromDataBase:(NSString *)DB_name fieldName:(NSString *)field andvalue:(NSString *)value;

+(NSArray *)fetchFromDataBase:(NSString *)DB_name firstField:(NSString *)field1 withValue:(NSString *)value1 secondField:(NSString *)field2 withValue:(NSString *)value2; //  for fetching with country and  cat_id

+(BOOL)checkFileExistence:(NSString *)fileName;

+ (UIImage *)thumbnailFromVideoURL:(NSURL *)contentURL;
@end
