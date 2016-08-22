//
//  UMComLoginDelegate.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/11/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComTools.h"

typedef void(^LoginCompletion)(id responseObject, NSError *error);


@class UMComFeed, UMComUserAccount, UMComUser;

@protocol UMComLoginDelegate <NSObject>

@optional
/**
 设置自定义登录的Appkey
 
 */
- (void)setAppKey:(NSString *)appKey;


/**
 自定义登录或者自定义分享处理URL地址
 
 @param 应用回传的URL地址
 
 @returns 处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)url;


/**
 处理自定义登录，在友盟微社区没有登录情况下点击遇到需要登录的按钮，就会触发此方法
 
 @param viewController 父ViewController
 @param LoadDataCompletion 登录完成的回调
 
 */
- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(void (^)(id responseObject, NSError *))completion;


@end
