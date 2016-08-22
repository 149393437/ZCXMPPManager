//
//  UMComHorizonCollectionView.m
//  UMCommunity
//
//  Created by umeng on 15/11/26.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComHorizonCollectionView.h"
#import "UMComTools.h"

@interface UMComHorizonCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, strong) UICollectionViewFlowLayout *currentLayout;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSMutableDictionary *indexPathsDict;

@property (nonatomic, assign) BOOL isTheFirstTime;

@end

@implementation UMComHorizonCollectionView

- (instancetype)initWithFrame:(CGRect)frame itemCount:(NSInteger)count
{
    CGFloat itemWidth = frame.size.width/count;
    CGSize itemSize = CGSizeMake(itemWidth, frame.size.height);
    self = [self initWithFrame:frame itemSize:itemSize itemCount:count];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize itemCount:(NSInteger)count
{
    UICollectionViewFlowLayout *currentLayout = [[UICollectionViewFlowLayout alloc]init];
    currentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    currentLayout.itemSize = itemSize;
    currentLayout.sectionInset = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    self.currentLayout = currentLayout;
    self = [super initWithFrame:frame collectionViewLayout:currentLayout];
    if (self) {
        _itemSize = itemSize;
        self.itemCount = count;
        self.itemSpace = 0.5;
        _indicatorLineWidth = itemSize.width;
        _indicatorLineHeight = 0.5;
        _isTheFirstTime = YES;
        _indexPathsDict = [NSMutableDictionary dictionary];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[UMComHorizonCollectionCell class] forCellWithReuseIdentifier:@"UMComHorizonCollectionCell"];
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollIndicatorView = [[UIImageView alloc]initWithFrame:CGRectMake(_itemSpace, self.frame.size.height-0.5, self.itemSize.width, 0.5)];
        self.scrollIndicatorView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollIndicatorView];
        _indicatorLineLeftEdge = 0;
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        [self addSubview:topLine];
        self.topLine = topLine;
    }
    return self;
}

- (void)setItemCount:(NSInteger)itemCount
{
    _itemCount = itemCount;
    [self reloadData];
}

- (void)setItemSpace:(CGFloat)itemSpace
{
    _itemSpace = itemSpace;
    self.currentLayout.minimumLineSpacing = itemSpace;
    CGFloat itemWidth = (self.frame.size.width-itemSpace*(self.itemCount+1))/self.itemCount;
    self.currentLayout.itemSize = CGSizeMake(itemWidth, self.frame.size.height-1);
    self.itemSize = self.currentLayout.itemSize;
    
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight
{
    _bottomLineHeight = bottomLineHeight;
    if (!self.bottomLine) {
        self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-bottomLineHeight, self.frame.size.width, bottomLineHeight)];
        self.bottomLine.backgroundColor = self.backgroundColor;
        [self addSubview:self.bottomLine];
    }else{
        self.bottomLine.frame = CGRectMake(0, self.frame.size.height-bottomLineHeight, self.frame.size.width, bottomLineHeight);
    }
}

- (void)setIndicatorLineHeight:(CGFloat)indicatorLineHeight
{
    _indicatorLineHeight = indicatorLineHeight;
    CGRect frame = _scrollIndicatorView.frame;
    frame.size.height = indicatorLineHeight;
    frame.origin.y = self.frame.size.height - indicatorLineHeight;
    _scrollIndicatorView.frame = frame;
}

- (void)setIndicatorLineWidth:(CGFloat)indicatorLineWidth
{
    _indicatorLineWidth = indicatorLineWidth;
    CGRect frame = _scrollIndicatorView.frame;
    frame.size.width = indicatorLineWidth;
    _scrollIndicatorView.frame = frame;
}

- (void)setIndicatorLineLeftEdge:(CGFloat)indicatorLineLeftEdge
{
    _indicatorLineLeftEdge = indicatorLineLeftEdge;
    CGRect frame = _scrollIndicatorView.frame;
    frame.origin.x = indicatorLineLeftEdge;
    _scrollIndicatorView.frame = frame;
}

- (void)startIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self collectionView:self didSelectItemAtIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.scrollIndicatorView.center = CGPointMake(self.itemSize.width*index+weakSelf.indicatorLineWidth/2+UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(2.5) + _indicatorLineLeftEdge, weakSelf.scrollIndicatorView.center.y);
    }];
}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(numberOfRowInHorizonCollectionView:)]) {
        return [self.cellDelegate numberOfRowInHorizonCollectionView:self];
    }
    return _itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMComHorizonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UMComHorizonCollectionCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    if (_isTheFirstTime == YES) {
        self.currentIndexPath = indexPath;
        _isTheFirstTime = NO;
    }
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(horizonCollectionView:reloadCell:atIndexPath:)]) {
        [self.cellDelegate horizonCollectionView:self reloadCell:cell atIndexPath:indexPath];
    }
    if (self.currentIndexPath.row == indexPath.row) {
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(horizonCollectionView:hilightImageForIndexPath:)]) {
            cell.imageView.image = [self.cellDelegate horizonCollectionView:self hilightImageForIndexPath:indexPath];
        }else{
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(horizonCollectionView:imageForIndexPath:)]) {
                cell.imageView.image = [self.cellDelegate horizonCollectionView:self imageForIndexPath:indexPath];
            }
        }
        if (self.titleHightColor) {
            cell.label.textColor = self.titleHightColor;
        }
    }else{
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(horizonCollectionView:imageForIndexPath:)]) {
            cell.imageView.image = [self.cellDelegate horizonCollectionView:self imageForIndexPath:indexPath];
        }
    }
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(horizonCollectionView:titleForIndexPath:)]) {
        cell.label.text = [self.cellDelegate horizonCollectionView:self titleForIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMComHorizonCollectionCell *cell = (UMComHorizonCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    self.currentIndexPath = indexPath;
    _lastIndex = self.currentIndex;
    _currentIndex = indexPath.row;
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(horizonCollectionView:didSelectedColumn:)]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.scrollIndicatorView.center = CGPointMake(cell.frame.origin.x+weakSelf.indicatorLineWidth/2 + _indicatorLineLeftEdge, weakSelf.scrollIndicatorView.center.y);
        }];
        [self.cellDelegate horizonCollectionView:self didSelectedColumn:indexPath.row];
    }
    [self reloadData];
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//- (void)drawRect:(CGRect)rect
//{
//    UIColor *color = [UIColor redColor];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, rect);
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    CGFloat itemSpaceTopEdge = 6;
//    for (int index = 1; index < self.itemCount; index++) {
//          CGContextStrokeRect(context, CGRectMake(index * self.itemSize.width, itemSpaceTopEdge, self.itemSpace, rect.size.height - itemSpaceTopEdge*2));
//    }
//}

@end


@implementation UMComHorizonCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-1)];
        self.imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imageView];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-1)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = UMComFontNotoSansLightWithSafeSize(15);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.numberOfLines = 0;
        [self.contentView addSubview:self.label];
    }
    return self;
}

@end