//
//  UMComComment.h
//  UMCommunity
//
//  Created by umeng on 15/11/2.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComFeed, UMComUser,UMComImageUrl;

@interface UMComComment : UMComManagedObject
/**
 评论唯一ID
 */
@property (nonatomic, retain) NSString * commentID;
/**
 评论内容
 */
@property (nonatomic, retain) NSString * content;
/**
 评论创建时间
 */
@property (nonatomic, retain) NSString * create_time;
/**
 评论自定义字段（开发者自己定义并使用，可通过创建评论接口上传）
 */
@property (nonatomic, retain) NSString * custom;
/**
 是否已点赞过这个评论 @1为点赞，@0为未点赞
 */
@property (nonatomic, retain) NSNumber * liked;
/**
 评论点赞个数
 */
@property (nonatomic, retain) NSNumber * likes_count;
/**
 保留字段(暂时没用)
 */
@property (nonatomic, retain) NSNumber * seq;
/**
 评论状态 大于@1表示评论已被删除，等于@0表示正常
 */
@property (nonatomic, retain) NSNumber * status;
/**
 评论楼层，表示几楼几楼，楼主为@0
 */
@property (nonatomic, retain) NSNumber * floor;
/**
 字段值为111（Comment全部权限）或者100（删除feed权限）目前只有这两种权限可以操作feed,值为0则没有任何相关权限
 */
@property (nonatomic, retain) NSNumber *permission;
/**
 用于判断是否可以对评论的用户禁言,值为1表示可以禁言，值为0表示不能禁言
 */
@property (nonatomic, retain) NSNumber *ban_user;
/**
 发评论的用户
 */
@property (nonatomic, retain) UMComUser *creator;
/**
 被评论的Feed
 */
@property (nonatomic, retain) UMComFeed *feed;
/**
 本评论回复的用户
 */
@property (nonatomic, retain) UMComUser *reply_user;
/**
 本评论回复的原评论
 */
@property (nonatomic, retain) UMComComment *reply_comment;
/**
 评论附带图片(存储的是'UMComImageUrl'类对象)
 */
@property (nonatomic, retain) NSOrderedSet <UMComImageUrl *> *image_urls;

@end
