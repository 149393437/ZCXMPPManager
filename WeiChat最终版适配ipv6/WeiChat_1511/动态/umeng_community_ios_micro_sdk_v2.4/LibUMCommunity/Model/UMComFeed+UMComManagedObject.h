//
//  UMComFeed+UMComManagedObject.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/12/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComFeed.h"

void printFeed ();

typedef void(^UMComFeedOperationComplection)(id responseObject, NSError *error);

@class UMComLocationModel;
@interface UMComFeed (UMComManagedObject)

/**
 *通过用户名从feed相关用户中查找对应的用户
 
 @param name 用户名
 *return 返回一个UMComUser对象
 */
- (UMComUser *)relatedUserWithUserName:(NSString *)name;

/**
 *通过话题名称从feed中查找对应的话题
 
 @param topicName 话题名称
 *return 返回一个UMComTopic对象
 */
- (UMComTopic *)relatedTopicWithTopicName:(NSString *)topicName;


- (UMComLocationModel *)locationModel;

/**
 *判断Feed是否已被标记为删除了
 *return 如果Feed已被删除则返回YES，否则返回NO
 */
- (BOOL)isStatusDeleted;

/**
 通过feedId获取到本地 UMComFeed 对象的方法，如果本地没有， 则会新建一个
 
 @param feedId Feed的id
 
 */
+ (UMComFeed *)objectWithObjectId:(NSString *)feedId;

@end

@interface LocationDictionary : NSValueTransformer

@end