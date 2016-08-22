//
//  UMComFeedEntity.h
//  UMCommunity
//
//  Created by Gavin Ye on 1/6/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 消息实体，发送消息的方法使用此类构造消息内容
 
 */
@interface UMComFeedEntity : NSObject

/**
 消息文字内容
 
 */
@property (nonatomic, copy) NSString *text;

/**
 消息标题
 
 */
@property (nonatomic, copy) NSString *title;

/**
 消息创建者的用户id
 
 */
@property (nonatomic, copy) NSString *uid;

/**
 消息的图片附件,images中的对象只可以是UIImage类对象或者直接是图片的urlString
 
 */
@property (nonatomic, strong) NSArray *images;

/**
 消息的相关话题
 
 */
@property (nonatomic, strong) NSArray *topics;

/**
 @相关好友
 
 */
@property (nonatomic, strong) NSArray *atUsers;

/**
 地理位置描述
 
 */
@property (nonatomic, copy) NSString *locationDescription;

/**
 地理位置坐标对象
 
 */
@property (nonatomic, strong) CLLocation *location;

/**
 消息类型
 */
@property (nonatomic, strong) NSNumber *type;

/**
 自定义字段
 */
@property (nonatomic, copy) NSString * customContent;


@end
