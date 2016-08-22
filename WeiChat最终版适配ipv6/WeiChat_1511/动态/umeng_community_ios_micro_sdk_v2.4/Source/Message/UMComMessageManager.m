//
//  UMComMessageManager.m
//  UMCommunity
//
//  Created by Gavin Ye on 11/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComMessageManager.h"
#import "UMUtils.h"
#import "UMComLoginManager.h"
#import "UMComNavigationController.h"
#import "UMComTools.h"
#import "UMComSession.h"
#import "UMComFeedDetailViewController.h"
#import "UMCommunity.h"

@interface UMComMessageManager()

@property (nonatomic, strong) id<UMComMessageDelegate>messageDelegate;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, strong) UMComPushDetailViewBlock pushViewBlock;

@end

@implementation UMComMessageManager

static UMComMessageManager *_instance = nil;

+ (UMComMessageManager *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            
        }
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.messageDelegate = [[NSClassFromString(@"UMComUMengMessageHandler") alloc] init];
    }
    return self;
}

+ (void)setMessageDelegate:(id<UMComMessageDelegate>)messageDelegate
{
    if (messageDelegate) {
        [self shareInstance].messageDelegate =  messageDelegate;
    } else {
        UMLog(@"you must set a message delegate!");
    }
}

+ (void)setAppkey:(NSString *)appKey
{
    if (appKey) {
        [self shareInstance].appKey = appKey;
    } else {
        UMLog(@"appkey can not be nil!");
    }
}

+ (void)startWithOptions:(NSDictionary *)launchOptions
{
    id<UMComMessageDelegate> messageDelegate = [self shareInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(startWithAppKey:launchOptions:)]) {
        [messageDelegate startWithAppKey:[self shareInstance].appKey launchOptions:launchOptions];
    }
}

+ (void)registerDeviceToken:(NSData *)deviceToken{
    id<UMComMessageDelegate> messageDelegate = [self shareInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(registerDeviceToken:)]) {
        [messageDelegate registerDeviceToken:deviceToken];
    }
}

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //如果是接收友盟微社区消息通知， 则刷新未读消息数
    if ([userInfo valueForKey:@"umwsq"]) {
        [UMComPushRequest requestConfigDataWithResult:nil];
    }
    id<UMComMessageDelegate> messageDelegate = [self shareInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(didReceiveRemoteNotification:)]) {
        [messageDelegate didReceiveRemoteNotification:userInfo];
    }
}

+ (void)addAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle
{
    id<UMComMessageDelegate> messageDelegate = [self shareInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(addAlias:type:response:)]) {
        [messageDelegate addAlias:name type:type response:^(id responseObject, NSError *error) {
            SafeCompletionDataAndError(handle, responseObject, error);
        }];
    }
}

+ (void)removeAlias:(NSString *)name type:(NSString *)type response:(void (^)(id, NSError *))handle
{
    id<UMComMessageDelegate> messageDelegate = [self shareInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(removeAlias:type:response:)]) {
        [messageDelegate removeAlias:name type:type response:handle];
    }
}

+ (void)handleUserInfo:(NSDictionary *)userInfo
{
    
//    UIViewController *controller = nil;
    NSString *feed_id = nil;
    NSString *comment_id = nil;

        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UIViewController * presentedViewController = rootViewController.presentedViewController;
        if (presentedViewController) {
            while (presentedViewController) {
                if (presentedViewController.presentedViewController){
                    presentedViewController = presentedViewController.presentedViewController;
                } else {
                    break;
                }
            }
        } else {
            presentedViewController = rootViewController;
        }
        
        NSString *controllerName = [userInfo valueForKey:@"umeng_comm_afteropen_controller"];
        if ([controllerName isEqualToString:@"UMComFeedDetailViewController"]) {
            if ([userInfo valueForKey:@"feed_id"]) {
                feed_id = [userInfo valueForKey:@"feed_id"];
            }
            if ([userInfo valueForKey:@"comment_id"]){
                comment_id = [userInfo valueForKey:@"comment_id"];
            }
            if ([feed_id isKindOfClass:[NSString class]]) {
                [UMComLoginManager performLogin:presentedViewController completion:^(id responseObject, NSError *error) {
                    if (!error) {
                        NSMutableDictionary * extraDic = [NSMutableDictionary dictionary];
                        if (feed_id) {
                            [extraDic setValue:feed_id forKey:@"feed_id"];
                        }
                        if (comment_id) {
                            [extraDic setValue:comment_id forKey:@"comment_id"];
                        }
                        UMComFeedDetailViewController *viewController = [[UMComFeedDetailViewController alloc]initWithFeed:feed_id viewExtra:extraDic];
                        viewController.showType = UMComShowFromClickRemoteNotice;
                        if (viewController) {
                            UMComNavigationController *feedDetailNav = [[UMComNavigationController alloc] initWithRootViewController:viewController];
                            [presentedViewController presentViewController:feedDetailNav animated:YES completion:nil];
                        }else
                        {
                            Class UMComRemoteNoticeViewController = NSClassFromString(@"UMComRemoteNoticeViewController");
                            UIViewController *remoteNoticeViewController = [[UMComRemoteNoticeViewController alloc] init];
                            UMComNavigationController *feedDetailNav = [[UMComNavigationController alloc] initWithRootViewController:remoteNoticeViewController];
                            [presentedViewController presentViewController:feedDetailNav animated:YES completion:nil];
                        }

                    }
                }];
                
            }
        }
        else if ([controllerName isEqualToString:@"UMComRemoteNoticeViewController"]){
            [UMComLoginManager performLogin:presentedViewController completion:^(id responseObject, NSError *error) {
                if (!error) {
                    Class UMComRemoteNoticeViewController = NSClassFromString(@"UMComRemoteNoticeViewController");
                    UIViewController *remoteNoticeViewController = [[UMComRemoteNoticeViewController alloc] init];
                    UMComNavigationController *feedDetailNav = [[UMComNavigationController alloc] initWithRootViewController:remoteNoticeViewController];
                    [presentedViewController presentViewController:feedDetailNav animated:YES completion:nil];
                }
            }];
        }
}


+ (void)remoteNotificationForEnterDetailView:(UMComPushDetailViewBlock)handle
{
    [self shareInstance].pushViewBlock = handle;
}

@end
