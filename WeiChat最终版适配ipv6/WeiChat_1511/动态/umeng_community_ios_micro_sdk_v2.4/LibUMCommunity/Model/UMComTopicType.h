//
//  UMComTopicType.h
//  UMCommunity
//
//  Created by umeng on 15/11/24.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComTopic;

@interface UMComTopicType : UMComManagedObject

/**
 话题组别唯一ID
 */
@property (nonatomic, retain) NSString * category_id;
/**
 话题组的创建时间
 */
@property (nonatomic, retain) NSString * create_time;
/**
 话题组的名称
 */
@property (nonatomic, retain) NSString * name;
/**
 话题组的描述
 */
@property (nonatomic, retain) NSString * type_description;
/**
 话题组的icon_url
 */
@property (nonatomic, retain) NSString * icon_url;
/**
 话题组下的话题
 */
@property (nonatomic, retain) NSOrderedSet *topics;
@end

@interface UMComTopicType (CoreDataGeneratedAccessors)

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
