//
//  UMComLike.h
//  UMCommunity
//
//  Created by umeng on 15/7/10.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComFeed, UMComUser;

@interface UMComLike : UMComManagedObject

/**
 点赞唯一ID
 */
@property (nonatomic, retain) NSString * id;
/**
 点赞时间
 */
@property (nonatomic, retain) NSString * create_time;
/**
 点赞用户
 */
@property (nonatomic, retain) UMComUser *creator;
/**
 被点赞的Feed
 */
@property (nonatomic, retain) UMComFeed *feed;

@end
