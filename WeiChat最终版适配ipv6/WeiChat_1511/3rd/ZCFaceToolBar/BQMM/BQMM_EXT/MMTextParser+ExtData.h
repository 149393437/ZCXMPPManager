//
//  MMTextParser+ExtData.h
//  ChatDemo-UI2.0
//
//  Created by LiChao Jun on 16/1/23.
//  Copyright © 2016 LiChao Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BQMM/BQMM.h>

@interface MMTextParser (ExtData)

/**
 *  将textImageArray转换成extData
 *
 *  @param textImageArray MMEmoji和text的集合
 *
 *  @return 返回extData的二维数组 如 @[@[@"emojiCode", @1], @[@"text", @0]]
 */
+ (NSArray*)extDataWithTextImageArray:(NSArray*)textImageArray;

/**
 *  将单个emojiCode转换成extData
 *
 *  @param emojiCode 表情编码
 *
 *  @return 返回extData的二维数组 @[@[emojiCode, @"1"]];
 */
+ (NSArray*)extDataWithEmojiCode:(NSString*)emojiCode;

/**
 *  提供占位图的小表情
 *
 *  @return 表情对象
 */
+ (MMEmoji*)placeholderEmoji;

/**
 *   将单个extData转换成text
 *
 *  @param extData extData二维数组
 *
 *  @return mmtext
 */
+ (NSString*)stringWithExtData:(NSArray*)extData;

/**
 *  计算展示图文混排所需size
 *
 *  @param extData          二维数组 如 @[@[@"emojiCode", @1], @[@"text", @0]]
 *  @param font             字体
 *  @param maximumTextWidth 最大显示宽度
 *
 *  @return 展示所需的size
 */
+ (CGSize)sizeForMMTextWithExtData:(NSArray*)extData
                              font:(UIFont *)font
                  maximumTextWidth:(CGFloat)maximumTextWidth;

@end
