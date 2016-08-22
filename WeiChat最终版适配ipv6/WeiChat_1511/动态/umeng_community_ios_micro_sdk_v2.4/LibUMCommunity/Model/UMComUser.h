//
//  UMComUser.h
//  UMCommunity
//
//  Created by umeng on 15/11/20.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComAlbum, UMComComment, UMComFeed, UMComLike, UMComTopic, UMComUser,UMComPrivateLetter,UMComPrivateMessage,UMComImageUrl,UMComMedal;

@interface UMComUser : UMComManagedObject
/**年龄*/
@property (nonatomic, retain) NSNumber * age;
/**0表示普通用户；1表示全局管理员；2暂时没用；3创建社区时的默认管理员；4.话题管理员。*/
@property (nonatomic, retain) NSNumber * atype;
/**被@个数*/
@property (nonatomic, retain) NSNumber * be_at_count;
/**评论个数*/
@property (nonatomic, retain) NSNumber * comment_count;
/**自定义字段，扩展字段*/
@property (nonatomic, retain) NSString * custom;
/**粉丝数*/
@property (nonatomic, retain) NSNumber * fans_count;
/**创建Feed的个数*/
@property (nonatomic, retain) NSNumber * feed_count;
/**关注的人的个数*/
@property (nonatomic, retain) NSNumber * following_count;
/**性别*/
@property (nonatomic, retain) NSNumber * gender;
/**是否已经被我关注*/
@property (nonatomic, retain) NSNumber * has_followed;
/**对方是否已经关注我*/
@property (nonatomic, retain) NSNumber * be_followed;
/**是否是推荐的用户*/
@property (nonatomic, retain) NSNumber * is_recommended;//是否推荐
/**等级*/
@property (nonatomic, retain) NSNumber * level;
/**等级title*/
@property (nonatomic, retain) NSString * level_title;
/**点赞个数*/
@property (nonatomic, retain) NSNumber * like_count;
/**被点赞个数*/
@property (nonatomic, retain) NSNumber * liked_count;
/**用户名*/
@property (nonatomic, retain) NSString * name;
/**权限字段 (结构是数据，如果有管理权限的话保存的是字符串是@"permission_delete_content",@"permission_bulletin") permission_delete_content删除权限，permission_bulletin发公告权限*/
@property (nonatomic, retain) id permissions;
/**话题下权限字段 NSDictionary类型*/
@property (nonatomic, retain) id topic_permission;
/**是否第一次登录*/
@property (nonatomic, retain) NSNumber * registered;
/**开发者自己账号积分系统的积分*/
@property (nonatomic, retain) NSNumber * score;
/**用户状态*/
@property (nonatomic, retain) NSNumber * status;
/***/
@property (nonatomic, retain) NSNumber * sum;
/***/
@property (nonatomic, retain) NSString * token;
/**用户在友盟微社区的uid，可以作为用户在社区里的唯一标识*/
@property (nonatomic, retain) NSString * uid;
/**用户的注册账号平台名称*/
@property (nonatomic, retain) NSString * source;
/**开发者自己账号系统的用户id*/
@property (nonatomic, retain) NSString * source_uid;
/**关注的话题数*/
@property (nonatomic, retain) NSNumber * topic_focused_count;
/**友盟微社区积分系统下的积分*/
@property (nonatomic, retain) NSNumber * point;
/**用户头像icon_url数据模型*/
@property (nonatomic, retain) UMComImageUrl *icon_url;
/**相册*/
@property (nonatomic, retain) UMComAlbum *album;
/**评论列表*/
@property (nonatomic, retain) NSOrderedSet *comment;
/**粉丝列表*/
@property (nonatomic, retain) NSOrderedSet *fans;
/**创建的Feed列表*/
@property (nonatomic, retain) NSOrderedSet *feeds;
/**关注的用户列表*/
@property (nonatomic, retain) NSOrderedSet *followers;
/**点赞列表*/
@property (nonatomic, retain) NSOrderedSet *likes;
/**相关的Feed列表*/
@property (nonatomic, retain) NSOrderedSet *related_feeds;
/**回复的评论列表*/
@property (nonatomic, retain) NSOrderedSet *reply_comments;
/**关注的话题列表*/
@property (nonatomic, retain) NSOrderedSet *topics;
/**私信列表*/
@property (nonatomic, retain) NSOrderedSet *private_letters;
/**私信消息列表*/
@property (nonatomic, retain) NSOrderedSet *private_messages;
/**勋章列表*/
@property (nonatomic, retain) NSOrderedSet *medal_list;
@end

@interface UMComUser (CoreDataGeneratedAccessors)

- (void)insertObject:(UMComComment *)value inCommentAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommentAtIndex:(NSUInteger)idx;
- (void)insertComment:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommentAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommentAtIndex:(NSUInteger)idx withObject:(UMComComment *)value;
- (void)replaceCommentAtIndexes:(NSIndexSet *)indexes withComment:(NSArray *)values;
- (void)addCommentObject:(UMComComment *)value;
- (void)removeCommentObject:(UMComComment *)value;
- (void)addComment:(NSOrderedSet *)values;
- (void)removeComment:(NSOrderedSet *)values;
- (void)insertObject:(UMComUser *)value inFansAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFansAtIndex:(NSUInteger)idx;
- (void)insertFans:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFansAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFansAtIndex:(NSUInteger)idx withObject:(UMComUser *)value;
- (void)replaceFansAtIndexes:(NSIndexSet *)indexes withFans:(NSArray *)values;
- (void)addFansObject:(UMComUser *)value;
- (void)removeFansObject:(UMComUser *)value;
- (void)addFans:(NSOrderedSet *)values;
- (void)removeFans:(NSOrderedSet *)values;
- (void)insertObject:(UMComFeed *)value inFeedsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFeedsAtIndex:(NSUInteger)idx;
- (void)insertFeeds:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFeedsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFeedsAtIndex:(NSUInteger)idx withObject:(UMComFeed *)value;
- (void)replaceFeedsAtIndexes:(NSIndexSet *)indexes withFeeds:(NSArray *)values;
- (void)addFeedsObject:(UMComFeed *)value;
- (void)removeFeedsObject:(UMComFeed *)value;
- (void)addFeeds:(NSOrderedSet *)values;
- (void)removeFeeds:(NSOrderedSet *)values;
- (void)insertObject:(UMComUser *)value inFollowersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFollowersAtIndex:(NSUInteger)idx;
- (void)insertFollowers:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFollowersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFollowersAtIndex:(NSUInteger)idx withObject:(UMComUser *)value;
- (void)replaceFollowersAtIndexes:(NSIndexSet *)indexes withFollowers:(NSArray *)values;
- (void)addFollowersObject:(UMComUser *)value;
- (void)removeFollowersObject:(UMComUser *)value;
- (void)addFollowers:(NSOrderedSet *)values;
- (void)removeFollowers:(NSOrderedSet *)values;
- (void)insertObject:(UMComLike *)value inLikesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLikesAtIndex:(NSUInteger)idx;
- (void)insertLikes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLikesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLikesAtIndex:(NSUInteger)idx withObject:(UMComLike *)value;
- (void)replaceLikesAtIndexes:(NSIndexSet *)indexes withLikes:(NSArray *)values;
- (void)addLikesObject:(UMComLike *)value;
- (void)removeLikesObject:(UMComLike *)value;
- (void)addLikes:(NSOrderedSet *)values;
- (void)removeLikes:(NSOrderedSet *)values;
- (void)insertObject:(UMComFeed *)value inRelated_feedsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelated_feedsAtIndex:(NSUInteger)idx;
- (void)insertRelated_feeds:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelated_feedsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelated_feedsAtIndex:(NSUInteger)idx withObject:(UMComFeed *)value;
- (void)replaceRelated_feedsAtIndexes:(NSIndexSet *)indexes withRelated_feeds:(NSArray *)values;
- (void)addRelated_feedsObject:(UMComFeed *)value;
- (void)removeRelated_feedsObject:(UMComFeed *)value;
- (void)addRelated_feeds:(NSOrderedSet *)values;
- (void)removeRelated_feeds:(NSOrderedSet *)values;
- (void)insertObject:(UMComComment *)value inReply_commentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromReply_commentsAtIndex:(NSUInteger)idx;
- (void)insertReply_comments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeReply_commentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInReply_commentsAtIndex:(NSUInteger)idx withObject:(UMComComment *)value;
- (void)replaceReply_commentsAtIndexes:(NSIndexSet *)indexes withReply_comments:(NSArray *)values;
- (void)addReply_commentsObject:(UMComComment *)value;
- (void)removeReply_commentsObject:(UMComComment *)value;
- (void)addReply_comments:(NSOrderedSet *)values;
- (void)removeReply_comments:(NSOrderedSet *)values;
- (void)insertObject:(UMComTopic *)value inTopicsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTopicsAtIndex:(NSUInteger)idx;
- (void)insertTopics:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTopicsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTopicsAtIndex:(NSUInteger)idx withObject:(UMComTopic *)value;
- (void)replaceTopicsAtIndexes:(NSIndexSet *)indexes withTopics:(NSArray *)values;
- (void)addTopicsObject:(UMComTopic *)value;
- (void)removeTopicsObject:(UMComTopic *)value;
- (void)addTopics:(NSOrderedSet *)values;
- (void)removeTopics:(NSOrderedSet *)values;
@end
