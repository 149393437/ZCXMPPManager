//
//  UMComMutiTextRun.h
//  UMCommunity
//
//  Created by umeng on 15/8/19.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, UMComMutiTextRunTypeList)
{
    UMComMutiTextRunNoneType  = 0,
    UMComMutiTextRunLikeType = 1,
    UMComMutiTextRunCommentType = 2,
    UMComMutiTextRunFeedContentType = 3,
};

extern NSString * const UMComMutiTextRunAttributedName;



//文字单元CTRun

@interface UMComMutiTextRun : UIResponder

/**
 *  文本单元内容
 */
@property (nonatomic,copy  ) NSString *text;

/**
 *  文本单元字体
 */
@property (nonatomic,strong) UIFont   *font;

/**
 *  文本单元颜色
 */
@property (nonatomic,strong) UIColor   *textColor;

/**
 *  文本单元在字符串中的位置
 */
@property (nonatomic,assign) NSRange  range;

/**
 *  是否自己绘制自己
 */
@property(nonatomic,getter = isDrawSelf) BOOL drawSelf;

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range;

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect;

/**
 *  初始化方法
 */
- (id)initWithText:(NSString *)text
              font:(UIFont *)font
         textColor:(UIColor *)color
             range:(NSRange)range;

@end


@interface UMComMutiTextRunClickUser : UMComMutiTextRun

/**
 *  解析字符串中的“@userName ”格式内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @param font 字体
 *
 *  @param color 颜色
 *
 *  @param checkWords 需要匹配的文字数组的文字
 *
 *  @return UMComMutiTextRunClickUser对象数组
 */
+ (NSArray *)runsWithAttributedString:(NSMutableAttributedString *)attributedString
                                 font:(UIFont *)font
                            textColor:(UIColor *)color
                           checkWords:(NSArray *)checkWords;

@end


@interface UMComMutiTextRunTopic : UMComMutiTextRun

/**
 *  解析字符串中的“#话题#”格式内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @param font 字体
 *
 *  @param color 颜色
 *
 *  @param checkWords 需要匹配的文字数组的文字
 *
 *  @return UMComMutiTextRunTopic对象数组
 */
+ (NSArray *)runsWithAttributedString:(NSMutableAttributedString *)attributedString
                                 font:(UIFont *)font
                            textColor:(UIColor *)color
                           checkWords:(NSArray *)checkWords;

@end



@interface UMComMutiTextRunURL : UMComMutiTextRun

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @param font 字体
 *
 *  @param color 颜色
 *
 *  @return UMComMutiTextRunURL对象数组
 */
+ (NSArray *)runsWithAttributedString:(NSMutableAttributedString *)attributedString
                                 font:(UIFont *)font
                            textColor:(UIColor *)color;

@end


@interface UMComMutiTextRunDelegate : UMComMutiTextRun

@end


@interface UMComMutiTextRunEmoji : UMComMutiTextRunDelegate

+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;

@end

