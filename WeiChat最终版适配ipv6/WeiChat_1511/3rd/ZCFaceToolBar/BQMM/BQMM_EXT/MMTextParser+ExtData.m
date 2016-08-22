//
//  MMTextParser+ExtData.m
//  ChatDemo-UI2.0
//
//  Created by LiChao Jun on 16/1/23.
//  Copyright © 2016年 LiChao Jun. All rights reserved.
//

#import "MMTextParser+ExtData.h"

static MMEmoji *s_placeholderEmoji = nil;

@implementation MMTextParser (ExtData)

+ (NSArray*)extDataWithTextImageArray:(NSArray*)textImageArray
{
    NSMutableArray *ret = [NSMutableArray array];
    
    for (id obj in textImageArray) {
        if ([obj isKindOfClass:[MMEmoji class]]) {
            MMEmoji *emoji = (MMEmoji*)obj;
            [ret addObject:@[emoji.emojiCode, @"1"]];
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            [ret addObject:@[obj, @"0"]];
        }
        else {
            assert(0);
        }
    }
    
    return ret;
}

+ (NSArray*)extDataWithEmojiCode:(NSString*)emojiCode
{
    return @[@[emojiCode, @"1"]];
}

+ (MMEmoji*)placeholderEmoji
{
    if (!s_placeholderEmoji) {
        s_placeholderEmoji = [[MMEmoji alloc] init];
        s_placeholderEmoji.emojiImage = [UIImage imageNamed:@"emoji_placeholder.png"];
    }
    return s_placeholderEmoji;
}

+ (NSString*)stringWithExtData:(NSArray*)extData
{
    NSString *ret = @"";
    for (NSArray *obj in extData) {
        NSString *str = obj[0];
        BOOL isEmojiCode = [obj[1] boolValue];
        if (isEmojiCode) {
            ret = [ret stringByAppendingString:[NSString stringWithFormat:@"[%@]", str]];
        }
        else {
            ret = [ret stringByAppendingString:str];
        }
    }
    return ret;
}

+ (CGSize)sizeForMMTextWithExtData:(NSArray*)extData
                              font:(UIFont *)font
                  maximumTextWidth:(CGFloat)maximumTextWidth
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    for (NSArray *obj in extData) {
        NSString *str = obj[0];
        BOOL isEmojiCode = [obj[1] boolValue];
        if (isEmojiCode) {
            NSTextAttachment *placeholderAttachment = [[NSTextAttachment alloc] init];
            placeholderAttachment.bounds = CGRectMake(0, 0, 20, 20);//固定20X20
            [attrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:placeholderAttachment]];
        }
        else {
            [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
        }
    }    //字体
    if (font) {
        [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrStr.length)];
    }
    // 计算文本的大小
    CGSize sizeToFit = [attrStr boundingRectWithSize:CGSizeMake(maximumTextWidth, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                             context:nil].size;
    
    return CGRectIntegral(CGRectMake(0, 0, sizeToFit.width + 10, sizeToFit.height + 16)).size;
}

@end
