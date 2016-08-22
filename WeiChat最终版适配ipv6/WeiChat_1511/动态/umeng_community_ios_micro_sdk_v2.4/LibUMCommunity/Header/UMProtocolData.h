//
//  Created by ming on 08/28/13.
//
//


#import <Foundation/Foundation.h>

#define UM_SAFE_STR(Object) (Object==nil?@"":Object)
@interface UMProtocolData : NSObject

#pragma mark dateTime info

+ (NSString *)dateString;

+ (NSString *)timeString;

+ (NSString *)timeMSString;

+ (NSString *)latString;

+ (NSString *)lngString;

#pragma mark deviceAndOS info
//just for iOS 6.0 or later,please test in device
//+ (NSString *)deviceIDAdverString;

//just for iOS 6.0 or later
+ (NSString *)deviceIDVendorString;

//mac_adress
+ (NSString *)deviceMacString;

//mac_adress_md5
//+ (NSString *)deviceMacMD5String;

+ (NSString *)openUDIDString;

+ (NSString *)UUIDString;

+ (NSString *)UUIDMD5String;

//device_model
+ (NSString *)deviceModelString;

//resolution
+ (NSString *)resolutionString;

//os
+ (NSString *)osString;

//os_version
+ (NSString *)osVersionString;

//cpu
+ (NSString *)cpuString;

+ (NSString *)orientationString;

//is_jailbroken
+ (BOOL)isDeviceJailBreak;

+ (NSString *)deviceJailBreakString;

+ (BOOL)isPad;

//country
+ (NSString *)countryString;

//language
+ (NSString *)languageString;

//timezone
+ (NSString *)timezoneString;

#pragma mark network info

//access
+ (NSString *)accessString;

//carrier
+ (NSString *)carrierString;

#pragma mark ipa info

//is_pirated
+ (BOOL)isAppPirate;

+ (NSString *)appPirateString;

//package_name
+ (NSString *)appPackageNameString;

//display_name
+ (NSString *)appDisplayNameString;

//app_version
+ (NSString *)appBundleVersionString;

//appShortversion
+ (NSString *)appShortVersionString;
@end