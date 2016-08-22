//
//  UMComForuUserTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 15/11/29.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComImageView, UMComUser;
@protocol UMComClickActionDelegate;

@interface UMComCommonUserTableViewCell : UITableViewCell

@property (nonatomic, strong) UMComImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *feedCountLabel;

@property (nonatomic, strong) UILabel *fansCountLabel;

@property (nonatomic, strong) UIButton *focuseButton;

@property (strong, nonatomic) UIImageView *genderImageView;

@property (nonatomic, assign) id <UMComClickActionDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     cellSize:(CGSize)size;

- (void)reloadCellWithUser:(UMComUser *)user;


@end
