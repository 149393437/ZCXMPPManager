//
//  UMComLoginManager.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComUserAccount.h"
#import "UMComShareDelegate.h"

@interface UMComShareManager : NSObject


/********************UMComFirstTimeHandelerDelegate*******************/
/**
 获取处理登录完后的逻辑的实现代理
 
 */
@property (nonatomic, strong) id<UMComShareDelegate> shareHadleDelegate;

+ (UMComShareManager *)shareInstance;

/**
 设置登录SDK的appkey
 
 */
+ (void)setAppKey:(NSString *)appKey;

/**
 处理SSO跳转回来之后的url
 
 */
+ (BOOL)handleOpenURL:(NSURL *)url;


@end



