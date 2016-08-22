//
//  UMComCollectionView.h
//  UMCommunity
//
//  Created by umeng on 15-4-27.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UMComFeed;
@interface UMComShareCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, copy) void (^didSelectedIndex)(NSIndexPath *indexPath);

@property (nonatomic, weak) UIViewController *shareViewController;

@property (nonatomic, weak) UMComFeed *feed;

- (void)reloadData;
- (void)shareViewShow;
- (void)dismiss;

@end



@interface UMComCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *portrait;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void (^didSelectedIndex)(NSInteger index);

@end