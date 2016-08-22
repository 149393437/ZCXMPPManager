//
//  UMComUserDetaiView.h
//  UMCommunity
//
//  Created by umeng on 16/2/2.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComUser, UMComImageView, UMComUserProfileDetailView;
@protocol UMComUserProfileDetaiViewDelegate <NSObject>

@optional;
- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView
                clickOnfocuse:(UIButton *)focuseButton;

- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView
                 clickOnAlbum:(UIButton *)albumButton;

- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView
           clickOnFollowTopic:(UIButton *)topicButton;

- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView
                 clickOnScore:(UIButton *)letterButton;

- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView
                clickOnAvatar:(UMComImageView *)avartar;

- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView
                clickAtIndex:(NSInteger)index;

@end

@interface UMComUserProfileDetailView : UIView

@property (nonatomic, strong) UMComUser *user;

@property (nonatomic, assign) NSInteger lastIndex;

@property (nonatomic, strong) UMComImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, weak) id<UMComUserProfileDetaiViewDelegate> deleagte;

- (instancetype)initWithFrame:(CGRect)frame user:(UMComUser *)user;

- (void)reloadSubViewsWithUser:(UMComUser *)user;


@end
