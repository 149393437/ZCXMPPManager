//
//  UMComEditTextView.m
//  UMCommunity
//
//  Created by umeng on 15/11/11.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComEditTextView.h"
#import "UMComTools.h"
#import "UMUtils.h"
#import "UMComMutiTextRun.h"

@interface UMComEditTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) NSMutableArray *regularExpressionArray;

@end

@implementation UMComEditTextView
{
    BOOL    isShowTopicNoticeBgView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame checkWords:nil regularExStrArray:nil];
    if (self) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame checkWords:(NSArray *)checkWords regularExStrArray:(NSArray *)regularExStrArray
{
    if (UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(frame.size.width, frame.size.height)];
        container.lineFragmentPadding = 2;
        container.size = CGSizeMake(self.frame.size.width, MAXFLOAT);//设置成最大得高度输入多文本滚动
        container.widthTracksTextView = YES;
        NSTextStorage *textStorage = [[NSTextStorage alloc]init];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:container];
        [textStorage addLayoutManager:layoutManager];
        self = [super initWithFrame:frame textContainer:container];
        //如果有话题则默认添加话题
    }else{
        self = [super initWithFrame:frame];
    }
    if (self) {
        _regularExpressionArray = [NSMutableArray arrayWithCapacity:regularExStrArray.count];
        for (NSString *regex in regularExStrArray) {
            NSRegularExpression *regularExpression = [NSRegularExpression
                                                      regularExpressionWithPattern:regex
                                                      options:NSRegularExpressionCaseInsensitive
                                                      error:nil];
            if (regularExpression) {
                [_regularExpressionArray addObject:regularExpression];
            }
        }
        self.textColor= [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:20];
        self.delegate = self;
        self.checkWords = checkWords;
        _noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        //_noticeLabel.backgroundColor = [UIColor clearColor];
        _noticeLabel.font = UMComFontNotoSansLightWithSafeSize(14);
        _noticeLabel.text = UMComLocalizedString(@"To Long", @"抱歉，内容过长");
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.textColor = [UIColor blueColor];
        _noticeLabel.backgroundColor = [UIColor lightGrayColor];
        _noticeLabel.hidden = YES;
        [self addSubview:_noticeLabel];
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, -5, frame.size.width, 40)];
        _placeholderLabel.font = UMComFontNotoSansLightWithSafeSize(15);
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor grayColor];
        [self addSubview:_placeholderLabel];
        
        _maxTextLenght = 1000;
    }
    return self;
}

- (void)updateEditTextView
{
    [self textViewDidChange:self];
    [self matchWordsWithTextColor:[UMComTools colorWithHexString:FontColorBlue]];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self showPlaceHolderLabelWithTextView:textView];
    if (self.editDelegate && [self.editDelegate respondsToSelector:@selector(editTextViewDidChangeSelection:)]) {
        [self.editDelegate editTextViewDidChangeSelection:self];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

- (void)showPlaceHolderLabelWithTextView:(UITextView *)textView
{
    if (textView.text.length > 0 && ![@" " isEqualToString:textView.text]) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
    if (UMSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6")) {
        [self matchWordsWithTextColor:[UMComTools colorWithHexString:FontColorBlue]];
    }
    if (self.editDelegate && [self.editDelegate respondsToSelector:@selector(editTextViewDidEndEditing:)]) {
        [self.editDelegate editTextViewDidEndEditing:self];
    }
}

- (void)hiddenTextView
{
    self.noticeLabel.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //判断text的长度大于零，避免删除的情况不能编辑
    //if ([self getRealTextLength] > self.maxTextLenght && text.length > 0) {
    if (self.maxTextLenght <= 0) {
        return NO;
    }

    NSInteger markLength = 0;//标记的长度
    UITextRange* curMarkText = textView.markedTextRange;
    if (curMarkText) {
        markLength = [self offsetFromPosition:curMarkText.start toPosition:curMarkText.end];
    }
    
    NSInteger curLength = 0.f;
    NSInteger nextLength = 0.f;
    curLength = [UMComTools getStringLengthWithString:self.text];//当前长度(用于判断表情)
    nextLength = [UMComTools getStringLengthWithString:text];//即将要输入的长度(用于判断表情)
    curLength -= markLength;
    if (curLength +  nextLength > self.maxTextLenght ) {
        self.noticeLabel.hidden = NO;
        //显示noticeLabel的位置
        self.noticeLabel.frame = CGRectMake(self.contentOffset.x,self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
        [self performSelector:@selector(hiddenTextView) withObject:nil afterDelay:0.8f];
        return NO;
    }else{
        self.noticeLabel.hidden = YES;
    }
    if (self.editDelegate && [self.editDelegate respondsToSelector:@selector(editTextView:shouldChangeTextInRange:replacementText:complection:)]) {
        __weak typeof(self) weakSelf = self;
        return [self.editDelegate editTextView:self shouldChangeTextInRange:range replacementText:text complection:^{
            [weakSelf textViewDidChange:weakSelf];

        }];
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        [self matchWordsWithTextColor:[UMComTools colorWithHexString:FontColorBlue]];
    }
    [self showPlaceHolderLabelWithTextView:textView];
    
}


#pragma mark - textUpdata

- (void)matchWordsWithTextColor:(UIColor *)color
{
    if (self.text.length == 0) {
        return;
    }
    if (self.getCheckWords) {
        self.checkWords = self.getCheckWords();
    }
    __weak typeof(self) weakSelf = self;
    if (UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        [self updateiOS7AndLaterTextWithColor:color checkWords:self.checkWords completion:^(NSArray *matchWords) {
            if (weakSelf.editDelegate && [weakSelf.editDelegate respondsToSelector:@selector(editTextViewDidUpdate:matchWords:)]) {
                weakSelf.checkWords = [weakSelf.editDelegate editTextViewDidUpdate:weakSelf matchWords:[matchWords valueForKeyPath:@"text"]];
            }
        }];
    }else{
        [self creatHighLightWithFont:self.font color:color checkWords:self.checkWords complection:^(NSArray * matchWords, NSMutableAttributedString *attributedString) {
            if (self.editDelegate && [self.editDelegate respondsToSelector:@selector(editTextViewDidUpdate:matchWords:)]) {
                [self.editDelegate editTextViewDidUpdate:weakSelf matchWords:[matchWords valueForKeyPath:@"text"]];
            }
            weakSelf.attributedText = attributedString;
        }];
    }
    [self reloadInputViews];
}


- (void)updateiOS7AndLaterTextWithColor:(UIColor *)color
                             checkWords:(NSArray *)checkWords
                             completion:(void (^) (NSArray *matchWords))block
{
    [self.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, self.textStorage.length)];
    NSMutableArray *HLTextUnits = [NSMutableArray array];
    for (NSRegularExpression *reqular in _regularExpressionArray) {
        NSArray *matchs = [reqular matchesInString:self.textStorage.string
                                                      options:0
                                                        range:NSMakeRange(0, [self.textStorage.string length])];
        
        if ([reqular.pattern isEqualToString:UrlRelerSring]) {
            for (NSTextCheckingResult *match in matchs)
            {
                NSString* matchText = [self.textStorage.string substringWithRange:match.range];
                [self.textStorage addAttribute:NSForegroundColorAttributeName value:color range:match.range];
                if (![[HLTextUnits valueForKeyPath:@"text"] containsObject:matchText]) {
                    UMComHighLightTextUnit *textUnit = [UMComHighLightTextUnit textUnitWithText:matchText font:self.font textColor:color range:match.range];
                    [HLTextUnits addObject:textUnit];
                }
            }
        }else{
        
            for (NSTextCheckingResult *match in matchs)
            {
                NSString* matchText = [self.textStorage.string substringWithRange:match.range];
                
                for (NSString *checkWord in checkWords) {
                    if ([matchText isEqualToString:checkWord]) {
                        [self.textStorage addAttribute:NSForegroundColorAttributeName value:color range:match.range];
                        if (![[HLTextUnits valueForKeyPath:@"text"] containsObject:matchText]) {
                            UMComHighLightTextUnit *textUnit = [UMComHighLightTextUnit textUnitWithText:matchText font:self.font textColor:color range:match.range];
                            [HLTextUnits addObject:textUnit];
                        }
                    }
                }
            }
            
        }

    }
    if (block) {
        block(HLTextUnits);
    }
}



//产生高亮字体
- (void)creatHighLightWithFont:(UIFont *)font color:(UIColor *)color checkWords:(NSArray *)checkWords complection:(void(^)(NSArray *checkWords ,NSMutableAttributedString *attributedString))block
{
    if (self.text.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    self.attributedText = attributedString;
    [attributedString addAttribute:NSForegroundColorAttributeName value:(id)[UIColor blackColor] range:NSMakeRange(0, attributedString.length-1)];

    NSString *string = attributedString.string;
    NSMutableArray *HLTextUnits = [NSMutableArray array];
    for (NSRegularExpression *regularExpression in _regularExpressionArray) {
        NSArray *matchs = [regularExpression matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        if ([regularExpression.pattern isEqualToString:UrlRelerSring]) {
            for (NSTextCheckingResult *match in matchs)
            {
                NSString* matchText = [self.textStorage.string substringWithRange:match.range];
                [attributedString addAttribute:(id)NSForegroundColorAttributeName value:(id)color range:match.range];
                if (![[HLTextUnits valueForKeyPath:@"text"] containsObject:matchText]) {
                    UMComHighLightTextUnit *textUnit = [UMComHighLightTextUnit textUnitWithText:matchText font:self.font textColor:color range:match.range];
                    [HLTextUnits addObject:textUnit];
                }
            }
        }else{
            for (NSTextCheckingResult *match in matchs)
            {
                NSRange matchRange = NSMakeRange(match.range.location, match.range.length);
                NSString *matchText = [string substringWithRange:matchRange];
                
                for (NSString *checkWord in checkWords) {
                    if ([matchText isEqualToString:checkWord]) {
                        [attributedString addAttribute:(id)NSForegroundColorAttributeName value:(id)color range:match.range];
                        if (![[HLTextUnits valueForKeyPath:@"text"] containsObject:matchText]) {
                            UMComHighLightTextUnit *textUnit = [UMComHighLightTextUnit textUnitWithText:matchText font:self.font textColor:color range:match.range];
                            [HLTextUnits addObject:textUnit];
                            
                        }
                    }
                }
            }
        }
    }
    [attributedString addAttribute:NSFontAttributeName value:(id)font range:NSMakeRange(0, attributedString.length)];
    if (block) {
        block(HLTextUnits, attributedString);
    }
}


- (NSInteger)getRealTextLength
{
    NSInteger topicAndUserLength = 0;
    NSMutableArray *matchs = [NSMutableArray array];
    for (NSRegularExpression *regularExpression in _regularExpressionArray) {
        NSArray *subMatchs = [regularExpression matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
        if (subMatchs.count > 0) {
            [matchs addObjectsFromArray:subMatchs];
        }
    }
    NSArray *checkWords = self.checkWords;
    for (NSTextCheckingResult *match in matchs)
    {
        for (NSString *item in checkWords) {
            NSRange matchRange = NSMakeRange(match.range.location, match.range.length);
            NSString *matchText = [self.text substringWithRange:matchRange];
            if ([item isEqualToString:matchText]) {
                topicAndUserLength += [UMComTools getStringLengthWithString:matchText];
            }
        }
    }
    NSString *realTextString = [self.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger realTextLength = [UMComTools getStringLengthWithString:realTextString] - topicAndUserLength;
    return realTextLength;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)checkMaxLength:(NSString*)text
{
    if (!text) {
        return NO;
    }
    NSInteger curLength = [UMComTools getStringLengthWithString:text];
    if (curLength> self.maxTextLenght ) {
        self.noticeLabel.hidden = NO;
        //显示noticeLabel的位置
        self.noticeLabel.frame = CGRectMake(self.contentOffset.x,self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
        [self performSelector:@selector(hiddenTextView) withObject:nil afterDelay:0.8f];
        return YES;
    }
    else{
        return NO;
    }
}

@end


@implementation UMComHighLightTextUnit

- (instancetype)initWithTextUnitWithText:(NSString *)text
                                    font:(UIFont *)font
                               textColor:(UIColor *)color
                                   range:(NSRange)range
{
    self = [super init];
    if (self) {
        self.text = text;
        self.textColor = color;
        self.font = font;
        self.range = range;
    }
    return self;
}

+ (UMComHighLightTextUnit *)textUnitWithText:(NSString *)text
                                        font:(UIFont *)font
                                   textColor:(UIColor *)color
                                       range:(NSRange)range
{
    UMComHighLightTextUnit *textUnit = [[UMComHighLightTextUnit alloc]initWithTextUnitWithText:text font:font textColor:color range:range];
    return textUnit;
}

@end
