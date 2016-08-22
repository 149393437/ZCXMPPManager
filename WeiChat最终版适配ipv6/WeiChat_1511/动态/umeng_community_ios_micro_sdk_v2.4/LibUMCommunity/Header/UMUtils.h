//
//  UMUtils.h
//  UMUtils
//
//  Created by luyiyuan on 3/31/12.
//  Copyright (c) umeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define UMdegreesToRadians(x) (M_PI * (x) / 180.0) //定义弧度到度数的宏

#define UMSYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define UMSYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define UMSYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define UMSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//logs
/*
 NSString *file = [[NSString stringWithUTF8String:__FILE__] lastPathComponent]; \
 printf("[%s(%f)] [%s:(%s)(%d)] - ",[[UMUtils timeMSString] UTF8String],[NSThread currentThread].threadPriority,[file UTF8String],    __FUNCTION__, __LINE__); \*/

#ifndef UMLog
#define UMLog(format,...) [UMUtils outLog:(format),##__VA_ARGS__]
#endif

@protocol SKStoreProductViewControllerDelegate;

@interface UMUtils : NSObject

#pragma mark self
+ (NSString *)utilsVersion;


#pragma mark NSData
+ (NSString *)getStringFromDictionary:(NSDictionary *)dictionary key:(NSString *)key;
+ (NSInteger)getIntergerFromDictionary:(NSDictionary *)dictionary key:(NSString *)key;
+ (NSDictionary *)getDictionaryFromDictionary:(NSDictionary *)dictionary key:(NSString *)key;

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString;
+ (NSString *)queryStringWithDictionary:(NSDictionary *)dictionary;

#pragma mark strings
+ (NSString *)subString:(NSString *)source encode:(NSStringEncoding)enc bytesLength:(NSUInteger)length;

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

#pragma mark tools
+ (NSString *)urlEncode:(NSString *)string;
+ (NSString *)urlDecode:(NSString *)string;
+ (NSString *)base64Encode:(NSString *)string;
+ (NSString *)base64EncodeData:(NSData *)data;

#pragma mark log
+ (void)setOpenLog:(BOOL)openLog;
+ (void)setPrefix:(NSString *)prefix;
+ (BOOL)openLog;
+ (void)outLog:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
#pragma mark math
+ (int)getRand:(int) aMin max:(int) aMax;

#pragma mark UIKit
+ (void)printViewHierarchy:(UIView *)viewNode depth:(NSUInteger)depth;
+ (void)printViews:(NSArray* )wins depth:(NSUInteger)depth;
+ (UIImage *)addImage:(UIImage *)newImage toImage:(UIImage *)oldImage;

#pragma mark Bunldle
+ (NSString *) getBundleRes: (NSString *) filename bundleName:(NSString *) bundleName;

#pragma mark other
+ (BOOL)canOpenUrl:(NSString *)urlString;
+ (BOOL)openUrl:(NSString *)urlString;
+ (BOOL)makingACall:(NSString *)urlString;
//+ (void)presentStoreProductForApp:(NSString *)appId
//                               in:(id<SKStoreProductViewControllerDelegate>)viewController
//                  completionBlock:(void (^)(BOOL result, NSError *error))block;

#pragma mark json
+ (NSString *)JSONFragment:(id)object;
+ (id)JSONValue:(NSString *)string;
+ (id)JSONValue:(NSString *)string error:(NSError **)error;

+ (NSString *)md5Value:(NSString *)string;
@end

@interface UMUtils (Singleton)
+ (UMUtils*) sharedInstance;
@end
