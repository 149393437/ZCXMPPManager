//
//  UMComMessageModel.h
//  UMCommunity
//
//  Created by umeng on 15/9/26.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMComUnReadNoticeModel : NSObject

@property (nonatomic, copy) NSString *user_id;
/**
 *totalNotiCount == notiByAdministratorCount + notiByCommentCount + notiByAtCount + notiByLikeCount
 
 */
@property (nonatomic, assign) NSInteger totalNotiCount;//总数 各项之和

@property (nonatomic, assign) NSInteger notiByAdministratorCount;//管理员通知未读个数

@property (nonatomic, assign) NSInteger notiByCommentCount;//评论通知未读个数

@property (nonatomic, assign) NSInteger notiByAtCount;//被@通知未读个数

@property (nonatomic, assign) NSInteger notiByLikeCount;//点赞通知未读个数

@property (nonatomic, assign) NSInteger notiByPriMessageCount;//未读私信个数


/**
 *@param noticeDict
 */
+(UMComUnReadNoticeModel *)unReadNoticeModelNoticeDict:(NSDictionary *)noticeDict;

@end
