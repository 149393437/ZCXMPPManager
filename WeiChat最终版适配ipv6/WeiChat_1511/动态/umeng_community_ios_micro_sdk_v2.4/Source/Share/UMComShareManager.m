//
//  UMComLoginManager.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComShareManager.h"
#import "UMComShareDelegate.h"

@interface UMComShareManager ()

@property (nonatomic, copy) NSString *appKey;

@end

@implementation UMComShareManager

static UMComShareManager *_instance = nil;
+ (UMComShareManager *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[UMComShareManager alloc] init];
        }
    }
    return _instance;
}

+ (void)setAppKey:(NSString *)appKey
{
    if ([[self shareInstance].shareHadleDelegate respondsToSelector:@selector(setAppKey:)]) {
        [self shareInstance].appKey = appKey;
        [[self shareInstance].shareHadleDelegate setAppKey:appKey];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        Class delegateClass = NSClassFromString(@"UMComShareDelegateHandler");
        self.shareHadleDelegate = [[delegateClass alloc] init];
    }
    return self;
}


+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([[self shareInstance].shareHadleDelegate respondsToSelector:@selector(handleOpenURL:)]) {
        return [[self shareInstance].shareHadleDelegate handleOpenURL:url];
    }
    return NO;
}

@end
