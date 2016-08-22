//
//  UMComMicLikeUserTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 16/2/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTableViewCell.h"

@class UMComImageView, UMComUser;
@protocol UMComClickActionDelegate;

@interface UMComMicLikeUserTableViewCell : UMComTableViewCell

@property (nonatomic, strong) UMComImageView *portrait;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UMComUser *user;

@property (nonatomic, weak) id<UMComClickActionDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)size;

@end
