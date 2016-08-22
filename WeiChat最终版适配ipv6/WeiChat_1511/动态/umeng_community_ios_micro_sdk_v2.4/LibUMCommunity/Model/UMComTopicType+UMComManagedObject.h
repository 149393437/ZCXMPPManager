//
//  UMComTopicType+UMComManagedObject.h
//  UMCommunity
//
//  Created by umeng on 15/11/24.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComTopicType.h"

void printTopicType();

@interface UMComTopicType (UMComManagedObject)

/**
 通过话题分类id获取到本地 UMComTopicType 对象的方法，如果本地没有， 则会新建一个
 
 @param category_id 话题组的id
 
 */
+ (UMComTopicType *)objectWithObjectId:(NSString *)category_id;
@end
