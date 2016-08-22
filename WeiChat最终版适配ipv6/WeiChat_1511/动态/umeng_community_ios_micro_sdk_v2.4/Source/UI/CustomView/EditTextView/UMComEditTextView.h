//
//  UMComEditTextView.h
//  UMCommunity
//
//  Created by umeng on 15/11/11.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComEditTextView;

@protocol UMComEditTextViewDelegate <NSObject>

@optional;
- (NSArray *)editTextViewDidUpdate:(UMComEditTextView *)textView matchWords:(NSArray *)matchWords;

- (BOOL)editTextView:(UMComEditTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text complection:(void (^)())block;

- (void)editTextViewDidChangeSelection:(UMComEditTextView *)textView;

- (void)editTextViewDidEndEditing:(UMComEditTextView *)textView;


@end

@interface UMComEditTextView : UITextView

@property (nonatomic, weak) id<UMComEditTextViewDelegate> editDelegate;

@property (nonatomic, strong) NSArray *checkWords;

@property (nonatomic, assign) CGFloat maxTextLenght;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, copy) NSArray * (^getCheckWords)();

- (instancetype)initWithFrame:(CGRect)frame checkWords:(NSArray *)checkWords regularExStrArray:(NSArray *)regularExStrArray;

- (void)updateEditTextView;

- (NSInteger)getRealTextLength;

//判断text是否大于当前控件的最大限制
-(BOOL)checkMaxLength:(NSString*)text;


@end


@interface UMComHighLightTextUnit : UIResponder
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

+ (UMComHighLightTextUnit *)textUnitWithText:(NSString *)text
                                        font:(UIFont *)font
                                   textColor:(UIColor *)color
                                       range:(NSRange)range;

@end
