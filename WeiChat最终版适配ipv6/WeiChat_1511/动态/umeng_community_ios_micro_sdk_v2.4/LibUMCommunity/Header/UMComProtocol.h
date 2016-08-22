//
//  UMComProtocol.h
//  UMCommunity
//
//  Created by Gavin Ye on 1/8/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#ifndef UMCommunity_UMComProtocol_h
#define UMCommunity_UMComProtocol_h

#define LoginPath @"user/"

#define FollowPath @"user/follow"

#define UserProfilePath @"user/profile"

#define UpdateProfilePath @"user/profile"

#define UpdateProfileImagePath @"user/icon"

#define FocusTopicPath @"topic/focus"

#define NewFeedPath @"feed/"

#define NewImagePath @"feed/image"

#define FeedLikePath @"feed/like"

#define FeedLikesPath @"feed/likes"

#define FeedCommentPath @"feed/comment"

#define FeedForwardPath @"feed/forward"

#define FeedLocationsPath @"feed/location"

#define FeedSpamPath @"spammer/feed"

#define UserSpamPath @"spammer/user"

#define FeedDeletePath @"feed/"

#define FeedCountPath @"user/feeds_count"

#define FeedCommentsPath @"feed/comments"

#define TopicSearchPath @"topic/search"

#define UserFeedsPath @"user/feeds"

#define AllNewFeedsPath @"feeds/stream"

#define UserTimeLinePath @"user/timeline"

#define NearbyFeedsPath @"feed/nearby"

#define UserTopicsPath @"user/topics"

#define UserFansPath @"user/fans" 

#define UserFollowerPath @"user/followings"

#define AllTopicsPath @"topics/"//||/api/topics/

#define TopicFeedsPath @"topic/feeds"

#define OnFeedSearchPath @"feed/"

#define FeedByFeedIdsPath @"feeds/"

/*************推荐API**********/
#define RecommendUsersPath @"user/recommended_user"

#define RecommendFeedsPath @"user/recommended_feed"

#define RecommendTopicsPath @"user/recommended_topic"

#define RecommendTopicUsersPath @"topic/recommended_user"


/**************搜索API ****************/
#define SearchUserPath @"user/search"

#define SearchFeedPath @"feed/search"

#define SearchTopicPAth @"topic/search"

/**************用户相册 ***************/
#define UserAlbumPath @"user/album"

#define FeedCommentSpam    @"spammer/comment"

#define FeedCommentDelete   @"feed/comment"

/*************用户分享 ******************/
#define ShareCallbackPath @"feed/share_callback"

//2.1版本新增
/***************消息通知*******************/
#define UserLikesReceived       @"user/likes/received"
#define UserCommentsReceived    @"user/comments/received"
#define UserCommentsSent        @"user/comments/sent"
#define UserFeedBe_At           @"user/feeds/mentioned"
#define UserUnreadMessageCount  @"notification/message_box"
#define UserNotification        @"notification/notices"

#define UserFavourites          @"user/favourites"
#define FeedFavourite           @"feed/favourite"

//2.1.1版本新增
/*************蜜淘需求*************/
#define UserCheckUserName     @"user/check_username"
#define TopicRecommendFeed     @"topic/recommended_feed"

//2.1.2版本新增
#define UserConfig @"user/initial_data"

//2.2新增
#define GetUploadImageToken @"user/upload_image"
#define UpLoadImageToAlbc   @"api/proxy/upload"
#define CommentLike         @"feed/comment/like"

//2.2.1
#define TopicOne            @"topic/"
#define UserLikesSent       @"user/likes/sent"
//2.3新增
#define FeedsRank                @"feeds/rank" //社区热门Feed
#define TopicFeedsRank           @"topic/feeds/rank" //话题下的热门Feed
#define TopicCommunityCategories @"topic/community_categories"//话题类型
#define TopicsCategoryTopics     @"topics/category_topics"//对应类型下的话题
#define UserForbid              @"user/forbid"

#define UserMessageChats       @"user/message/chats/" //获取私信列表
#define UserMessageChartsInit  @"user/message/chats/" //初始化私信窗口
#define UserMessage            @"user/message/"   //聊天记录
#define UserMessageSend        @"user/message/"  //发出私信

//2.3
#define CommunityStatis        @"community/stats"//社区统计字段

//2.4新增
#define TopFeed                @"feed/tops" //feed置顶接口
#define TopFeedForTopic        @"feed/topic_tops" //话题下Feed的置顶接口
#define TemplateUse            @"distinguish" 


#endif
