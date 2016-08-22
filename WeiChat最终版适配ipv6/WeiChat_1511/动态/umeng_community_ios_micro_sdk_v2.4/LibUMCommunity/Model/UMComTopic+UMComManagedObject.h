//
//  UMComTopic+UMComManagedObject.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/5/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComTopic.h"

void printTopic();


@interface UMComTopic (UMComManagedObject)

/**
 通过话题id获取到本地的 UMComTopic 对象，如果本地没有， 则会新建这个话题
 
 @param topicId 话题id
 
 */
+ (UMComTopic *)objectWithObjectId:(NSString *)topicId;

@end


