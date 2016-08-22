//
//  UMComHorizonCollectionView.h
//  UMCommunity
//
//  Created by umeng on 15/11/26.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComHorizonCollectionCell,UMComHorizonCollectionView,UMComDropdownColumnCell;


@protocol UMComHorizonCollectionViewDelegate <NSObject>

@optional;

- (NSInteger)numberOfRowInHorizonCollectionView:(UMComHorizonCollectionView *)collectionView;

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView reloadCell:(UMComHorizonCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView didSelectedColumn:(NSInteger)column;

- (UIImage *)horizonCollectionView:(UMComHorizonCollectionView *)collectionView imageForIndexPath:(NSIndexPath *)indexPath;

- (UIImage *)horizonCollectionView:(UMComHorizonCollectionView *)collectionView hilightImageForIndexPath:(NSIndexPath *)indexPath;

- (NSString *)horizonCollectionView:(UMComHorizonCollectionView *)collectionView titleForIndexPath:(NSIndexPath *)indexPath;

@end

@interface UMComHorizonCollectionView : UICollectionView

@property (nonatomic, assign) BOOL isHighLightWhenDidSelected;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) CGFloat itemSpace;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, readonly) NSInteger currentIndex;

@property (nonatomic, readonly) NSInteger lastIndex;

@property (nonatomic, copy) UIColor *titleHightColor;


@property (nonatomic, assign) CGFloat bottomLineHeight;

@property (nonatomic, assign) CGFloat indicatorLineHeight;

@property (nonatomic, assign) CGFloat indicatorLineWidth;

@property (nonatomic, assign) CGFloat indicatorLineLeftEdge;

@property (nonatomic, strong) UIImageView *scrollIndicatorView;

@property (nonatomic, strong) UIView *topLine;


@property (nonatomic, weak) id<UMComHorizonCollectionViewDelegate> cellDelegate;


- (instancetype)initWithFrame:(CGRect)frame itemCount:(NSInteger)count;

- (instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize itemCount:(NSInteger)count;

- (void)startIndex:(NSInteger)index;

@end


@interface UMComHorizonCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) NSInteger index;


@end

