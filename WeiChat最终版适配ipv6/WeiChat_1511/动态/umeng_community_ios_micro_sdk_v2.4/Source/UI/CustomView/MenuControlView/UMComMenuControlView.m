//
//  UMComMunueControlView.m
//  UMCommunity
//
//  Created by umeng on 15/7/13.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComMenuControlView.h"
#import "UMComTools.h"

@interface UMComMenuControlView ()

@property (nonatomic, strong) UIImageView *scrollImageView;

@end

@implementation UMComMenuControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollImageHeight = 5;
        CGFloat noticeViewWidth = 8.6;
        self.backgroundColor = [UIColor whiteColor];
        CGFloat buttonHeight = frame.size.height - self.scrollImageHeight;
        CGFloat buttonWidth = self.frame.size.width/2;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 2, buttonWidth, buttonHeight);
        [leftButton addTarget:self action:@selector(clikOnLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:@"我的评论" forState:UIControlStateNormal];
        leftButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:leftButton];
        leftButton.titleLabel.font = UMComFontNotoSansLightWithSafeSize(16);
        self.leftButton = leftButton;
        self.leftNotiView = [self createNoticeViewWithFrame:CGRectMake(leftButton.frame.size.width-30, noticeViewWidth/2, noticeViewWidth, noticeViewWidth)];
        [self.leftButton addSubview:self.leftNotiView];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(self.frame.size.width/2, 2, buttonWidth, buttonHeight);
        [rightButton addTarget:self action:@selector(clikOnRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"评论我的" forState:UIControlStateNormal];
        rightButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        rightButton.titleLabel.font = UMComFontNotoSansLightWithSafeSize(16);
        [self addSubview:rightButton];
        self.rightButton = rightButton;
        self.rightNoticeView = [self createNoticeViewWithFrame:CGRectMake(leftButton.frame.size.width-30, noticeViewWidth/2, noticeViewWidth, noticeViewWidth)];
        [self.rightButton addSubview:self.rightNoticeView];
        
        UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        bottomLineView.backgroundColor = [UMComTools colorWithHexString:FontColorBlue];
        [self addSubview:bottomLineView];
        bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        self.bottomLineView = bottomLineView;
        
        self.scrollImageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftButton.frame.origin.x, frame.size.height-self.scrollImageHeight, leftButton.frame.size.width, self.scrollImageHeight)];
        self.scrollImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        self.scrollImageView.image = UMComImageWithImageName(@"selected");
        [self addSubview:self.scrollImageView];
        
        [self clikOnLeftButton:self.leftButton];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
    }
    return self;
}

- (void)setScrollImageHeight:(CGFloat)scrollImageHeight
{
    _scrollImageHeight = scrollImageHeight;
    self.scrollImageView.frame = CGRectMake(self.scrollImageView.frame.origin.x, self.frame.size.height - self.scrollImageHeight, self.scrollImageView.frame.size.width, scrollImageHeight);
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight
{
    _bottomLineHeight = bottomLineHeight;
    self.bottomLineView.frame = CGRectMake(self.bottomLineView.frame.origin.x, self.frame.size.height-self.bottomLineHeight, self.bottomLineView.frame.size.width, bottomLineHeight);
}

- (UIView *)createNoticeViewWithFrame:(CGRect)frame
{
    UIView *view =[[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = frame.size.width/2;
    view.clipsToBounds = YES;
    view.hidden = YES;
    return view;
}


- (void)clikOnLeftButton:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [sender setTitleColor:[UMComTools colorWithHexString:FontColorBlue] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.scrollImageView.frame = CGRectMake(sender.frame.origin.x, weakSelf.scrollImageView.frame.origin.y, weakSelf.scrollImageView.frame.size.width, weakSelf.scrollImageView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    if (self.SelectedIndex) {
        self.SelectedIndex(0);
    }
}

- (void)clikOnRightButton:(UIButton *)sender
{
    [sender setTitleColor:[UMComTools colorWithHexString:FontColorBlue] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.scrollImageView.frame = CGRectMake(sender.frame.origin.x, weakSelf.scrollImageView.frame.origin.y, weakSelf.scrollImageView.frame.size.width, weakSelf.scrollImageView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    if (self.SelectedIndex) {
        self.SelectedIndex(1);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
