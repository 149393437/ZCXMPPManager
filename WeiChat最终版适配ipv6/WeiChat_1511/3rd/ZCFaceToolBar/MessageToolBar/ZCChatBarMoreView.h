/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol ZCChatBarMoreViewDelegate;
@interface ZCChatBarMoreView : UIView

@property (nonatomic,assign) id<ZCChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type;

- (void)setupSubviewsForType:(ChatMoreType)type;

@end

@protocol ZCChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(ZCChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(ZCChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(ZCChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(ZCChatBarMoreView *)moreView;
- (void)moreViewVideoCallAction:(ZCChatBarMoreView *)moreView;

@end
