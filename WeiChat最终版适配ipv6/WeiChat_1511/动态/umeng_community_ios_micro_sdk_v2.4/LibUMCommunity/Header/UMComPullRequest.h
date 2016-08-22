//
//  UMComFetchedResultsController.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/15.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "UMComHttpManager.h"


#define kFetchLimit 20

//定义每页的个数
#define BatchSize 20

//获取所有收藏
#define TotalCollectionsSize 50

typedef NS_ENUM(NSUInteger, UMComFetchSourceType) {
    UMComFetchSourceTypeDefault,
    UMComFetchSourceTypeOnlyLocal,
    UMComFetchSourceTypeOnlyWeb
};

/**
 删除本地Feed返回
 
 */
typedef void (^DeleteCoreDataResponse)(NSArray *deleteData,NSError *error);

/**
 获取本地Feed返回
 
 */
typedef void (^FetchCoreDataResponse)(NSArray *data, NSError *error);

/**
 获取服务器端数据返回
 
 */
typedef void (^FetchServerDataResponse)(NSArray *data,BOOL haveNextPage, NSError *error);

/**
 拉取数据协议
 
 */
@protocol UMComPullResultDelegate <NSObject>


/**
 返回coredata数据
 
 @param 返回结果
 */
- (void)fetchRequestFromCoreData:(FetchCoreDataResponse)coreDataResponse;

/**
 返回服务器端数据
 
 @param 返回结果
 */
- (void)fetchRequestFromServer:(FetchServerDataResponse)serverResponse;

/**
 从服务器返回下一页数据，**需要用户登录之后才能获取**
 
 @param 返回结果
 */
- (void)fetchNextPageFromServer:(FetchServerDataResponse)serverResponse;

@end

@class CLLocation;

/**
 拉取数据的请求
 
 ## 请求对象初始化
 获取社区的数据API全部集成自`UMComPullRequest`，获取不同的数据对应自己的初始化方法，例如`UMComAllFeedsRequest`的初始化方法为：
 
 ```
 UMComAllFeedsRequest *allFeedRequest = [[UMComAllFeedsRequest alloc] initWithCount:20];
 ```
 
 ## 获取数据
 从服务器获取第一页的Feed，返回的数据为`UMComFeed`对象组成的NSArray，若请求的是话题、用户则分别是`UMComTopic`和`UMComUser`对象组成的NSArray，例如
 

    [allFeedRequest fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
    //第一页的数据是
    NSLog(@"feeds is %@",data);
    UMComFeed * theFirstFeed = [data firstObject];   //数据里面每个元素是UMComFeed对象
    //根据第一页请求返回的结果去获取下一页数据
    if (haveNextPage == YES){
        [allFeedRequest fetchNextPageFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        NSLog(@"feeds is %@",data);
        }];
        }
    }];
 
 也可以在获取网络数据之前先获取本地coredata缓存的数据，coredata数据只有第一页的内容
 
 
    [allFeedRequest fetchRequestFromCoreData:^(NSArray *data, NSError *error) {
        //返回消息、结果
        NSLog(@"feeds is %@",data);
    }];
 
 
 */

@interface UMComPullRequest : NSFetchedResultsController<UMComPullResultDelegate>

@property (nonatomic, readonly) BOOL isLoadingData;
@property (nonatomic, readonly) BOOL isRelationshipData;      //获取的数据是否关系数据
@property (nonatomic, readonly) BOOL isHaveNextPage;
@property (nonatomic) UMComFetchSourceType fetchSourceType;

@property (nonatomic, copy) NSString * fuid;
@property (nonatomic, copy) NSString * loginUid;
@property (nonatomic, copy) NSString * topicId;
@property (nonatomic, copy) NSString * feedId;
@property (nonatomic, copy) NSString * keywords;

@property (nonatomic, strong) NSArray *top_feedIds;

- (instancetype)initWithFetchRequest:(NSFetchRequest *)request;

- (instancetype)initWithFetchRequest:(NSFetchRequest *)request count:(NSInteger)count;

@end


#pragma mark - Feed
/**
 获取社区最新的200条数据,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 */
@interface UMComAllNewFeedsRequest : UMComPullRequest

/**
 获取Feed的初始化方法,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param count 数量
 
 @returns 初始化请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end


/**
 获取所有Feed的请求,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 */
@interface UMComAllFeedsRequest : UMComPullRequest

/**
 获取Feed的初始化方法
 
 @param count 数量
 
 @returns 初始化请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end


/**
 获取社区热门Feed,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest` version_2.3
 */
@interface UMComHotFeedRequest : UMComPullRequest

@property (nonatomic, assign) NSInteger days;
/**
 获取社区热门Feed,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param count 数量
 @param days 几天内的热门,支持1,3,7,30天， 默认1天
 
 @returns 初始化请求对象
 */
- (id)initWithCount:(NSInteger)count withinDays:(NSInteger)days;

@end


/**
 搜索推荐Feed,使用方法见父类`UMComPullRequest`，获取的数据是`UMComFeed`对象组成的NSArray
 
 */
@interface UMComRecommendFeedsRequest : UMComPullRequest
/**
 获取推荐Feed初始化方法
 
 @param count 请求个数（暂时用于本地请求）
 
 @returns 获取推荐Feed请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end

/**
 获取话题聚合Feed的请求,使用方法见父类`UMComPullRequest`
 
 */
@interface UMComTopicFeedsRequest : UMComPullRequest

@property (nonatomic, assign) UMComFeedSortType orderType;

@property (nonatomic, strong) NSArray *topic_top_FeedIds;

/**
 是否显示全局置顶（话题下的置顶包括全局置顶和话题置顶，默认为YES，即显示全局置顶和话题置顶，设为NO则只显示话题置顶不显示全局置顶）
 
 */
@property (nonatomic, assign) BOOL isShowGlobalTopItems;

/**
 话题聚合Feed请求的初始化方法,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param topicId 话题Id
 @param count 数量
 @param order 排序方式，默认传UMComFeedSortTypeDefault
 @param isReverse 是否按照倒序排序，即最新的排在前面,如果order传UMComFeedSortTypeDefault，不支持正序
 
 @returns 话题聚合请求对象
 */
- (id)initWithTopicId:(NSString *)topicId
                count:(NSInteger)count
                order:(UMComFeedSortType)order
            isReverse:(BOOL)isReverse;

@end

/**
 获取话题下热门Feed的请求,使用方法见父类`UMComPullRequest` version_2.3
 
 */
@interface UMComTopicHotFeedsRequest : UMComPullRequest

@property (nonatomic, assign) NSInteger days;

/**
 获取话题下热门Feed请求的初始化方法,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param topicId 话题Id
 @param count 数量
 @param days 几天内的热门,支持1,3,7,30天， 默认1天
 
 @returns 话题聚合请求对象
 */
- (id)initWithTopicId:(NSString *)topicId
                count:(NSInteger)count
           withinDays:(NSInteger)days;

@end

/**
 朋友圈Feed请求
 **需要用户登录**
 
 */
@interface UMComFriendFeedsRequest : UMComPullRequest

/**
 获取朋友圈请求的初始化方法,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param count 数量
 
 @returns 朋友圈请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end

/**
 获取用户发送的Feed请求,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 **需要用户登录**
 
 */
@interface UMComUserFeedsRequest : UMComPullRequest

/**
 获取用户发送的Feed的初始化方法,使用方法见父类`UMComPullRequest`
 获取的数据是`UMComFeed`对象组成的NSArray
 
 @param uid 用户id
 @param count Feed数量
 @param type 获取用户feeds类型，原创或者转发，默认可以传`UMComTimeLineTypeDefault`
 
 @returns 获取用户发送Feed的请求对象
 */
- (id)initWithUid:(NSString *)uid count:(NSInteger)count type:(UMComTimeLineType)type;

@end

/**
 搜索Feed的请求,使用方法见父类`UMComPullRequest`，
 **注意此请求不能获取到本地coredata数据**
 
 */
@interface UMComSearchFeedRequest : UMComPullRequest

/**
 搜索Feed请求的初始化方法,获取的数据是`UMComFeed`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param keywords 搜索关键字
 @param count 搜索结果数量
 
 @returns 搜索Feed请求对象
 */

- (id)initWithKeywords:(NSString *)keywords count:(NSInteger)count;

@end


/**
 获取附近的feeds,使用方法见父类`UMComPullRequest`,获取的数据是`UMComFeed`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComNearbyFeedsRequest : UMComPullRequest

/**
 获取附近的feeds
 
 @param location 位置信息
 @param count 请求个数
 
 @returns 获取附近feedsFeed的请求对象
 */
- (id)initWithLocation:(CLLocation *)location count:(NSInteger)count;

@end

/**
 获取登录用户被@的feeds,使用方法见父类`UMComPullRequest`,获取的数据是`UMComFeed`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComUserFeedBeAtRequest : UMComPullRequest

/**
 获取用户被@的feeds
 
 @param count 请求个数
 
 @returns  获取用户被@的feedsFeed的请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end


/**
 获取该登录用户所有收藏的列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComFeed`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComUserFavouritesRequest : UMComPullRequest

@end


/**
 获取话题推荐feed,使用方法见父类`UMComPullRequest`,获取的数据是`UMComFeed`对象组成的NSArray
 
 */


@interface UMComTopicRecommendFeedsRequest : UMComPullRequest

/**
 获取话题推荐feed
 
 @param topicId 话题ID
 
 @param count 请求个数
 
 @returns  成功则返回UMComFeed对象的数组，否则返回请求错误
 */
- (id)initWithTopicId:(NSString *)topicId count:(NSInteger)count;

@end

/**
 根据feedId获取feed列表，每次最多20条，过多返回错误码20011,获取的数据是`UMComFeed`对象组成的NSArray
 
 @param feedIds feedId
 
 */
@interface UMComFeedsByFeedIdsRequest : UMComPullRequest

- (id)initWithFeedIds:(NSArray *)feedIds;

@end

/**
 获取一个Feed的请求,获取的数据是`UMComFeed`对象组成的NSArray，此数据只有一个对象
 使用方法见父类`UMComPullRequest`
 
 */
@interface UMComOneFeedRequest : UMComPullRequest

/**
 获取一个Feed请求的初始化方法,使用方法见父类`UMComPullRequest`
 
 @param feedId FeedId
 @param viewExtra 一般传nil，用作接收消息推送之后把消息推送获取到的comment_id和feed_id数据分别以@"comment_id"和@"feed_id"为key组成的viewExtra对象传进来。
 
 @returns 获取一个Feed请求对象
 */
- (id)initWithFeedId:(NSString *)feedId
           viewExtra:(NSDictionary *)viewExtra;

@end

/**
 *  feed流置顶的请求(since 2.4版本)
 */
@interface UMComTopFeedRequest : UMComPullRequest

/**
 *  初始化置顶feed请求
 *
 *  @param topFeedCount 请求的top数量
 *
 *  @return 返回UMComTopFeedRequest类型对象
 */
- (_Nullable id)initwithTopFeedCountCount:(NSInteger)topFeedCount;

@end

/**
 话题下feed置顶
 */
@interface UMComTopicTopFeedRequest : UMComPullRequest

- (_Nullable id)initwithTopFeedCount:(NSInteger)topFeedCount topFeedTopicID:(NSString* _Nullable)topFeedTopicID;

@end

#pragma mark - user

/**
 搜索用户的请求,获取的数据是`UMComUser`对象组成的NSArray
 使用方法见父类`UMComPullRequest`，
 **注意此请求不能获取到本地coredata数据**
 
 */
@interface UMComSearchUserRequest : UMComPullRequest

/**
 搜索用户请求的初始化方法,使用方法见父类`UMComPullRequest`
 
 @param keywords 搜索关键字
 @param count 搜索结果数量
 
 @returns 搜索用户请求对象
 */
- (id)initWithKeywords:(NSString *)keywords count:(NSInteger)count;

@end

/**
 获取粉丝请求,获取的数据是`UMComUser`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 **需要用户登录**
 
 */
@interface UMComFansRequest : UMComPullRequest

/**
 获取粉丝的初始化方法,获取的数据是`UMComUser`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param uid 用户id
 
 @returns 获取粉丝请求对象
 */
- (id)initWithUid:(NSString *)uid count:(NSInteger)count;

@end


/**
 获取关注用户请求,获取的数据是`UMComUser`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 **需要用户登录**
 
 */
@interface UMComFollowersRequest : UMComPullRequest

/**
 获取用户关注者请求的初始化方法,获取的数据是`UMComUser`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param uid 用户id
 
 @returns 获取关注用户请求的对象
 */
- (id)initWithUid:(NSString *)uid count:(NSInteger)count;

@end


/**
 搜索推荐用户,使用方法见父类`UMComPullRequest`，获取的数据是`UMComUser`对象组成的NSArray
 
 */
@interface UMComRecommendUsersRequest : UMComPullRequest
/**
 获取推荐用户初始化方法
 
 @param count 请求个数（暂时用于本地请求）
 
 @returns 获取推荐用户请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end


/**
 返回该话题对应的热门用户,使用方法见父类`UMComPullRequest`,获取的数据是`UMComTopic`对象组成的NSArray
 
 */
@interface UMComRecommendTopicUsersRequest : UMComPullRequest
/**
 获取话题推荐用户请求初始化方法
 
 @param topicId 话题ID
 
 @param count 请求个数（暂时用于本地请求）
 
 @returns 获取话题推荐用户请求对象
 */
- (id)initWithTopicId:(NSString *)topicId count:(NSInteger)count;

@end

/**
 获取用户的账户信息请求,获取的数据是`UMComUser`对象组成的NSArray,此数据只有一个元素
 使用方法见父类`UMComPullRequest`
 **需要用户登录**
 
 */
@interface UMComUserProfileRequest : UMComPullRequest

/**
 获取用户详细信息请求的初始化方法,使用方法见父类`UMComPullRequest`
 
 @param uid 友盟账号系统的用户ID,对应的是`UMComUser`的属性uid
 @param sourceUids 是NSDictionry类型，sourceUids结构是 @{@"source":@"self_account",@"source_uid":自己平台UID};self_account自己的平台，source_uid自己平台UID
 @warming uid和sourceUids 两个参数只需要选其中一个就可以，但是账号必须跟友盟微社区UID一一对应
 @returns 获取用户详细信息请求对象
 */
- (id)initWithUid:(NSString *)uid sourceUid:(NSDictionary *)sourceUids;

@end


#pragma mark - topic

/**
 获取所有话题的请求,获取的数据是`UMComTopic`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 */
@interface UMComAllTopicsRequest : UMComPullRequest

/**
 获取所有话题的初始化方法,获取的数据是`UMComTopic`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 @param count 数量
 
 @returns 获取所有话题请求的对象
 */
- (id)initWithCount:(NSInteger)count;

@end

/**
 用户关注话题的请求,获取的数据是`UMComTopic`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 */

@interface UMComUserTopicsRequest : UMComPullRequest

/**
 获取用户关注话题的初始化方法,使用方法见父类`UMComPullRequest`
 
 @param uid 用户id
 @param count 数量
 
 @returns 用户关注话题请求对象
 */
- (id)initWithUid:(NSString *)uid count:(NSInteger)count;

@end


/**
 搜索话题请求,使用方法见父类`UMComPullRequest`，获取的数据是`UMComTopic`对象组成的NSArray
 **注意此请求不能获取到本地coredata数据**
 
 */
@interface UMComSearchTopicRequest : UMComPullRequest

/**
 搜索话题请求的初始化方法,使用方法见父类`UMComPullRequest`
 
 @param keywords 搜索话题关键字
 
 @returns 搜索话题请求对象
 */
- (id)initWithKeywords:(NSString *)keywords;

@end


/**
 搜索推荐话题,使用方法见父类`UMComPullRequest`,获取的数据是`UMComTopic`对象组成的NSArray
 
 */
@interface UMComRecommendTopicsRequest : UMComPullRequest
/**
 获取推荐话题请求初始化方法
 
 @param count 请求个数（暂时用于本地请求）
 
 @returns 获取推荐话题请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end

/**
 获取单个话题,使用方法见父类`UMComPullRequest`,获取的数据是`UMComTopic`对象组成的NSArray 只有一个对象(version2.2.1)
 
 */
@interface UMComOneTopicRequest : UMComPullRequest

/**
 获取单个话题
 
 @param topicId
 
 returns 返回获取单个话题请求对象
 */
- (id)initWithTopicId:(NSString *)topicId;

@end


/**
 获取对应类别下的话题列表请求类，使用方法见父类`UMComPullRequest`,获取的数据是`UMComTopic`对象组成的NSArray
 */
@interface UMComTopicTypeTopicsRequest : UMComPullRequest

@property (nonatomic, copy) NSString *categoryId;

/**
 获取对应类别下的话题列表请求类
 
 @param count  请求个数
 @param categoryId 话题类别ID
 
 returns  获取对应类别下的话题列表请求类
 */

- (id)initWithCount:(NSInteger)count categoryId:(NSString *)categoryId;

@end


/**
 获取话题类型列表请求类，使用方法见父类`UMComPullRequest`,获取的数据是`UMComTopiCategory`对象组成的NSArray
 */
@interface UMComTopicTypesRequest : UMComPullRequest
/**
 获取话题类型列表请求类
 
 @param count 请求个数
 
 @returns  获取话题类型列表请求类对象
 */
- (id)initWithCount:(NSInteger)count;
@end


#pragma mark - comment

/**
 获取Feed所有评论请求,获取的数据是`UMComComment`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 */

@interface UMComFeedCommentsRequest : UMComPullRequest

@property (nonatomic, copy) NSString *comment_uid;
/**
 获取Feed所有评论的初始化方法,使用方法见父类`UMComPullRequest`
 
 @param feedId FeedId
 @param comment_uid	发出评论用户id(用于实现只看楼主)
 @param count 评论数量
 @param order: commentorderByTimeDesc时间倒序排列，commentorderByTimeAsc时间正序排列，不传默认为倒序
 
 @returns 获取Feed所有评论请求对象
 */
- (id)initWithFeedId:(NSString *)feedId
       commentUserId:(NSString *)comment_uid
               order:(UMComCommentSortType)orderType
               count:(NSInteger)count;

@end


/**
 获取登录用户被别人评论的列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComComment`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComUserCommentsReceivedRequest : UMComPullRequest

/**
 获取登录用户被评论的列表
 **需要用户登录**
 
 @param count 请求个数
 
 @returns 获取用户被评论的列表的请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end


/**
 获取登录用户发出的评论列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComComment`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComUserCommentsSentRequest : UMComPullRequest

/**
 获取用户发出的评论列表
 
 @param count 请求个数
 
 @returns 获取用户的评论列表的请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end


#pragma mark - like
/**
 获取Feed所有赞的请求,获取的数据是`UMComLike`对象组成的NSArray
 使用方法见父类`UMComPullRequest`
 
 */
@interface UMComFeedLikesRequest : UMComPullRequest

/**
 获取Feed所有赞请求初始化方法,使用方法见父类`UMComPullRequest`
 
 @param feedId FeedId
 @param count 数量
 
 @returns 获取Feed所有赞请求对象
 */
- (id)initWithFeedId:(NSString *)feedId count:(NSInteger)count;

@end


/**
 获取登录用户被点赞的列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComLike`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComUserLikesReceivedRequest : UMComPullRequest

/**
 获取用户被别人点赞的列表
 
 @param count 请求个数
 
 @returns 获取用户被点赞的列表的请求对象
 */
- (id)initWithCount:(NSInteger)count;


@end


/**
 获取登录用户点赞的列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComLike`对象组成的NSArray
 **需要用户登录**(version2.2.1)
 
 */
@interface UMComUserLikesSendRequest : UMComPullRequest

/**
 获取用户点赞的列表
 
 @param count 请求个数
 
 @returns 获取用户点赞的列表的请求对象
 */
- (id)initWithCount:(NSInteger)count fuid:(NSString *)fuid;


@end

#pragma mark - Notification
/**
    获取管理员的通知列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComNotification`对象组成的NSArray
    **此请求不能获取本地coredata数据**
    **需要用户登录**
 
 */
@interface UMComUserNotificationRequest : UMComPullRequest

/**
 获取管理员的通知列表
 
 @param count 请求个数
 
 @returns  获取管理员的通知列表的请求对象
 */
- (id)initWithCount:(NSInteger)count;

@end

#pragma mark - Album
/**
 获取用户相册,使用方法见父类`UMComPullRequest`,获取的数据是`UMComAlbum`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComUserAlbumRequest : UMComPullRequest

/**
 获取相册
 
 @param count 请求个数
 @param fuid 请求的用户uid
 
 @returns 获取用户相册的请求对象
 */
- (id)initWithCount:(NSInteger)count fuid:(NSString *)fuid;

@end


#pragma mark - Location
/**
 获取地理位置列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComLocationModel`对象组成的NSArray
 **需要用户登录**
 
 */
@interface UMComLocationRequest : UMComPullRequest

/**
 获取地理位置列表
 
 @param location 当前位置
 
 @returns 获取地理位置列表的请求对象
 */

- (id)initWithLocation:(CLLocation *)location;


@end


#pragma mark - Private Letter
/**
 获取私信列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComPrivateLetter`对象组成的NSArray
 **需要用户登录** version_2.3
 
 */
@interface UMComPrivateLetterRequest : UMComPullRequest

/**
 获取私信列表
 
 @param count 数量
 
 @returns 获取私信列表
 */
- (id)initWithCount:(NSInteger)count;


@end


/**
 获取私信聊天记录列表,使用方法见父类`UMComPullRequest`,获取的数据是`UMComPrivateMessage`对象组成的NSArray
 **需要用户登录** version_2.3
 
 */
@interface UMComPrivateMessageRequest : UMComPullRequest

@property (nonatomic, copy) NSString *private_letter_id;

/**
 获取私信聊天记录列表
 
 @param count               表示要查询的数量
 @param toUid               表示要查看用户的UID(不能为空),@see UMComUser类的uid字段
 @param private_letter_id   表示和toUid聊天的私信的唯一ID(可以为空,通过服务器获得)
 @returns                   获取私信聊天记录列表
 */
- (id)initWithCount:(NSInteger)count
              toUid:(NSString * __nonnull)toUid
  private_letter_id:(NSString * __nullable)private_letter_id;


@end



