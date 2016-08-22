//
//  UMComMessageDelegate.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UMComPushDetailViewBlock)(NSString *appkey, NSString *feedID, NSString *commentID, NSDictionary *extraDict);

@protocol UMComMessageDelegate <NSObject>

- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)addAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;

- (void)removeAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;

@end
