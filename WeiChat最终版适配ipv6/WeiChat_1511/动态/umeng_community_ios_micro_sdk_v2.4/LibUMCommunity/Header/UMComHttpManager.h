//
//  UMComHttpManager.h
//  UMCommunity
//
//  Created by luyiyuan on 14/8/27.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "UMComTools.h"

/**
 feed的评论列表排序类型
 
 */
typedef enum {
    commentorderByDefault = 0,//默认按时间倒序排序
    commentorderByTimeDesc = 1,//按时间倒序排序
    commentorderByTimeAsc = 2, //按时间正序排序
    commentorderByLikeCount = 3
}UMComCommentSortType;

/**
 话题所有feed的排序类型
 
 */
typedef enum{
    UMComFeedSortTypeDefault,
    UMComFeedSortTypeComment,   //评论时间
    UMComFeedSortTypeLike,      //赞时间
    UMComFeedSortTypeForward,     //转发时间
    UMComFeedSortTypeAction,       //评论或赞或转发时间
}UMComFeedSortType;

/**
 用户个人feed列表的排序类型
 
 */
typedef enum {
    UMComTimeLineTypeDefault = 0,//默认返回所有feed
    UMComTimeLineTypeOrigin = 1,//只获取原feed，不带转发
    UMComTimeLineTypeForward = 2//只获取转发的feed
}UMComTimeLineType;





typedef void (^RequestCompletedNoPageResponse)(id responseObject, NSError *error);

@interface UMComHttpManager : NSObject

+ (UMComHttpManager *)shareInstance;

/******************Page request method List start*********************************/

//获取下一页请求
+ (void)getRequestNextPageWithNextPageUrl:(NSString *)urlString
                                 response:(PageDataResponse)response;


#pragma mark - Feed
//获取最新的Feed列表
+ (void)getAllNewFeedsWithCount:(NSInteger)count
                       response:(PageDataResponse)response;

/**
 *  获取相关feed流类型的置顶
 *
 *  @param topFeedCount 请求topfeed的数量
 *  @param response     返回的block处理
 */
+ (void)getTopFeedsWithTopFeedCount:(NSInteger)topFeedCount
                       response:(PageDataResponse)response;

/**
 *  获取相关话题ID下feed流类型的置顶
 *
 *  @param topFeedCount   请求topfeed的数量
 *  @param topfeedTopicID 请求置顶的Feed的话题ID
 *  @param response     返回的block处理
 */
+ (void)getTopFeedsWithTopFeedCount:(NSInteger)topFeedCount
                     topfeedTopicID:(NSString*)topfeedTopicID
                           response:(PageDataResponse)response;

//获取用户关注的Feed列表
+ (void)getUserFocusFeedsWithCount:(NSInteger)count
                          response:(PageDataResponse)response;
//获取社区下的热门Feed列表
+ (void)getHotFeedsWithCount:(NSInteger)count
                  withinDays:(NSInteger)days
                    response:(PageDataResponse)response;

//获取推荐Feed列表
+ (void)getRecommendFeedsWithCount:(NSInteger)count
                          response:(PageDataResponse)response;

//获取好友的Feed列表
+ (void)getFriendFeedsWithCount:(NSInteger)count
                       response:(PageDataResponse)response;

//获取keywords相关的Feed列表
+ (void)getSearchFeedsWithCount:(NSInteger)count
                       keywords:(NSString *)keywords
                       response:(PageDataResponse)response;

//获取附近的Feed列表
+ (void)getNearbyFeedsWithCount:(NSInteger)count
                       location:(CLLocation *)location
                       response:(PageDataResponse)response;

//获取对应feedIds列表对应的Feed列表
+ (void)getFeedsWithFeedIds:(NSArray *)feedIds
                   response:(PageDataResponse)response;

//获取单个
+ (void)getOneFeedWithFeedId:(NSString *)feedId
                   commentId:(NSString *)commentId
                    response:(PageDataResponse)response;

//获取用户时间轴的Feed列表
+ (void)getUserTimelineWithCount:(NSInteger)count
                            fuid:(NSString *)fuid
                        sortType:(UMComTimeLineType)sortType
                        response:(PageDataResponse)response;

//获取用户被@的Feed列表
+ (void)getUserBeAtFeedWithCount:(NSInteger)count
                        response:(PageDataResponse)response;

//获取用户收藏的Feed列表
+ (void)getUserFavouriteFeedsWithCount:(NSInteger)count
                              response:(PageDataResponse)response;

//获取话题相关的Feed列表
+ (void)getTopicRelatedFeedsWithCount:(NSInteger)count
                              topicId:(NSString *)topicId
                             sortType:(UMComFeedSortType)sortType
                            isReverse:(BOOL)isReverse
                             response:(PageDataResponse)response;

//获取话题下的热门Feed列表
+ (void)getTopicHotFeedsWithCount:(NSInteger)count
                       withinDays:(NSInteger)days
                          topicId:(NSString *)topicId
                         response:(PageDataResponse)response;

//获取该话题下推荐feed列表
+ (void)getTopicRecommendFeedsWithCount:(NSInteger)count
                                topicId:(NSString *)topicId
                               response:(PageDataResponse)response;


#pragma mark - user

//获取keywords相关的用户列表
+ (void)getSearchUsersWithCount:(NSInteger)count
                       keywords:(NSString *)keywords
                       response:(PageDataResponse)response;

//获取某个话题相关的活跃用户列表
+ (void)getTopicActiveUsersWithCount:(NSInteger)count
                             topicId:(NSString *)topicId
                            response:(PageDataResponse)response;

//获取推荐的用户列表
+ (void)getRecommentUsersWithCount:(NSInteger)count
                          response:(PageDataResponse)response;

//获取某个用户的粉丝列表
+ (void)getUserFansWithCount:(NSInteger)count
                        fuid:(NSString *)fuid
                    response:(PageDataResponse)response;

//获取某个用户关注的人的列表
+ (void)getUserFollowingsWithCount:(NSInteger)count
                              fuid:(NSString *)fuid
                          response:(PageDataResponse)response;

//获取某个用户的详细信息
+ (void)getUserProfileWithFuid:(NSString *)fuid
                        source:(NSString *)source
                    source_uid:(NSString *)source_uid
                      response:(PageDataResponse)response;

//获取未读feed消息数
+ (void)unreadFeedCountWithSeq:(NSNumber *)seq resultBlock:(RequestCompletedNoPageResponse)response;

#pragma mark - topic

//获取所有的话题列表
+ (void)getAllTopicsWithCount:(NSInteger)count
                     response:(PageDataResponse)response;

//获取keywords相关的话题列表
+ (void)getSearchTopicsWithCount:(NSInteger)count
                        keywords:(NSString *)keywords
                        response:(PageDataResponse)response;
//获取某个用户关注的话题列表
+ (void)getUserFocusTopicsWithCount:(NSInteger)count
                               fuid:(NSString *)fuid
                           response:(PageDataResponse)response;

//获取推荐话题列表
+ (void)getRecommendTopicsWithCount:(NSInteger)count
                           response:(PageDataResponse)response;

//获取单个话题
+ (void)getOneTopicWithTopicId:(NSString *)topicId
                      response:(PageDataResponse)response;

//获取话题类型列表
+ (void)getTopicCategorysWithCount:(NSInteger)count
                          response:(PageDataResponse)response;

//获取类型下的话题列表
+ (void)getTopicsWithCount:(NSInteger)count
                categoryId:(NSString *)categoryId
                  response:(PageDataResponse)response;


#pragma mark - like
//获取某个Feed的点赞列表
+ (void)getFeedLikesWithCount:(NSInteger)count
                       feedId:(NSString *)feedId
                     response:(PageDataResponse)response;
//获取用户点赞列表
+ (void)getUserLikesReceivedWithCount:(NSInteger)count
                             response:(PageDataResponse)response;

//获取用户点赞记录
+ (void)getUserLikesSendsWithCount:(NSInteger)count
                              fuid:(NSString *)fuid
                          response:(PageDataResponse)response;

#pragma mark - comment

//获取某个Feed的评论列表
+ (void)getFeedCommentsWithCount:(NSInteger)count
                          feedId:(NSString *)feedId
                   commentUserId:(NSString *)comment_uid
                        sortType:(UMComCommentSortType)sortType
                        response:(PageDataResponse)response;

//获取用户收到的评论列表
+ (void)getUserCommentsReceivedWithCount:(NSInteger)count
                                response:(PageDataResponse)response;

//获取用户写过的评论列表
+ (void)getUserCommentsSentWithCount:(NSInteger)count
                            response:(PageDataResponse)response;



#pragma mark - notification
//获取用户通知列表
+ (void)getUserNotificationWithCount:(NSInteger)count
                            response:(PageDataResponse)response;


#pragma mark - album
//获取用户相册列表
+ (void)getUserAlbumWithCount:(NSInteger)count
                         fuid:(NSString *)fuid
                     response:(PageDataResponse)response;

#pragma mark - Private Letter 
//获取私信列表
+ (void)getPrivateLetterWithCount:(NSInteger)count
                         response:(PageDataResponse)response;

//获取私信聊天记录
+ (void)getPrivateChartRecordWithCount:(NSInteger)count
                                 toUid:(NSString *)toUid
                              response:(PageDataResponse)response;
//初始化私信窗口
+ (void)initChartBoxWithToUid:(NSString *)toUId
                    responese:(RequestCompletedNoPageResponse)response;
//发送私信
+ (void)sendPrivateMessageWithContent:(NSString *)content
                                toUid:(NSString *)toUid
                            responese:(RequestCompletedNoPageResponse)response;

/******************Page request method List end*********************************/


#pragma mark - other

//获取未读消息数
//+ (void)unreadMessageCountWithUid:(NSString *)uid resultBlock:(RequestCompletedNoPageResponse)response;

// 获取 地理位置数据
+ (void)getLocationNames:(CLLocationCoordinate2D)coordinate
             response:(RequestCompletedNoPageResponse)response;

// 获取配置数据
+ (void)getConfigDataWithResponse:(RequestCompletedNoPageResponse)response;

+ (void)updateTemplateChoice:(NSUInteger)choice
                    response:(RequestCompletedNoPageResponse)response;

/****************************POST Method*****************************************/


#pragma mark -
#pragma mark User

//用户登录

+ (void)userLoginWithName:(NSString *)name
                   source:(NSString *)source
                 sourceId:(NSString *)sourceId
                 icon_url:(NSString *)icon_url
                   gender:(NSNumber *)gender
                      age:(NSNumber *)age
                   custom:(NSString *)custom
                    score:(NSNumber *)score
               levelTitle:(NSString *)levelTitle
                    level:(NSNumber *)level
             userNameType:(UMComUserNameType)userNameType
           userNameLength:(UMComUserNameLength)userNameLength
                 response:(RequestCompletedNoPageResponse)response;

//关注和取消关注用户
+ (void)userFollow:(NSString *)fuid
          isFollow:(BOOL)isFollow
          response:(RequestCompletedNoPageResponse)response;

/**
 更新用户信息
 @warning iconDict 的结构{240:"小图url",360:"中图url",orgin:"大图url",format:"格式"}
 */
//修改用户资料
+ (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                     iconDict:(NSDictionary *)iconDict
                    iconImage:(UIImage *)image
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                     response:(RequestCompletedNoPageResponse)response;

//举报用户
+ (void)spamUser:(NSString *)userId
        response:(RequestCompletedNoPageResponse)response;

//管理员对用户禁言
+ (void)banUserWithUserId:(NSString *)userId
               inTopicIDs:(NSArray *)topicIDs
                      ban:(BOOL)ban
               completion:(RequestCompletedNoPageResponse)result;

//检查用户名是否合法
+ (void)checkUserName:(NSString *)name
         userNameType:(UMComUserNameType)userNameType
       userNameLength:(UMComUserNameLength)userNameLength
          resultBlock:(RequestCompletedNoPageResponse)response;


#pragma mark -
#pragma mark feeds

//创建 feed（发消息）
+ (void)createFeedWithContent:(NSString *)content
                        title:(NSString *)title
                     location:(CLLocation *)location
                 locationName:(NSString *)locationName
                 related_uids:(NSArray *)related_uids
                    topic_ids:(NSArray *)topic_ids
                       images:(NSArray *)images
                         type:(NSNumber *)type
                       custom:(NSString *)custom
                     response:(RequestCompletedNoPageResponse)response;

//点赞某个feed或取消
+ (void)likeFeed:(NSString *)feedId
          isLike:(BOOL)isLike
        response:(RequestCompletedNoPageResponse)response;

//对某 feed 转发(2.3版本及以下)
+ (void)forwardFeed:(NSString *)feedId
            content:(NSString *)content
        relatedUids:(NSArray *)uids
           feedType:(NSNumber *)type
             custom:(NSString *)customContent
           response:(RequestCompletedNoPageResponse)response;

/**
 *  转发feed接口(2.4版本及以上)
 *  @param feedId 转发的feedid(必须发送)
 *  @param content 转发的内容(可选发送)
 *  @param topic_ids 转发的话题字符串(可选发送)
 *  @param uids 相关人列表(可选发送)
 *  @param type feed的类型
 *  @param locationName 地址名称(可选发送)(当前用户所在的位置名称)
 *  @param location 地址名称,lng 经度,lat纬度(可选发送)(当前用户所在的位置的经纬度)
 *  @param custom 自定义字段(可选发送)
 */
+ (void)forwardFeed:(NSString *)feedId
            content:(NSString *)content
          topic_ids:(NSArray *)topic_ids
        relatedUids:(NSArray *)uids
           feedType:(NSNumber *)type
       locationName:(NSString *)locationName
           location:(CLLocation *)location
             custom:(NSString *)customContent
           response:(RequestCompletedNoPageResponse)response;


//举报feed
+ (void)spamFeed:(NSString *)feedId
        response:(RequestCompletedNoPageResponse)response;

//删除feed
+ (void)deleteFeed:(NSString *)feedId
          response:(RequestCompletedNoPageResponse)response;


//收藏某个feed操作/取消收藏某个feed操作
+ (void)favouriteFeedWithFeedId:(NSString *)feedId
                    isFavourite:(BOOL)isFavourite
                    resultBlock:(RequestCompletedNoPageResponse)response;

//统计分享信息
+ (void)shareCallback:(NSString *)platform
               feedId:(NSString *)feedId
             response:(RequestCompletedNoPageResponse)response;


#pragma mark -
#pragma mark comments
//对某 feed 发表评论
+ (void)commentFeed:(NSString *)content
             feedID:(NSString *)feedID
           replyUid:(NSString *)commentUid
     replyCommentID:(NSString *)replyCommentID
      commentCustom:(NSString *)commentCustom
             images:(NSArray *)images
           response:(RequestCompletedNoPageResponse)response;

//举报feed的评论
+ (void)spamComment:(NSString *)commentId
           response:(RequestCompletedNoPageResponse)response;

//删除feed的评论
+ (void)deleteComment:(NSString *)commentId
               feedId:(NSString *)feedId
             response:(RequestCompletedNoPageResponse)response;

+ (void)likeComment:(NSString *)commentId
             isLike:(BOOL)isLike
           response:(RequestCompletedNoPageResponse)response;

#pragma mark -
#pragma mark topic
//关注或取消关注某个话题
+ (void)topicFocuseWithTopicId:(NSString *)topicId
                      isFollow:(BOOL)isFollow
                      response:(RequestCompletedNoPageResponse)response;

#pragma mark - 统计
+ (void)getCommunityStatisticsDataWithResponese:(RequestCompletedNoPageResponse)response;

@end
