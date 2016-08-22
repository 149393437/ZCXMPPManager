//
//  MMEmoji.h
//  BQMM SDK
//
//  Created by ceo on 11/2/15.
//  Copyright © 2015 siyanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMEmoji : NSObject

/**
 *  表情ID
 */
@property (nonatomic, copy) NSString *emojiId;

/**
 *  表情名称
 */
@property (nonatomic, copy) NSString *emojiName;

/**
 *  表情编码
 */
@property (nonatomic, copy) NSString *emojiCode;

/**
 *  表情图片
 */
@property (nonatomic, strong) UIImage *emojiImage;

/**
 *  图片数据
 */
@property (nonatomic, strong) NSData *emojiData;

/**
 *  表情包ID
 */
@property (nonatomic, copy) NSString *packageId;

@end
