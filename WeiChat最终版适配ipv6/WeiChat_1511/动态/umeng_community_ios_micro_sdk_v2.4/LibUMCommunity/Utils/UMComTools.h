//
//  UMComTools.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UMComNotificationMacro.h"
#import "UMComConfigFile.h"

//common method
#define UMComLocalizedString(key,defaultValue) NSLocalizedStringWithDefaultValue(key,@"UMCommunityStrings",[NSBundle mainBundle],defaultValue,nil)

#define UMComUIScaleBetweenCurentScreenAndiPhone6Screen [UIScreen mainScreen].bounds.size.width/375  //屏幕适配系数比(以iPhone6的屏幕宽度为基准)

#define UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(width) width*UMComUIScaleBetweenCurentScreenAndiPhone6Screen

//#define UMComFontNotoSansLightWithSafeSize(FontSize) [UIFont fontWithName:@"FZLanTingHei-L-GBK-M" size:FontSize]?[UIFont fontWithName:@"FZLanTingHei-L-GBK-M" size:FontSize]:[UIFont systemFontOfSize:FontSize]

#define UMComFontNotoSansLightWithSafeSize(FontSize) [UIFont fontWithName:@"FZLanTingHei-L-GBK-M" size:FontSize*UMComUIScaleBetweenCurentScreenAndiPhone6Screen]?[UIFont fontWithName:@"FZLanTingHei-L-GBK-M" size:FontSize*UMComUIScaleBetweenCurentScreenAndiPhone6Screen]:[UIFont systemFontOfSize:FontSize]

//判断系统版本方法
#define UMComSystem_Version_Equal_To(vesion)                  ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] == NSOrderedSame)
#define UMComSystem_Version_Greater_Than(version)              ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] == NSOrderedDescending)
#define UMComSystem_Version_Greater_Than_Or_Equal_To(vesion)  ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] != NSOrderedAscending)
#define UMComSystem_Version_Less_Than(vesion)                 ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] == NSOrderedAscending)
#define UMComSyatem_Version_Less_Than_Or_Equal_To(vesion)     ([[[UIDevice currentDevice] systemVersion] compare:vesion options:NSNumericSearch] != NSOrderedDescending)
#define UMCom_Current_System_Version [[[UIDevice currentDevice] systemVersion] floatValue]


#define UMComImageWithImageName(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"UMComSDKResources.bundle/images/%@",imageName]]//读取UMComSDKResources.bundle中的图片

#define UMComColorWithColorValueString(colorValueString) [UMComTools colorWithHexString:colorValueString]//获取颜色

#define UMComRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define UMComTableViewSeparatorColor UMComColorWithColorValueString(@"#F5F6FA")


#define SafeCompletionData(completion,data) if(completion){completion(data);}
#define SafeCompletionDataAndError(completion,data,error) if(completion){completion(data,error);}
#define SafeCompletionDataNextPageAndError(completion,data,haveNext,error) if(completion){completion(data,haveNext,error);}
#define SafeCompletionAndError(completion,error) if(completion){completion(error);}

//Common block
typedef void (^PageDataResponse)(id responseData,NSString * navigationUrl,NSError *error);

typedef void (^LoadDataCompletion)(NSArray *data, NSError *error);

typedef void (^LoadServerDataCompletion)(NSArray *data, BOOL haveChanged, NSError *error);

typedef void (^LoadChangedDataCompletion)(NSArray *data);

typedef void (^PostDataResponse)(NSError *error);


@interface UMComTools : NSObject

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSError *)errorWithDomain:(NSString *)domain Type:(NSInteger)type reason:(NSString *)reason;
extern NSString * createTimeString(NSString * create_time);

+ (NSInteger)getStringLengthWithString:(NSString *)string;

extern NSString *countString(NSNumber *count);

@end
