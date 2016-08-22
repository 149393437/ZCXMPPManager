//
//  UMComPrivateMessage+CoreDataProperties.h
//  UMCommunity
//
//  Created by umeng on 15/12/1.
//  Copyright © 2015年 Umeng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UMComPrivateMessage.h"
void privateMessage();

NS_ASSUME_NONNULL_BEGIN

@interface UMComPrivateMessage (CoreDataProperties)

/**
 私信聊天记录唯一ID
 */
@property (nullable, nonatomic, retain) NSString *message_id;
/**
 私信聊天内容
 */
@property (nullable, nonatomic, retain) NSString *content;
/**
 私信聊天时间
 */
@property (nullable, nonatomic, retain) NSString *create_time;
/**
 私信聊天对象（用户）
 */
@property (nullable, nonatomic, retain) UMComUser *creator;
/**
 聊天所在的私信
 */
@property (nullable, nonatomic, retain) UMComPrivateLetter *private_letter;

@end

NS_ASSUME_NONNULL_END
