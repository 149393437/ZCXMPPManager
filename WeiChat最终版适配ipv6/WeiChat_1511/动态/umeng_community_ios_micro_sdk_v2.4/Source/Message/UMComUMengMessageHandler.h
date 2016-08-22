//
//  UMComUMengMessage.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComMessageDelegate.h"
#import "UMessage.h"

@interface UMComUMengMessageHandler : NSObject <UMComMessageDelegate>

- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)addAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;

- (void)removeAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle;
@end
