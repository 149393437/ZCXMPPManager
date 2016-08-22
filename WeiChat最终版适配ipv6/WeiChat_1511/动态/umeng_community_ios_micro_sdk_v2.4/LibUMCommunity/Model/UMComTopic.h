//
//  UMComTopic.h
//  UMCommunity
//
//  Created by umeng on 15/11/24.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComFeed, UMComTopicType, UMComUser, UMComImageUrl;
/**
 *  @brief 用户话题类继承NSManagedObject
 *  
 *  可以直接通过属性或者用koc来访问属性
 */
@interface UMComTopic : UMComManagedObject
/** 自定义字段 */
@property (nonatomic, retain) NSString * custom;
/** 话题的描述 */
@property (nonatomic, retain) NSString * descriptor;
/** 关注话题的人数 */
@property (nonatomic, retain) NSNumber * fan_count;
/** 话题feed的个数 */
@property (nonatomic, retain) NSNumber * feed_count;
/** 话题url */
@property (nonatomic, retain) NSString * icon_url;
/** 话题是否关注状态(针对当前登陆用户，如果未登录默认为0) */
@property (nonatomic, retain) NSNumber * is_focused;
/** 话题是否推荐状态(无论是否登陆,都可以在推荐话题里面显示此话题) */
@property (nonatomic, retain) NSNumber * is_recommend;
/** 话题的名称 */
@property (nonatomic, retain) NSString * name;
/** 话题的创建时间 */
@property (nonatomic, retain) NSDate * save_time;
/** 暂时无用 */
@property (nonatomic, retain) NSNumber * seq;
/** 暂时无用 */
@property (nonatomic, retain) NSNumber * seq_recommend;
/** 话题唯一ID */
@property (nonatomic, retain) NSString * topicID;
/** 保存的是UMComImageUrl对象(扩展字段，给开发者使用) */
@property (nonatomic, retain) NSOrderedSet *image_urls;
/** 话题类型 */
@property (nonatomic, retain) UMComTopicType *category;
/** 话题下面的feed */
@property (nonatomic, retain) NSOrderedSet *feeds;
/** 话题的关注者 */
@property (nonatomic, retain) NSOrderedSet *follow_users;

@end

@interface UMComTopic (CoreDataGeneratedAccessors)

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
- (void)insertObject:(UMComUser *)value inFollow_usersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFollow_usersAtIndex:(NSUInteger)idx;
- (void)insertFollow_users:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFollow_usersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFollow_usersAtIndex:(NSUInteger)idx withObject:(UMComUser *)value;
- (void)replaceFollow_usersAtIndexes:(NSIndexSet *)indexes withFollow_users:(NSArray *)values;
- (void)addFollow_usersObject:(UMComUser *)value;
- (void)removeFollow_usersObject:(UMComUser *)value;
- (void)addFollow_users:(NSOrderedSet *)values;
- (void)removeFollow_users:(NSOrderedSet *)values;
@end
