//
//  UMComMunueControlView.h
//  UMCommunity
//
//  Created by umeng on 15/7/13.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMComMenuControlView : UIView

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) UIView *bottomLineView;
@property (nonatomic, strong) UIView *rightNoticeView;
@property (nonatomic, strong) UIView *leftNotiView;

@property (nonatomic, assign) CGFloat scrollImageHeight;

@property (nonatomic, assign) CGFloat bottomLineHeight;

@property (nonatomic, copy) void (^SelectedIndex)(NSInteger index);

@end
