//
//  UMComEditForwardView.m
//  UMCommunity
//
//  Created by umeng on 15/11/20.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComEditForwardView.h"
#import "UMComImageView.h"
#import "UMComEditTextView.h"
#import "UMComTools.h"

const CGFloat g_UMComEditForwardView_LeftMargin = 15.f;//左边界的距离
const CGFloat g_UMComEditForwardView_RightMargin = 15.f;//右边界的距离

const CGFloat g_UMComEditForwardView_forwardImageTopMargin = 11.f;//图片上边界距离
const CGFloat g_UMComEditForwardView_forwardImageBottomMargin = 11.f;//图片下边界
const CGFloat g_UMComEditForwardView_forwardImageHeight = 71;//图片高度
const CGFloat g_UMComEditForwardView_forwardImageWidth = 71;//图片宽度

const CGFloat g_UMComEditForwardView_spaceBetweenImgAndText = 11;//图片和文本的间距

const CGFloat g_UMComEditForwardView_forwardCreatorTopMargin = 15;//@feed作者的上边距

const CGFloat g_UMComEditForwardView_forwardCreatorHeight = 25;//@feed作者的高度(此处用UI提供的15会显示不全，需要上下都加5个距离)

const CGFloat g_UMComEditForwardView_spaceBetweenCreatorAndContent = 5;//@feed作者和内容的边距

const CGFloat g_UMComEditForwardView_forwardContentHeight = 40;//@feed内容的高度(self.forwardEditTextView.scrollEnabled = YES，32的高度刚好显示两行||self.forwardEditTextView.scrollEnabled = NO,40的高度刚好显示两行)





@interface UMComEditForwardView ()



@property (nonatomic, strong) UMComEditTextView *forwardCreatorEditTextView;
@end

@implementation UMComEditForwardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)reloadViewsWithText:(NSString *)text checkWords:(NSArray *)checkWords urlString:(NSString *)urlString
{
    [self.forwardImageView removeFromSuperview];
    [self.forwardEditTextView removeFromSuperview];
    self.forwardEditTextView.placeholderLabel.text = @" 说说你的观点...";
    NSArray *regexArray = [NSArray arrayWithObjects:UserRulerString, TopicRulerString,UrlRelerSring, nil];
    if (urlString) {
        /*
        self.forwardImageView = [[[UMComImageView imageViewClassName] alloc] initWithFrame:CGRectMake(self.frame.size.width-75, self.frame.size.height/2-35+3, 70, 70)];
        self.forwardImageView.isAutoStart = YES;
        self.forwardImageView.backgroundColor = [UIColor clearColor];
        [self.forwardImageView setImageURL:urlString placeHolderImage:UMComImageWithImageName(@"photox")];
        self.forwardEditTextView = [[UMComEditTextView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-self.forwardImageView.frame.size.width-5, self.frame.size.height-5) checkWords:checkWords regularExStrArray:regexArray];
        [self addSubview:self.forwardImageView];
         */
        self.forwardImageView = [[[UMComImageView imageViewClassName] alloc] initWithFrame:CGRectMake(5, self.frame.size.height/2-35+3, 70, 70)];
        self.forwardImageView.isAutoStart = YES;
        self.forwardImageView.backgroundColor = [UIColor clearColor];
        [self.forwardImageView setImageURL:urlString placeHolderImage:UMComImageWithImageName(@"photox")];
        
        self.forwardEditTextView = [[UMComEditTextView alloc]initWithFrame:CGRectMake(5 + self.forwardImageView.frame.size.width, 5, self.frame.size.width-self.forwardImageView.frame.size.width-5, self.frame.size.height-5) checkWords:checkWords regularExStrArray:regexArray];
        [self addSubview:self.forwardImageView];
        
    }else{
        self.forwardEditTextView = [[UMComEditTextView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-5) checkWords:checkWords regularExStrArray:regexArray];
    }
    UIImage *resizableImage = [UMComImageWithImageName(@"origin_image_bg") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 50, 0, 0)];
    self.image = resizableImage;
    self.forwardEditTextView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.forwardEditTextView];
    self.userInteractionEnabled = YES;
    self.forwardEditTextView.checkWords = checkWords;
    [self.forwardEditTextView setFont:UMComFontNotoSansLightWithSafeSize(15)];
    self.forwardEditTextView.text = text;
    self.forwardEditTextView.editable = NO;
    [self.forwardEditTextView updateEditTextView];
}

- (void)reloadViewsWithForwardCreator:(NSString *)forwardCreator forwardContent:(NSString*)forwardContent checkWords:(NSArray *)checkWords urlString:(NSString *)urlString
{
    self.backgroundColor = UMComColorWithColorValueString(@"#F5F6FA");
    
    [self.forwardImageView removeFromSuperview];
    [self.forwardCreatorEditTextView removeFromSuperview];
    [self.forwardEditTextView removeFromSuperview];
    self.forwardEditTextView.placeholderLabel.text = @" 说说你的观点...";
    NSArray *regexArray = [NSArray arrayWithObjects:UserRulerString, TopicRulerString,UrlRelerSring, nil];
    if (urlString) {
        self.forwardImageView = [[[UMComImageView imageViewClassName] alloc] initWithFrame:CGRectMake(g_UMComEditForwardView_LeftMargin,g_UMComEditForwardView_forwardImageTopMargin,g_UMComEditForwardView_forwardImageWidth,g_UMComEditForwardView_forwardImageHeight)];
        
        self.forwardImageView.isAutoStart = YES;
        self.forwardImageView.backgroundColor = [UIColor clearColor];
        [self.forwardImageView setImageURL:urlString placeHolderImage:UMComImageWithImageName(@"photox")];
        [self addSubview:self.forwardImageView];
    }
    else{
        if (self.forwardImageView) {
            self.forwardImageView.frame = CGRectMake(0, 0, 0, 0);
        }
    }
    
    //创建feed的创建者的textview
    self.forwardCreatorEditTextView = [[UMComEditTextView alloc]initWithFrame:CGRectMake(g_UMComEditForwardView_LeftMargin + self.forwardImageView.bounds.size.width + g_UMComEditForwardView_spaceBetweenImgAndText,
        g_UMComEditForwardView_forwardCreatorTopMargin,
        self.bounds.size.width - g_UMComEditForwardView_LeftMargin - g_UMComEditForwardView_RightMargin - g_UMComEditForwardView_spaceBetweenImgAndText - self.forwardImageView.bounds.size.width,
        g_UMComEditForwardView_forwardCreatorHeight)
                                                            checkWords:checkWords
                                                     regularExStrArray:regexArray];
    
    self.forwardCreatorEditTextView.scrollEnabled = NO;//不允许滑动
    self.forwardCreatorEditTextView.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.forwardCreatorEditTextView.checkWords = checkWords;
    [self.forwardCreatorEditTextView setFont:UMComFontNotoSansLightWithSafeSize(14)];
    self.forwardCreatorEditTextView.text = forwardCreator;
    self.forwardCreatorEditTextView.editable = NO;
    [self.forwardCreatorEditTextView updateEditTextView];
    [self addSubview:self.forwardCreatorEditTextView];
    self.forwardCreatorEditTextView.textColor = UMComColorWithColorValueString(@"#666666");
    
    CGSize minforwardCreatorSize = [forwardCreator sizeWithFont:UMComFontNotoSansLightWithSafeSize(14)];
    if (self.forwardCreatorEditTextView.bounds.size.height < minforwardCreatorSize.height) {
        CGRect tempforwardCreatorBound = self.forwardCreatorEditTextView.bounds;
        tempforwardCreatorBound.size.height = minforwardCreatorSize.height + 5;
        self.forwardCreatorEditTextView.bounds = tempforwardCreatorBound;
        
    }
    
    //创建feed的创建者的内容的texview
    self.forwardEditTextView = [[UMComEditTextView alloc]initWithFrame:CGRectMake(g_UMComEditForwardView_LeftMargin + self.forwardImageView.bounds.size.width + g_UMComEditForwardView_spaceBetweenImgAndText,
        g_UMComEditForwardView_forwardCreatorTopMargin + self.forwardCreatorEditTextView.bounds.size.height + g_UMComEditForwardView_spaceBetweenCreatorAndContent,
        self.bounds.size.width - g_UMComEditForwardView_LeftMargin - g_UMComEditForwardView_RightMargin - g_UMComEditForwardView_spaceBetweenImgAndText - self.forwardImageView.bounds.size.width,
        g_UMComEditForwardView_forwardContentHeight)
                                                            checkWords:checkWords
                                                     regularExStrArray:regexArray];
    
    self.forwardEditTextView.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.forwardEditTextView.checkWords = checkWords;
    [self.forwardEditTextView setFont:UMComFontNotoSansLightWithSafeSize(12)];
    self.forwardEditTextView.text = forwardContent;
    self.forwardEditTextView.editable = NO;
    [self.forwardEditTextView updateEditTextView];
    [self addSubview:self.forwardEditTextView];
    self.forwardEditTextView.textColor = UMComColorWithColorValueString(@"#A5A5A5");
    self.forwardEditTextView.scrollEnabled = NO;
}

@end


