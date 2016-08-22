//
//  UMComUMengMessage.m
//  UMCommunity
//
//  Created by Gavin Ye on 11/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComUMengMessageHandler.h"
#import "UMComMessageManager.h"
#import "UMUtils.h"

@interface UMComUMengMessageHandler()

@property (nonatomic, strong) NSDictionary  * userInfo;

@end

@implementation UMComUMengMessageHandler

- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:appKey launchOptions:launchOptions];
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:nil];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
#endif
    }
    else
    {
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
}

- (void)registerDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    self.userInfo = userInfo;
    [UMessage didReceiveRemoteNotification:userInfo];
    NSString *content = [userInfo valueForKeyPath:@"aps.alert"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收到一条通知" message:content delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看",nil];
    [alertView show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [UMComMessageManager handleUserInfo:self.userInfo];
    }
}

- (void)addAlias:(NSString *)name type:(NSString *)type response:(void (^)(id, NSError *))handle
{
    [UMessage addAlias:name type:type response:^(id responseObject, NSError *error) {
        handle(responseObject,error);
    }];
}

- (void)removeAlias:(NSString *)name type:(NSString *)type response:(void (^)(id, NSError *))handle
{
    [UMessage removeAlias:name type:type response:handle];
}
@end
