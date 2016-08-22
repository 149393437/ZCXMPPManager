//
//  UMComUser+UMComManagedObject.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/12/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComUser.h"




void printUser();
typedef enum IconType {
    UMComIconSmallType,
    UMComIconMiddleType,
    UMComIconLargeType
} UMComIconType;

@interface UMComUser (UMComManagedObject)


- (NSString *)iconUrlStrWithType:(UMComIconType)type;

/**
 判断用户是否具有删除的权限
 
  @return 如果具备删除的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionDelete;

/**
 判断用户是否具有发公告的权限
 
  @return 如果具备发公告的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionBulletin;

/**
 判断用户是否具有某个话题下的权限
 
 @return topic
 */
- (BOOL)isUserHasTopicPermissionWithTopic:(UMComTopic *)topic;

/**
 通过用户uid获取到本地 UMComUser 对象的方法，如果本地没有， 则会新建一个
 
 @param uid 用户的uid
 
 */
+ (UMComUser *)objectWithObjectId:(NSString *)uid;

@end

@interface UMComTopicPermission : NSValueTransformer

@end


@interface Permissions : NSValueTransformer

@end