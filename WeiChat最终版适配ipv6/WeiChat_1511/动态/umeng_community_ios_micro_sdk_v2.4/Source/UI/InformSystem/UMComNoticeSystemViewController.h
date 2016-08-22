//
//  UMComNoticeSystemViewController.h
//  UMCommunity
//
//  Created by umeng on 15/7/9.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//



#import "UMComViewController.h"
#import "UMComTableViewCell.h"

@interface UMComNoticeSystemViewController : UMComViewController

@end


@interface UMComNoticeListTableViewCell : UMComTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *noticeIndicator;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     cellSize:(CGSize)size;

- (void)reloadCellWithImage:(UIImage *)image
                      title:(NSString *)title
                   isNotice:(BOOL)isNotice;
@end
