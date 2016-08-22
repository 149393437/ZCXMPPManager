//
//  UMComPostDataRequest.h
//  UMCommunity
//
//  Created by Gavin Ye on 12/22/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComTools.h"

@class UMComUserAccount;
@class UMComFeedEntity;
@class UMComUser;
@class UMComTopic;
@class UMComFeed;
@class UMComComment;
@class UMComPrivateMessage;
@class UMComPrivateLetter;

/**
 返回结果回调
 
 */
typedef void (^PostResultResponse)(NSError *error);

/**
 带有数据的返回结果回调
 
 */
typedef void (^PostResponseResultResponse)(id responseObject, NSError *error);

/**
 用户登录请求，直接把userAccount的数据上传到server，返回上传的用户资料
 
 */
@interface UMComPushRequest : NSObject

#pragma mark - User
/**
 提交登录用户数据
 
 @param userAccount 登录用户
 @param result 返回结果, responseObject是`UMComUser`对象,即登录成功之后返回的登录用户
 */
+ (void)loginWithUser:(UMComUserAccount *)userAccount
           completion:(PostResponseResultResponse)result;


/**
 更新登录用户数据
 
 @param userAccount 登录用户
 @param result 返回结果
 */
+ (void)updateWithUser:(UMComUserAccount *)userAccount
            completion:(PostResultResponse)result;


/**
 举报用户
 
 @param userId 用户Id
 @param result 结果
 */
+ (void)spamWithUser:(UMComUser *)user
          completion:(PostResultResponse)result;



/**
 关注用户或者取消关注
 
 @param user 用户
 @param isFollow 关注用户或者取消关注
 @param result 结果
 */
+ (void)followerWithUser:(UMComUser *)user
                isFollow:(BOOL)isFollow
              completion:(PostResultResponse)result;

/**
 管理员对用户禁言
 
 @param user 被禁言用户
 @param topics 禁言的话题`UMComTopic`对象列表，即管理员可以根据自己的权限对某个用户在某个话题下禁言，全局管理员则具有任何话题下的禁言权限（必填）
 @param ban   是否禁言，如果为YES表示禁言，如果为NO表示取消禁言(2.3及以下版本暂时没用)
 @param result 操作结果回调
 */
+ (void)banUser:(UMComUser *)user
       inTopics:(NSArray *)topics
            ban:(BOOL)ban
     completion:(PostResponseResultResponse)result;


/**
 检查用户名合法接口
 
 @param name           用户名
 @param userNameType   用户名规范，`userNameNoBlank`没有空格，`userNameNoRestrict`没有限制
 @param userNameLength 用户名长度，`userNameLengthDefault`默认长度，`userNameLengthNoRestrict`没有长度限制
 @param result         error的code :
                       10010 户名长度错误
                       10012 用户名敏感
                       10016  用户名格式错误
 */
+ (void)checkUserName:(NSString *)name
         userNameType:(UMComUserNameType)userNameType
       userNameLength:(UMComUserNameLength)userNameLength
           completion:(PostResultResponse)completion;


/**
 获取初始化数据和更新未读消息数
 
 @param result 初始化数据结果，`responseObject`的key`config.feed_length`为设置最大feed文字内容 `responseObject`的key`msg_box`是各个未读消息数，`msg_box`下面的`total`为所有未读通知数，key为`notice`为管理员未读通知数，`comment`为被评论未读通知数，`at`为被@未读通知数，`like`为被点赞未读通知数
 @warning 这些数据都会保存在UMComSession单利里面 `config.feed_lenght`对应的UMComSession的maxFeedLength属性，`message_box`保存在UMComSession的unReadNoticeModel属性里面，unReadNoticeModel是`UMComUnReadNoticeModel`类的对象，
 
 
 */
+ (void)requestConfigDataWithResult:(PostResponseResultResponse)result;

#pragma mark - Feed

/**
 创建新feed,例如
 
 ```
 UMComFeedEntity *feedEntity = [[UMComFeedEntity alloc] init];
 NSString *dateString = [[NSDate date] description];
 NSString *feedString = [NSString stringWithFormat:@"测试发送feed消息 %@",dateString];
 feedEntity.text = feedString;
 [UMComPushRequest postWithFeed:feedEntity completion:^(NSError *error) {
 }];
 ```
 
 @param newFeed newFeed构造参考'UMComFeedEntity'
 @param result 结果
 */
+ (void)postWithFeed:(UMComFeedEntity *)newFeed
          completion:(PostResponseResultResponse)result;


/**
 转发Feed
 
 @param feed 被转发的Feed
 @param newFeed 新Feed，只有`text`和`atUsers`有效，newFeed构造参考'UMComFeedEntity'
 @param result 结果
 */
+ (void)forwardWithFeed:(UMComFeed *)feed
                newFeed:(UMComFeedEntity *)newFeed
             completion:(PostResponseResultResponse)result;


/**
 发送Feed 点赞或取消点赞请求
 
 @param feed 被赞的Feed
 @param isLiek 当isLike为YES时为点赞反之取消点赞
 @param result 结果
 */
+ (void)likeWithFeed:(UMComFeed *)feed
              isLike:(BOOL)isLike
          completion:(PostResponseResultResponse)result;

/**
 举报Feed
 
 @param feed 被举报的Feed
 @param result 结果
 */
+ (void)spamWithFeed:(UMComFeed *)feed
          completion:(PostResultResponse)result;

/**
 删除Feed
 
 @param feed 被删除的Feed
 @param result 结果
 */
+ (void)deleteWithFeed:(UMComFeed *)feed
            completion:(PostResultResponse)result;

/**
 feed收藏操作和取消收藏操作
 
 @param feed        被收藏的feed
 @param isFavourite 是否收藏，YES为收藏操作，为NO则为取消收藏操作
 @param result      结果
 */
+ (void)favouriteFeedWithFeed:(UMComFeed *)feed
                  isFavourite:(BOOL)isFavourite
                   completion:(PostResultResponse)result;

/**
 发送统计分享次数
 
 @param feed 分享成功的feed
 @param result 结果
 */
+ (void)postShareStaticsWithPlatformName:(NSString *)platform
                                    feed:(UMComFeed *)feed
                              completion:(PostResultResponse)result;

/**
 获取未读feed个数
 
 @parma seq 返回的Feed流列表第一个Feed的seq属性值
 @param result 结果
 */
+ (void)fetchUnreadFeedCountWithSeq:(NSNumber *)seq
                             result:(PostResponseResultResponse)result;

#pragma mark - Comment

/**
 发送Feed带自定义字段的评论
 
 @param feed   被评论的Feed （必传）
 @param commentContent 评论内容 （必传）
 @param replyComment 回复的评论 （可选，当回复某条评论时必传）
 @param commentCustomContent 评论自定义字段 （可选，用户根据自己业务需要添加的扩展字段）
 @param images 评论附带图片（images中的对象可以是UIIamge类对象，也可以直接是图片的urlString）,图片限制3张（可选）
 @param response 评论请求完成的回调，返回两个参数分别是：`UMComComment`对象和`NSError`类对象，成功则返回一个`UMComComment`对象和error为nil，失败则返回nil和错误error
 */
+ (void)commentFeedWithFeed:(UMComFeed *)feed
             commentContent:(NSString *)commentContent
               replyComment:(UMComComment *)replyComment
       commentCustomContent:(NSString *)commentCustomContent
                     images:(NSArray *)images
                 completion:(PostResponseResultResponse)response;

/**
 举报feed的评论
 
 @param comment   评论
 @param result    返回结果
 */
+ (void)spamWithComment:(UMComComment *)comment
             completion:(PostResponseResultResponse)result;

/**
 删除feed的评论
 
 @param comment   删除的评论
 @param feed      评论的Feed
 @param result    返回结果
 */
+ (void)deleteWithComment:(UMComComment *)comment
                     feed:(UMComFeed *)feed
               completion:(PostResponseResultResponse)result;

/**
 评论点赞或取消点赞
 
 @param comment   评论
 @param isLike    是否点赞，如果点赞则为YES,取消点赞则为NO
 @param result    返回结果
 */
+ (void)likeWithComment:(UMComComment *)comment
                 isLike:(BOOL)isLike
             completion:(PostResponseResultResponse)result;

#pragma mark - Topic

/**
 关注话题
 
 @param topic 关注或取消关注的话题
 @param isFollower 是否关注该话题,或者取消关注话题，isFollower为YES表示关注，否则取消关注
 @param result 结果返回一个NSError对象
 */
+ (void)followerWithTopic:(UMComTopic *)topic
               isFollower:(BOOL)isFollower
               completion:(PostResultResponse)result;



#pragma mark - Private Letter

/**
 初始化私信聊天窗口
 
 @param user      私信聊天对象（User是管理员或者如果当前登录用户是管理员，user为任意用户）
 @param response  返回的是一个`UMComPrivateLetter`对象和一个NSError对象
 */
+ (void)initChartBoxWithToUser:(UMComUser *  __nonnull)user
                     responese:(PostResponseResultResponse __nullable)response;


/**
 向管理员发送私信
 
 @param user 私信聊天对象（管理员）
 @param response  返回的是一个`UMComPrivateMessage`对象和一个NSError对象
 */
+ (void)sendPrivateMessageWithContent:(NSString *)content
                               toUser:(UMComUser *)user
                            responese:(PostResponseResultResponse)response;

#pragma mark - 社区统计
/**
 获取社区统计字段
 
 @param response  返回的是一个Dictionary，数据结构为{
 feed =     {
 daily = 34;
 total = 3641;
 weekly = 89;
 };
 }
 total 为帖子总量
 daily feed日增长量
 weekly feed周平均增长量
 */
+ (void)getCommunityStatisticsDataWithResponese:(PostResponseResultResponse)response;

@end