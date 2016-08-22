//
//  UMComMutiStyleTextView.m
//  UMCommunity
//
//  Created by umeng on 15-3-5.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComMutiStyleTextView.h"
#import "UMComTools.h"


CTFontRef CTFontCreateFromUIFont(UIFont *font)
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    return ctFont;
}


@interface UMComMutiStyleTextView ()


@end

@implementation UMComMutiStyleTextView

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (void)dealloc
{
    if (_framesetterRef) {
        CFRelease((__bridge_retained  CTFramesetterRef)(_framesetterRef));
        _framesetterRef = NULL;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefault];
    }
    return self;
}

- (void)setMutiStyleTextViewWithMutiText:(UMComMutiText *)mutiText
{
    self.attributedText = mutiText.attributedText;
    self.framesetterRef = mutiText.framesetterRef;
    self.runs = mutiText.runs;
    self.font = mutiText.font;
    self.lineSpace = mutiText.lineSpace;
    self.textColor = mutiText.textColor;
    [self setText:mutiText.text];
}

#pragma mark - CreateDefault

- (void)createDefault
{
    //public
    _text        = nil;
    _font        = [UIFont systemFontOfSize:13.0f];
    _textColor   = [UIColor blackColor];
    _lineSpace   = 2.0f;
//    self.heightOffset = 0.0f;
    _attributedText = nil;
    _pointOffset = CGPointZero;
    //private
    _runs        = [NSMutableArray array];
    _runRectDictionary = [NSMutableDictionary dictionary];
    _touchRun = nil;
    _checkWords = [NSMutableArray arrayWithCapacity:1];
    _framesetterRef = NULL;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInCerrentView:)];
    [self addGestureRecognizer:tap];
}



#pragma mark - Set
- (void)setText:(NSString *)text
{
    [self setNeedsDisplay];

    _text = text;
}


- (void)awakeFromNib
{
    [self createDefault];

}

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{
    //绘图上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (self.attributedText == nil || self.attributedText.length == 0 ){
        return;
    }

    CGRect viewRect = CGRectMake(self.pointOffset.x, -self.pointOffset.y, rect.size.width, rect.size.height);//
    //修正坐标系
    CGAffineTransform affineTransform = CGAffineTransformIdentity;
    affineTransform = CGAffineTransformMakeTranslation(0.0, viewRect.size.height);
    affineTransform = CGAffineTransformScale(affineTransform, 1.0, -1.0);
    CGContextConcatCTM(contextRef, affineTransform);
    
    //创建一个用来描画文字的路径，其区域为viewRect  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, viewRect);

    CTFramesetterRef frameSetter = CFRetain((__bridge CTFramesetterRef)(self.framesetterRef));
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), pathRef, nil);
    //通过context在frame中描画文字内容
    CTFrameDraw(frameRef, contextRef);
    [self.runRectDictionary removeAllObjects];
    [self setRunsKeysToRunRectWithFrameRef:frameRef];
    CGPathRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(frameSetter);
}

- (void)setRunsKeysToRunRectWithFrameRef:(CTFrameRef)frameRef
{
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++)
    {
        CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CGPoint lineOrigin = CGPointMake(lineOrigins[i].x, lineOrigins[i].y);//
        CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
        CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
        
        for (int j = 0; j < CFArrayGetCount(runs); j++)
        {
            CTRunRef runRef = CFArrayGetValueAtIndex(runs, j);
            CGFloat runAscent;
            CGFloat runDescent;
            CGRect runRect;
            
            runRect.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL),
                                 lineOrigin.y,
                                 runRect.size.width,
                                 runAscent + runDescent);
            
            NSDictionary * attributes = (__bridge NSDictionary *)CTRunGetAttributes(runRef);
            UMComMutiTextRun *mutiTextRun = [attributes objectForKey:UMComMutiTextRunAttributedName];
            if (mutiTextRun.drawSelf)
            {
                CGFloat runAscent,runDescent;
                CGFloat runWidth  = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                CGFloat runHeight = (lineAscent + lineDescent );
                CGFloat runPointX = runRect.origin.x + lineOrigin.x;
                CGFloat runPointY = lineOrigin.y;
                
                CGRect runRectDraw = CGRectMake(runPointX, runPointY, runWidth, runHeight);
                
                [mutiTextRun drawRunWithRect:runRectDraw];
                
                [self.runRectDictionary setObject:mutiTextRun forKey:[NSValue valueWithCGRect:runRectDraw]];
            }
            else
            {
                if (mutiTextRun)
                {
                    [self.runRectDictionary setObject:mutiTextRun forKey:[NSValue valueWithCGRect:runRect]];
                }
            }
        }
    }
}


- (void)tapInCerrentView:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self];
    CGPoint runLocation = CGPointMake(location.x-self.pointOffset.x, self.frame.size.height - location.y+self.pointOffset.y+2);
    
    __weak UMComMutiStyleTextView *weakSelf = self;
    if (self.clickOnlinkText) {
        if (self.runRectDictionary.count > 0) {
            BOOL isInclude = NO;
            for (NSValue *key in [self.runRectDictionary allKeys]) {
                id object = [self.runRectDictionary objectForKey:key];                
                CGRect rect = [((NSValue *)key) CGRectValue];
                if(CGRectContainsPoint(rect, runLocation))
                {
                    isInclude = YES;
                    weakSelf.touchRun = (UMComMutiTextRun *)object;
                    if ([object isKindOfClass:[UMComMutiTextRunURL class]]) {
                        if (![[weakSelf.touchRun.text lowercaseString] hasPrefix:@"http"]) {
                            weakSelf.touchRun.text = [NSString stringWithFormat:@"http://%@",weakSelf.touchRun.text];
                        }
                    }
                    break;
                }
            }
            if (isInclude == YES) {
                weakSelf.clickOnlinkText(self,weakSelf.touchRun);
            }else{
                weakSelf.clickOnlinkText(self,nil);
            }
        }else{
            weakSelf.clickOnlinkText(self,nil);
        }

    }

}


//#pragma mark -
//
//+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace
//{
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
//    //设置字体
//    CTFontRef fontRef = CTFontCreateFromUIFont(font);
//    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
//    CFRelease(fontRef);
//    
//    //添加换行模式
//    CTParagraphStyleSetting lineBreakMode;
//    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;
//    lineBreakMode.spec        = kCTParagraphStyleSpecifierLineBreakMode;
//    lineBreakMode.value       = &lineBreak;
//    lineBreakMode.valueSize   = sizeof(lineBreak);
//
//    //行距
//    CTParagraphStyleSetting lineSpaceStyle;
//    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
//    lineSpaceStyle.valueSize = sizeof(lineSpace);
//    lineSpaceStyle.value =&lineSpace;
//    
//    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakMode};
//    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
//    CFRelease(style);
//    
//    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
////    
////    
////    [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,attString.length)];
//    return attString;
//}

//+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString
//                                 runType:(UMComMutiTextRunTypeList)type
//                                    font:(UIFont *)font
//                              checkWords:(NSArray *)checkWords
//{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    UIColor *blueColor = [UMComTools colorWithHexString:FontColorBlue];
//    if (type == UMComMutiTextRunFeedContentType || type == UMComMutiTextRunCommentType || type == UMComMutiTextRunLikeType || type == UMComMutiTextRunNoneType)
//    {
//        NSArray *subRunArray = [UMComMutiTextRunURL runsWithAttributedString:attString font:font textColor:blueColor];
//        if (subRunArray.count > 0) {
//            [array addObjectsFromArray:subRunArray];
//        }
//        subRunArray = [UMComMutiTextRunTopic runsWithAttributedString:attString font:font textColor:blueColor checkWords:checkWords];
//        if (subRunArray.count > 0) {
//            [array addObjectsFromArray:subRunArray];
//        }
//        subRunArray = [UMComMutiTextRunClickUser runsWithAttributedString:attString font:font textColor:blueColor checkWords:checkWords];
//        if (subRunArray.count > 0) {
//            [array addObjectsFromArray:subRunArray];
//        }
//    }
//    return  array;
//}


//- (NSArray *)runsWithattributString:(NSMutableAttributedString *)attribuString
//                               Font:(UIFont *)font
//                          lineSpace:(CGFloat )lineSpace
//                              color:(UIColor *)color
//                         checkWords:(NSArray *)checkWords
//{
//    return nil;
//}

//+ (UMComMutiStyleTextView *)rectDictionaryWithSize:(CGSize)size
//                                              font:(UIFont *)font
//                                         attString:(NSString *)string
//                                         lineSpace:(CGFloat )lineSpace
//                                           runType:(UMComMutiTextRunTypeList)runType
//                                        checkWords:(NSMutableArray *)checkWords
//{
//    UMComMutiStyleTextView * styleTextView = [[UMComMutiStyleTextView alloc] init];
//    styleTextView.checkWords = checkWords;
//    styleTextView.font = font;
//    styleTextView.lineSpace = lineSpace;
//    [styleTextView rectDictionaryWithSize:size font:font attString:string lineSpace:lineSpace];
//    return styleTextView;
//}

//- (void)rectDictionaryWithSize:(CGSize)size font:(UIFont *)font attString:(NSString *)string lineSpace:(CGFloat )lineSpace
//{
//    if (!string || string.length == 0) {
//        return;
//    }
//    CGFloat shortestLineWith = 0;
//    int lineCount = 0;
//    NSMutableAttributedString *attString = [[self class] createAttributedStringWithText:string font:font lineSpace:lineSpace];
//    NSDictionary *dic = [attString attributesAtIndex:0 effectiveRange:nil];
//    CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[dic objectForKey:(id)kCTParagraphStyleAttributeName];
//    CGFloat linespace = 0;
//    
//    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(linespace), &linespace);
//    
//    CGFloat height = 0;
//    CGFloat width = 0;
//    CFIndex lineIndex = 0;
//    
//    CGMutablePathRef pathRef = CGPathCreateMutable();
//    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, size.width, size.height));
//    
//    NSArray *runs = [[self class] createTextRunsWithAttString:attString runType:0 font:font checkWords:self.checkWords];
//    self.runs = runs;
//    
//    CFAttributedStringRef attStringRef = (__bridge CFAttributedStringRef)attString;
//    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString(attStringRef);
//    self.framesetterRef = (__bridge_transfer id)(CFRetain(setterRef));
//    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, nil);
//    CFArrayRef lines = CTFrameGetLines(frameRef);
//    
//    lineIndex = CFArrayGetCount(lines);
//    lineCount = (int)lineIndex;
//    
//    CTLineRef lineRef;
//    if (lineIndex > 1)
//    {
//        for (int i = 0; i <lineIndex ; i++)
//        {
//            lineRef= CFArrayGetValueAtIndex(lines, i);
//            if (i == lineIndex - 1) {
//                CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
//                shortestLineWith = rect.size.width;
//            }
//            CGFloat lineAscent;
//            CGFloat lineDescent;
//            CGFloat lineLeading;
//            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
//            
//            if (i == lineIndex - 1)
//            {
//                height += (lineAscent + lineDescent +linespace);
//            }
//            else
//            {
//                height += (lineAscent + lineDescent + linespace);
//            }
//        }
//        width = size.width;
//    }
//    else
//    {
//        lineRef= CFArrayGetValueAtIndex(lines, 0);
//        CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
//        shortestLineWith = rect.size.width;
////        self.lineHeight = rect.size.height + linespace;
//        width = rect.size.width;
//        CGFloat lineAscent;
//        CGFloat lineDescent;
//        CGFloat lineLeading;
//        CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
//        
//        height += (lineAscent + lineDescent + lineLeading + linespace);
//        height = height;
//    }
//    
////    self.totalHeight = height + lineSpace/2;
//    self.attributedText = attString;
//    CGPathRelease(pathRef);
//    CFRelease(setterRef);
//    CFRelease(frameRef);
//}

@end


@interface UMComMutiText ()

@property (nonatomic, copy) void (^configTextCompletion)();

@property (nonatomic, copy) void (^configTextArrayCompletion)(NSArray *mutiTextArray);


@end


@implementation UMComMutiText

- (instancetype)init
{
    self = [super init];
    if (self) {
        _text        = nil;
        _font        = [UIFont systemFontOfSize:13.0f];
        _textColor   = [UIColor blackColor];
        _lineSpace   = 2.0f;
        _attributedText = nil;
        _pointOffset = CGPointZero;
        //private
        _runs        = [NSMutableArray array];
        _framesetterRef = NULL;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    NSMutableAttributedString *attString = nil;
    if (string && string.length > 0) {
        attString = [[NSMutableAttributedString alloc] initWithString:string];
    }
    _text = string;
    self = [self initWithAttributedString:attString];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithAttributedString:(NSMutableAttributedString *)attributedString
{
    self = [self init];
    if (self) {
        _attributedText = attributedString;
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self setTextFont:font forRange:NSMakeRange(0,self.attributedText.length)];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setTextColor:textColor forRange:NSMakeRange(0,self.attributedText.length)];
}

- (void)setTextFont:(UIFont *)font forRange:(NSRange)range
{
    NSMutableAttributedString *attString = self.attributedText;
    if ([attString isKindOfClass:[NSMutableAttributedString class]] && attString.length > 0) {
        //设置字体
        CTFontRef fontRef = CTFontCreateFromUIFont(font);//CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
        [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:range];
        CFRelease(fontRef);
    }
}

- (void)setTextColor:(UIColor *)color forRange:(NSRange)range
{
    if ([_attributedText isKindOfClass:[NSMutableAttributedString class]] && _attributedText.length > 0 && color) {
        //设置颜色
        [_attributedText addAttribute:(NSString*)kCTForegroundColorAttributeName value:color range:NSMakeRange(0,_attributedText.length)];
    }
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    _lineSpace = lineSpace;
}

//- (void)setLineSpace:(CGFloat)lineSpace forRange:(NSRange)range
//{
//    if ([_attributedText isKindOfClass:[NSMutableAttributedString class]] && _attributedText.length > 0) {
//        //行距
//        CTParagraphStyleSetting lineSpaceStyle;
//        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
//        lineSpaceStyle.valueSize = sizeof(lineSpace);
//        lineSpaceStyle.value =&lineSpace;
//        CTParagraphStyleSetting settings[] = {lineSpaceStyle};
//        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
//        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
//        CFRelease(style);
//        [_attributedText addAttributes:attributes range:range];
//    }
//}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    _lineBreakMode = lineBreakMode;
    [self setLineBreakMode:lineBreakMode forRange:NSMakeRange(0, [_attributedText length])];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode forRange:(NSRange)range
{

}


+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
{
    UMComMutiText *mutiText = [[UMComMutiText alloc]initWithString:string];
    [mutiText setMutiTextWithSize:size  font:font string:string lineSpace:lineSpace checkWords:checkWords];
    mutiText.text = string;
    return mutiText;
}

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor
{
    UMComMutiText *mutiText = [[UMComMutiText alloc]initWithString:string];
    mutiText.textColor = textColor;
    [mutiText setMutiTextWithSize:size font:font string:string lineSpace:lineSpace checkWords:checkWords];
    mutiText.text = string;
    return mutiText;
}

+ (UMComMutiText *)mutiTextWithSize:(CGSize)size
                               font:(UIFont *)font
                             string:(NSString *)string
                          lineSpace:(CGFloat)lineSpace
                         checkWords:(NSArray *)checkWords
                          textColor:(UIColor *)textColor
                     highLightColor:(UIColor *)highLightColor
{
    UMComMutiText *mutiText = [[UMComMutiText alloc]initWithString:string];
    mutiText.textHighLightColor = highLightColor;
    mutiText.textColor = textColor;
    [mutiText setMutiTextWithSize:size font:font string:string lineSpace:lineSpace checkWords:checkWords];
    mutiText.text = string;
    return mutiText;
}

- (void)setMutiTextWithSize:(CGSize)size
                       font:(UIFont *)font
                     string:(NSString *)string
                  lineSpace:(CGFloat)lineSpace
                 checkWords:(NSArray *)checkWords
{
    self.font = font;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.lineSpace = lineSpace;
    [self reloadTextDataforRange:NSMakeRange(0, _attributedText.length)];
    [self setHightLightAttributedTextWithSize:size checkWords:checkWords];
}

- (void)reloadTextDataforRange:(NSRange)range
{
    if ([_attributedText isKindOfClass:[NSMutableAttributedString class]] && _attributedText.length > 0) {
        CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;
        switch (_lineBreakMode) {
            case NSLineBreakByCharWrapping:
                lineBreak = kCTLineBreakByCharWrapping;
                break;
            case NSLineBreakByClipping:
                lineBreak = kCTLineBreakByClipping;
                break;
            case NSLineBreakByTruncatingHead:
                lineBreak = kCTLineBreakByTruncatingHead;
                break;
            case NSLineBreakByTruncatingTail:
                lineBreak = kCTLineBreakByTruncatingTail;
                break;
            case NSLineBreakByTruncatingMiddle:
                lineBreak = kCTLineBreakByTruncatingMiddle;
                break;
            default:
                lineBreak = kCTLineBreakByWordWrapping;
                break;
        }
        //行距
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
        lineSpaceStyle.valueSize = sizeof(_lineSpace);
        lineSpaceStyle.value =&_lineSpace;
        
        //添加换行模式
        CTParagraphStyleSetting lineBreakModeSetting;
        lineBreakModeSetting.spec        = kCTParagraphStyleSpecifierLineBreakMode;
        lineBreakModeSetting.value       = &lineBreak;
        lineBreakModeSetting.valueSize   = sizeof(lineBreak);
        
        CTParagraphStyleSetting settings[] = {lineBreakModeSetting,lineSpaceStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
        CFRelease(style);
        [_attributedText addAttributes:attributes range:range];
    }
}

- (void)setHightLightAttributedTextWithSize:(CGSize)size checkWords:(NSArray *)checkWords
{
    NSMutableAttributedString *attString = self.attributedText;
    if (!attString || attString.length == 0) {
        return;
    }
    CGFloat LastLineWith = 0;
    CGFloat totalHeight  = 0;
    int lineCount = 0;
    NSDictionary *dic = [attString attributesAtIndex:0 effectiveRange:nil];
    CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[dic objectForKey:(id)kCTParagraphStyleAttributeName];
    CGFloat linespace = 0;
    
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(linespace), &linespace);
    
    CGFloat height = 0;
    CGFloat width = 0;
    CFIndex lineIndex = 0;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, size.width, size.height));
     UIColor *blueColor = UMComColorWithColorValueString(@"#507DAF");
    if (!self.textHighLightColor) {
        self.textHighLightColor = blueColor;
    }
    NSArray *runs = [[self class] createTextRunsWithAttString:attString font:_font highLightColor:self.textHighLightColor checkWords:checkWords];
    self.runs = runs;
    
    CFAttributedStringRef attStringRef = (__bridge CFAttributedStringRef)attString;
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString(attStringRef);
    self.framesetterRef = (__bridge_transfer id)(CFRetain(setterRef));
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, nil);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    
    lineIndex = CFArrayGetCount(lines);
    lineCount = (int)lineIndex;
    
    CTLineRef lineRef;
    if (lineIndex > 1)
    {
        for (int i = 0; i <lineIndex ; i++)
        {
            lineRef= CFArrayGetValueAtIndex(lines, i);
            if (i == lineIndex - 1) {
                CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
                LastLineWith = rect.size.width;
            }
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
            
            if (i == lineIndex - 1)
            {
                height += (lineAscent + lineDescent +linespace);
            }
            else
            {
                height += (lineAscent + lineDescent + linespace);
            }
        }
        width = size.width;
    }
    else
    {
        lineRef= CFArrayGetValueAtIndex(lines, 0);
        CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
        LastLineWith = rect.size.width;
        width = rect.size.width + 2;
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
        height += (lineAscent + lineDescent + lineLeading + linespace);
    }
    
    totalHeight = height;
    _textSize = CGSizeMake(width, totalHeight);
    _attributedText = attString;
    CGPathRelease(pathRef);
    CFRelease(setterRef);
    CFRelease(frameRef);
}

+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString
                                    font:(UIFont *)font
                          highLightColor:(UIColor *)color
                              checkWords:(NSArray *)checkWords
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *subRunArray = [UMComMutiTextRunURL runsWithAttributedString:attString font:font textColor:color];
    if (subRunArray.count > 0) {
        [array addObjectsFromArray:subRunArray];
    }
    subRunArray = [UMComMutiTextRunTopic runsWithAttributedString:attString font:font textColor:color checkWords:checkWords];
    if (subRunArray.count > 0) {
        [array addObjectsFromArray:subRunArray];
    }
    subRunArray = [UMComMutiTextRunClickUser runsWithAttributedString:attString font:font textColor:color checkWords:checkWords];
    if (subRunArray.count > 0) {
        [array addObjectsFromArray:subRunArray];
    }
    return  array;
}


@end

