//
//  UMComLoginDelegate.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/11/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComTools.h"

@class UMComFeed;

@protocol UMComShareDelegate <NSObject>

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
 点击某个分享平台之后的回调方法
 
 @param platformIndex 分享平台名所在的位置
 @param feed 分享的当条Feed
 @param viewController 当前ViewController

 */
- (void)didSelectPlatformAtIndex:(NSInteger)platformIndex
                            feed:(UMComFeed *)feed
                  viewController:(UIViewController *)viewControlller;




@end
