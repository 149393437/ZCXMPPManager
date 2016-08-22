//
//  UMComLocationView.m
//  UMCommunity
//
//  Created by umeng on 15/11/20.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComLocationView.h"
#import "UMComTools.h"

//以下为iphone6的内部模板
const static int g_UMComLocationView_leadmarginTemplate = 15;//左边空白区域
const static int g_UMComLocationView_tailmarginTemplate = 13;//右边空白区域
const static int g_UMComLocationView_ImageTopmargin = 13;//图片上边距
const static int g_UMComLocationView_ImageWidth = 16;//图片宽
const static int g_UMComLocationView_ImageHeight = 20;//图片高

const static int g_UMComLocationView_IndicatorViewWidth = 11;//指示器的宽
const static int g_UMComLocationView_IndicatorViewHeight = 20;//指示器的高

const static int g_UMComLocationView_marginBetweenImageAndLabel = 6;//图片和文字区域的空白
const static int g_UMComLocationView_topAndbottommarginTemplate = 20;//上下加起来的空白区域针对imageView
const static int g_UMComLocationView_topAndbottommarginTemplateForIndicator = 26;//上下加起来的空白区域针对indicatorView
const static int g_UMComLocationView_widthTemplate = 375;//在iphone6的宽度




@interface UMComLocationView()

@property (nonatomic, assign) CGFloat height;

@property (nonatomic,readwrite,strong) UILabel* placeholder;
@property (nonatomic,readwrite,strong)UITapGestureRecognizer* tap;
-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer;
@end

@implementation UMComLocationView

/*
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat originX = 6;
        CGFloat originY = 4;
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(originX, originX, frame.size.height-originX*2, frame.size.height-originY*2)];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.image = UMComImageWithImageName(@"pin3x@2x");
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.height, 0, frame.size.width-frame.size.height, frame.size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = UMComFontNotoSansLightWithSafeSize(13);
        [self addSubview:self.label];
        self.height = frame.size.height;
        
        self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(originX,  0, self.bounds.size.width, self.bounds.size.height)];
        self.placeholder.font = UMComFontNotoSansLightWithSafeSize(13);
        self.placeholder.text = @"地址位置";
        self.placeholder.textAlignment = NSTextAlignmentLeft;
        self.placeholder.hidden = YES;
        [self addSubview:self.placeholder];
        
        self.tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:self.tap];
        
    }
    return self;
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithImage:UMComImageWithImageName(@"um_forum_location")];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        self.label = [[UILabel alloc] init];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = UMComFontNotoSansLightWithSafeSize(15);
        self.label.textColor = UMComColorWithColorValueString(@"#A5A5A5");
        [self addSubview:self.label];
        
        
        self.indicatorView = [[UIImageView alloc] initWithImage:UMComImageWithImageName(@"um_forum_arrow_gray")];
        self.indicatorView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.indicatorView];
        
        self.tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:self.tap];
        
    }
    return  self;
}

/*
-(void) doRelayoutChildControlsWithFrame:(CGRect)frame
{
    CGFloat parentHeight = frame.size.height;
    CGFloat parentWidth = frame.size.width;
    //计算imageView的位置
    //此处无需在计算宽度，宽度一定比高度大
    int imageView_topAndbottommarginTemplate = g_UMComLocationView_topAndbottommarginTemplate*parentWidth/g_UMComLocationView_widthTemplate;
    //int  imageViewHeight = parentHeight - g_UMComLocationView_topAndbottommarginTemplate;
    //self.imageView.frame = CGRectMake(g_UMComLocationView_leadmarginTemplate, g_UMComLocationView_topAndbottommarginTemplate/2, imageViewHeight, imageViewHeight);
    int  imageViewHeight = parentHeight - imageView_topAndbottommarginTemplate;
    self.imageView.frame = CGRectMake(g_UMComLocationView_leadmarginTemplate, imageView_topAndbottommarginTemplate/2, imageViewHeight, imageViewHeight);

    
    
    //计算indicatorView的位置
    int indicatorView_topAndbottommarginTemplateForIndicator = g_UMComLocationView_topAndbottommarginTemplateForIndicator*parentWidth/g_UMComLocationView_widthTemplate;
    int  indicatorViewHeight = parentHeight - indicatorView_topAndbottommarginTemplateForIndicator;
//    self.indicatorView.frame = CGRectMake(parentWidth - imageViewHeight - g_UMComLocationView_tailmarginTemplate, (g_UMComLocationView_topAndbottommarginTemplateForIndicator)/2, indicatorViewHeight, indicatorViewHeight);
    self.indicatorView.frame = CGRectMake(parentWidth - imageViewHeight - indicatorView_topAndbottommarginTemplateForIndicator, (indicatorView_topAndbottommarginTemplateForIndicator)/2, indicatorViewHeight, indicatorViewHeight);
    
    //计算label的位置
    self.label.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + g_UMComLocationView_marginBetweenImageAndLabel,0, self.indicatorView.frame.origin.x - g_UMComLocationView_marginBetweenImageAndLabel - self.imageView.frame.origin.x - self.imageView.frame.size.width,parentHeight);
    
}
 */
-(void) doRelayoutChildControlsWithFrame:(CGRect)frame
{
    CGFloat parentHeight = frame.size.height;
    CGFloat parentWidth = frame.size.width;
    self.imageView.frame = CGRectMake(g_UMComLocationView_leadmarginTemplate, g_UMComLocationView_ImageTopmargin, g_UMComLocationView_ImageWidth, g_UMComLocationView_ImageHeight);
    

    self.indicatorView.frame = CGRectMake(parentWidth - g_UMComLocationView_tailmarginTemplate - g_UMComLocationView_IndicatorViewWidth, g_UMComLocationView_ImageTopmargin, g_UMComLocationView_IndicatorViewWidth, g_UMComLocationView_IndicatorViewHeight);
    
    //计算label的位置
    self.label.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + g_UMComLocationView_marginBetweenImageAndLabel,0, self.indicatorView.frame.origin.x - g_UMComLocationView_marginBetweenImageAndLabel - self.imageView.frame.origin.x - self.imageView.frame.size.width,parentHeight);
}


- (void)dealloc
{
    [self removeGestureRecognizer:self.tap];
    
    self.imageView = nil;
    self.label = nil;
    self.indicatorView = nil;
    self.placeholder = nil;
}

-(void) hidePlaceholder:(BOOL)isHide
{
    self.placeholder.hidden = isHide;
    self.label.hidden = !isHide;
    self.imageView.hidden = !isHide;
}

-(void) relayoutChildControlsWithLocation:(NSString*)location
{
    if (!location) {
        //如果没有值就显示placeholder，隐藏其他控件
        //[self hidePlaceholder:NO];
        self.label.text = @"地理位置";
        self.label.textColor = UMComColorWithColorValueString(@"#b5b5b5");
    }
    else if([location isEqualToString:@""])
    {
        //如果是空字符串，也隐藏其他控件
        self.label.text = location;
        self.label.textColor = UMComColorWithColorValueString(@"#b5b5b5");
        //[self hidePlaceholder:NO];
    }
    else
    {
        //如果有值就隐藏placeholder，显示其他控件
        self.label.text = location;
        self.label.textColor = UMComColorWithColorValueString(@"#008bea");
        //[self hidePlaceholder:YES];
    }
    
    [self doRelayoutChildControlsWithFrame:self.bounds];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event
{
    if (YES) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (YES) {
        if (self.locationbackgroudColor) {
            self.backgroundColor = self.locationbackgroudColor;
        }
        else{
            self.backgroundColor = [UIColor whiteColor];
        }
        
    }}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (YES) {
        if (self.locationbackgroudColor) {
            self.backgroundColor = self.locationbackgroudColor;
        }
        else{
            self.backgroundColor = [UIColor whiteColor];
        }
    }}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    NSLog(@"gestureRecognizer.state..%ld",(long)gestureRecognizer.state);
    
    if (self.locationBlock) {
        self.locationBlock();
    }
}

@end

