//
//  UMComNotification.h
//  UMCommunity
//
//  Created by umeng on 15/7/15.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComManagedObject.h"

@class UMComUser;

@interface UMComNotification : UMComManagedObject
/**
 通知的唯一ID
 */
@property (nonatomic, retain) NSString * id;
/**
 通知的内容
 */
@property (nonatomic, retain) NSString * content;
/**
 通知的类型
 */
@property (nonatomic, retain) NSNumber * ntype;
/**
 通知的发起时间
 */
@property (nonatomic, retain) NSString * create_time;
/**
 发通知的人
 */
@property (nonatomic, retain) UMComUser *creator;

@end
