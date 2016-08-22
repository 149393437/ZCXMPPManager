//
//  UMComMessageManager.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComMessageDelegate.h"

@interface UMComMessageManager : NSObject

+ (UMComMessageManager *)shareInstance;

/**
 设置消息处理delegate对象
 
 */
+ (void)setMessageDelegate:(id<UMComMessageDelegate>)messageDelegate;

/**
 设置Appkey
 
 */
+ (void)setAppkey:(NSString *)appKey;

/**
 实现'- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions'方法
 
 */
+ (void)startWithOptions:(NSDictionary *)launchOptions;

/**
 实现方法'- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken'
 
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;


/**
 实现方法'- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo'
 
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

///**
// 自定义active状态下的自定义alertview
// 
// */
//+ (void)openAlertView;

+ (void)handleUserInfo:(NSDictionary *)userInfo;

/**
 添加别名
 
 */
+ (void)addAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;

/**
 删除别名
 
 */
+ (void)removeAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;

/**
 收到对应appkey下的推送至feed详情页通知
 */
+ (void)remoteNotificationForEnterDetailView:(UMComPushDetailViewBlock)handle;

@end
