//
//  UMComMedal.h
//  UMCommunity
//
//  Created by umeng on 16/2/21.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComUser;

NS_ASSUME_NONNULL_BEGIN

@interface UMComMedal : UMComManagedObject

// Insert code here to declare functionality of your managed object subclass

/**
 通过勋章id获取到本地 UMComMedal 对象的方法，如果本地没有， 则会新建一个
 
 @param UMComMedal 勋章id
 
 */
+ (UMComMedal *)objectWithObjectId:(NSString *)medal_id;

@end

NS_ASSUME_NONNULL_END

#import "UMComMedal+CoreDataProperties.h"
