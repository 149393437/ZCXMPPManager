//
//  UMCommunity.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/11.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UMComMessageManager.h"

#import "UMComLoginManager.h"

#import "UMComPushRequest.h"

#import "UMComPullRequest.h"

/**
 友盟微社区总体控制类
 
 */
@interface UMCommunity : NSObject

/**
 设置打开Log
 
 @param isLog 是否打开Log
 
 */
+ (void)openLog:(BOOL)isLog;

/**
 设置appkey
 
 @param appkey 应用appkey
 
 */
+ (void)setWithAppKey:(NSString *)appkey;

/**
 得到一个消息流页面的普通UIViewController对象
  **此UIViewController没有navigationController,为了正常显示页面需要设置它的navigationController活着通过navigationController直接push进入这个ViewController**
 
 @returns 消息流页面
 */
+ (UIViewController *)getFeedsViewController;

/**
 得到一个消息流页面的模态窗口对象
 
 @returns 消息流页面
 */
+ (UINavigationController *)getFeedsModalViewController;

/**
 修改进入各个话题页面发送的feed是否显示话题名称，默认会显示
 
 @param showTopic 是否显示topic
 */
+ (void)setShowTopicName:(BOOL)showTopic;
@end
