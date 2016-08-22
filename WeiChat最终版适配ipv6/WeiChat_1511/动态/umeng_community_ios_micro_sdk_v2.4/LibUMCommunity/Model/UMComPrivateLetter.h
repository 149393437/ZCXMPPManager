//
//  UMComPrivateLetter.h
//  UMCommunity
//
//  Created by umeng on 15/12/1.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComPrivateMessage, UMComUser;

NS_ASSUME_NONNULL_BEGIN

@interface UMComPrivateLetter : UMComManagedObject

// Insert code here to declare functionality of your managed object subclass

/**
 通过私信id获取到本地 UMComPrivateLetter 对象的方法，如果本地没有， 则会新建一个
 
 @param letter_id 私信id
 
 */
+ (UMComPrivateLetter *)objectWithObjectId:(NSString *)letter_id;
@end

NS_ASSUME_NONNULL_END

#import "UMComPrivateLetter+CoreDataProperties.h"
