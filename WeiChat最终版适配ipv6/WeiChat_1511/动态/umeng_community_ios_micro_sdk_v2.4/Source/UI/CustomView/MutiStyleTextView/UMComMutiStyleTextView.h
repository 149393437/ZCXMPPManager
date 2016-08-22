//
//  UMComMutiStyleTextView.h
//  UMCommunity
//
//  Created by umeng on 15-3-5.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "UMComMutiTextRun.h"



@class UMComMutiTextRunDelegate,UMComMutiTextRun,UMComMutiStyleTextView;

@class UMComMutiText;
@interface UMComMutiStyleTextView : UIView

@property (nonatomic, strong) NSMutableArray *checkWords;

@property (nonatomic, copy) void (^clickOnlinkText)(UMComMutiStyleTextView *mutiStyleTextView,UMComMutiTextRun *run);

@property (nonatomic,copy)   NSString              *text;       // default is nil
@property (nonatomic,copy)   NSMutableAttributedString *attributedText;
@property (nonatomic,strong) UIFont                *font;       // default is nil (system font 17 plain)
@property (nonatomic,strong) UIColor               *textColor;  // default is nil (text draws black)
@property (nonatomic,assign) CGFloat               lineSpace;
@property (nonatomic,assign) CGPoint               pointOffset;

@property (nonatomic) id framesetterRef;


@property (nonatomic,strong) NSArray *runs;
@property (nonatomic,strong) NSMutableDictionary *runRectDictionary;
@property (nonatomic,strong) UMComMutiTextRun *touchRun;

- (void)setMutiStyleTextViewWithMutiText:(UMComMutiText *)mutiText;


//+ (UMComMutiStyleTextView *)rectDictionaryWithSize:(CGSize)size
//                                              font:(UIFont *)font
//                                         attString:(NSString *)string
//                                         lineSpace:(CGFloat )lineSpace
//                                           runType:(UMComMutiTextRunTypeList)runType
//                                        checkWords:(NSMutableArray *)checkWords;


@end


@interface UMComMutiText : NSObject

@property (nonatomic,copy)   NSString              *text;       // default is nil
@property (nonatomic,strong) UIFont                *font;       // default is nil (system font 17 plain)
@property (nonatomic,strong) UIColor               *textColor;  // default is nil (text draws black)
@property (nonatomic,strong) UIColor               *textHighLightColor;

@property (nonatomic,assign) CGFloat               lineSpace;
@property (nonatomic,assign) CGSize                textSize;
@property (nonatomic,assign) CGPoint               pointOffset;
@property (nonatomic,assign) NSLineBreakMode       lineBreakMode;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy)   NSMutableAttributedString *attributedText;

@property (nonatomic) id framesetterRef;

@property (nonatomic,strong) NSArray<UMComMutiTextRun *> *runs;

- (instancetype)initWithString:(NSString *)string;

- (instancetype)initWithAttributedString:(NSMutableAttributedString *)attributedString;
- (void)setTextColor:(UIColor *)color forRange:(NSRange)range;

- (void)setTextFont:(UIFont *)font forRange:(NSRange)range;


+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords;

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor;

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor
                     highLightColor:(UIColor *)highLightColor;

@end



