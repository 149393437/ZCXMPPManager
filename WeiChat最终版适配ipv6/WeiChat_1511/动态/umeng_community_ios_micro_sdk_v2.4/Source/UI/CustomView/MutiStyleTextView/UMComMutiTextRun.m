//
//  UMComMutiTextRun.m
//  UMCommunity
//
//  Created by umeng on 15/8/19.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComMutiTextRun.h"
#import <CoreText/CoreText.h>
#import "UMComTools.h"
#import "UMComUser.h"
#import "UMComComment.h"
#import "UMComLike.h"
#import "UMComTopic.h"
//#import "UMComSyntaxHighlightTextStorage.h"


NSString * const UMComMutiTextRunAttributedName = @"UMComMutiTextRunAttributedName";

@implementation UMComMutiTextRun

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [attributedString addAttribute:UMComMutiTextRunAttributedName value:self range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:self.textColor range:range];
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:self.font range:range];
//    self.font = [attributedString attribute:NSFontAttributeName atIndex:0 longestEffectiveRange:nil inRange:range];
}

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect
{
    
}

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)color
                       range:(NSRange)range
{
    self = [self init];
    if (self) {
        self.text = text;
        if ([font isKindOfClass:[UIFont class]]) {
            self.font = font;
        }
        if ([color isKindOfClass:[UIColor class]]) {
            self.textColor = color;
        }
        self.range = range;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor blueColor];
        self.drawSelf = NO;
    }
    return self;
}


@end


@implementation UMComMutiTextRunClickUser

- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [super decorateToAttributedString:attributedString range:range];
//    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:self.textColor range:range];
}


+ (NSArray *)runsWithAttributedString:(NSMutableAttributedString *)attributedString
                                 font:(UIFont *)font
                            textColor:(UIColor *)color
                           checkWords:(NSArray *)checkWords
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
        NSError *error = nil;
    NSString *userNameRegulaStr = UserRulerString;//@"(@[\\u4e00-\\u9fa5_a-zA-Z0-9]+)";
    NSRegularExpression *userNameRegex = [NSRegularExpression regularExpressionWithPattern:userNameRegulaStr
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [userNameRegex matchesInString:string
                                                            options:0
                                                              range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [string substringWithRange:match.range];
            
            for (NSString *userName in checkWords) {
                if ([substringForMatch isEqualToString:userName]) {
                    UMComMutiTextRunClickUser *run = [[UMComMutiTextRunClickUser alloc] initWithText:substringForMatch font:font textColor:color range:match.range];
                    [run decorateToAttributedString:attributedString range:match.range];
                    [array addObject:run];
                    break;
                }
            }
        }
    }
    return array;
}


@end



@implementation UMComMutiTextRunTopic

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
}


+ (NSArray *)runsWithAttributedString:(NSMutableAttributedString *)attributedString
                                 font:(UIFont *)font
                            textColor:(UIColor *)color
                           checkWords:(NSArray *)checkWords
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    NSString *regulaStr = TopicRulerString;//\\u4e00-\\u9fa5_a-zA-Z0-9
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [string substringWithRange:match.range];
            for (NSString *topicName in checkWords) {
                if ([substringForMatch isEqualToString:topicName]) {
                    UMComMutiTextRunTopic *run = [[UMComMutiTextRunTopic alloc] initWithText:substringForMatch font:font textColor:color range:match.range];
                    [run decorateToAttributedString:attributedString range:match.range];
                    [array addObject:run];
                    break;
                }
            }
        }
    }
    return array;
}

@end



@implementation UMComMutiTextRunURL

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    if (attributedString.length == 0) {
        return;
    }
    [super decorateToAttributedString:attributedString range:range];
//    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:self.textColor range:range];
}


+ (NSArray *)runsWithAttributedString:(NSMutableAttributedString *)attributedString
                                 font:(UIFont *)font
                            textColor:(UIColor *)color
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = nil;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\,\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\,\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [string substringWithRange:match.range];
            UMComMutiTextRunURL *run = [[UMComMutiTextRunURL alloc] initWithText:substringForMatch font:font textColor:color range:match.range];
            [run decorateToAttributedString:attributedString range:match.range];
            [array addObject:run ];
        }
    }
    return array;
}

@end




@implementation UMComMutiTextRunDelegate

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [super decorateToAttributedString:attributedString range:range];
    
    CTRunDelegateCallbacks callbacks;
    callbacks.version    = kCTRunDelegateVersion1;
    callbacks.dealloc    = UMComMutiTextRunDelegateDeallocCallback;
    callbacks.getAscent  = UMComMutiTextRunDelegateGetAscentCallback;
    callbacks.getDescent = UMComMutiTextRunDelegateGetDescentCallback;
    callbacks.getWidth   = UMComMutiTextRunDelegateGetWidthCallback;
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void*)self);
    [attributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
    CFRelease(runDelegate);
    
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor clearColor].CGColor range:range];
}

#pragma mark - RunCallback

- (void)mutiTextRunDealloc
{
    
}

- (CGFloat)mutiTextRunGetAscent
{
    return self.font.ascender;
}

- (CGFloat)mutiTextRunGetDescent
{
    return self.font.descender;
}

- (CGFloat)mutiTextRunGetWidth
{
    return self.font.ascender - self.font.descender;
}

#pragma mark - RunDelegateCallback

void UMComMutiTextRunDelegateDeallocCallback(void *refCon)
{
    //    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    //
    //    [run mutiTextRunDealloc];
}

//--上行高度
CGFloat UMComMutiTextRunDelegateGetAscentCallback(void *refCon)
{
    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    
    return [run mutiTextRunGetAscent];
}

//--下行高度
CGFloat UMComMutiTextRunDelegateGetDescentCallback(void *refCon)
{
    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    
    return [run mutiTextRunGetDescent];
}

//-- 宽
CGFloat UMComMutiTextRunDelegateGetWidthCallback(void *refCon)
{
    UMComMutiTextRunDelegate *run =(__bridge UMComMutiTextRunDelegate *) refCon;
    
    return [run mutiTextRunGetWidth];
}

@end



@implementation UMComMutiTextRunEmoji

/**
 *  返回表情数组
 */
+ (NSArray *) emojiStringArray
{
    return [NSArray arrayWithObjects:@"[smile]",@"[cry]",@"[hei]",nil];
}

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *markL       = @"[";
    NSString *markR       = @"]";
    NSString *string      = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *stack = [NSMutableArray array];
    
    for (int i = 0; i < string.length; i++)
    {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1))
            {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [emojiStr appendString:c];
                }
                
                if ([[UMComMutiTextRunEmoji emojiStringArray] containsObject:emojiStr])
                {
                    NSRange range = NSMakeRange(i + 1 - emojiStr.length, emojiStr.length);
                    
                    [attributedString replaceCharactersInRange:range withString:@" "];
                    
                    UMComMutiTextRunEmoji *run = [[UMComMutiTextRunEmoji alloc] init];
                    run.range    = NSMakeRange(i + 1 - emojiStr.length, 1);
                    run.text     = emojiStr;
                    run.drawSelf = YES;
                    [run decorateToAttributedString:attributedString range:run.range];
                    [array addObject:run];
                }
                
                [stack removeAllObjects];
            }
        }
    }
    
    return array;
}

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString *emojiString = [NSString stringWithFormat:@"%@.png",self.text];
    
    UIImage *image = UMComImageWithImageName(emojiString);
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
}

@end



