//
//  UMComPageControlView.m
//  UMCommunity
//
//  Created by umeng on 15-4-20.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComPageControlView.h"
#import "UMComTools.h"
#import <CoreText/CoreText.h>

@interface UMComPageControlView ()

@property (nonatomic,strong) NSMutableDictionary *pageNumDictionary;

@property (nonatomic,strong) NSMutableArray *pageNumArray;

@end

@implementation UMComPageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageNumDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        self.pageNumArray = [NSMutableArray arrayWithCapacity:1];
        self.unselectedColor = [UMComTools colorWithHexString:FontColorGray];
        self.selectedColor = [UMComTools colorWithHexString:FontColorBlue];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.image = UMComImageWithImageName(@"kuang");
        [self addSubview:imageView];
        self.bgImageView = imageView;
        self.backgroundColor = [UIColor clearColor];
        self.indexesOfNotices = [NSMutableArray array];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame totalPages:(NSInteger)totalPages currentPage:(NSInteger)currentPage
{
    self = [self initWithFrame:frame];
    if (self) {
        self.currentPage = currentPage;
        [self resetPagesWithTotalPages:totalPages];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles currentPage:(NSInteger)currentPage
{
    self = [self initWithFrame:frame];
    if (self) {
        self.currentPage = currentPage;
        self.totalPages = itemTitles.count;
        [self setItemTitles:itemTitles];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame itemImages:(NSArray *)itemImages currentPage:(NSInteger)currentPage
{
    self = [self initWithFrame:frame];
    if (self) {
        self.currentPage = currentPage;
        self.totalPages = itemImages.count;
        [self setItemImages:itemImages];
    }
    return self;
}


- (void)resetPagesWithTotalPages:(NSInteger)totalPage
{
    self.pageControlItemType = PageControlDefaultType;
    _totalPages = totalPage;
    CGFloat numberHeight = self.frame.size.height;
    CGFloat space = (self.frame.size.width - numberHeight*_totalPages)/(_totalPages +1);
    if (self.pageNumArray.count < _totalPages) {
        for (int index = (int)self.pageNumArray.count; index<_totalPages; index++) {
            UMComPageNumberView *pageNumView = [[UMComPageNumberView alloc]initWithFrame:CGRectMake(index*(space+numberHeight)+space, 0, numberHeight, numberHeight)];
            [self.pageNumArray addObject:pageNumView];
            [self addSubview:pageNumView];
        }
    }else{
        for (int index = (int)_totalPages; index< self.pageNumArray.count; index++) {
            UMComPageNumberView *pageNumView = self.pageNumArray[index];
            [self.pageNumArray removeObjectAtIndex:index];
            [pageNumView removeFromSuperview];
        }
    }
}

- (void)setItemTitles:(NSArray *)itemTitles
{
    self.pageControlItemType = PageControlTitleType;
    _totalPages = itemTitles.count;
    if (itemTitles.count == 0) {
        return;
    }
    self.pageControlItemType = PageControlTitleType;
    CGFloat numberHeight = self.frame.size.height;
    CGFloat numerWidth = self.frame.size.width/itemTitles.count;
    if (self.pageNumArray.count< itemTitles.count) {
        for (int index = 0; index < itemTitles.count; index++) {
            UMComPageNumberView *pageNumView = nil;
            if (index < self.pageNumArray.count) {
                pageNumView = self.pageNumArray[index];
                pageNumView.itemLabel.text = itemTitles[index];
                if (index == 1) {
                    pageNumView.frame = CGRectMake(index*numerWidth, 0, numerWidth, numberHeight);
                }else{
                    pageNumView.frame = CGRectMake(index*numerWidth, 0, numerWidth, numberHeight);
                }
            }else{
                pageNumView = [[UMComPageNumberView alloc]initWithFrame:CGRectMake(index*numerWidth, 0, numerWidth, numberHeight)];
                if (index == 1) {
                    pageNumView.frame = CGRectMake(index*numerWidth, 0, numerWidth, numberHeight);
                }
                pageNumView.itemLabel.text = itemTitles[index];
                [self.pageNumArray addObject:pageNumView];
                [self addSubview:pageNumView];
            }

        }
    }else{
        for (int index = 0; index < self.pageNumArray.count; index++) {
            UMComPageNumberView *pageNumView = nil;
            if (index < itemTitles.count) {
                pageNumView = self.pageNumArray[index];
                pageNumView.itemLabel.text = itemTitles[index];
            }else{
                UMComPageNumberView *pageNumView = self.pageNumArray[index];
                [self.pageNumArray removeObjectAtIndex:index];
                [pageNumView removeFromSuperview];
            }
        }
    }
}

- (void)setItemImages:(NSArray *)itemImages
{
    _totalPages = itemImages.count;
    if (itemImages.count == 0) {
        return;
    }
    self.pageControlItemType = PageControlTitleType;
    CGFloat numberHeight = self.frame.size.height;
    CGFloat numerWidth = self.frame.size.width/itemImages.count;
    if (self.pageNumArray.count< itemImages.count) {
        for (int index = 0; index < itemImages.count; index++) {
            UMComPageNumberView *pageNumView = nil;
            if (index < self.pageNumArray.count) {
                pageNumView = self.pageNumArray[index];
                pageNumView.itemImageView.image = itemImages[index];
                pageNumView.frame = CGRectMake(index*numerWidth, 0, numerWidth, numberHeight);
            }else{
                pageNumView = [[UMComPageNumberView alloc]initWithFrame:CGRectMake(index*numerWidth, 0, numerWidth, numberHeight)];
                pageNumView.itemImageView.image = itemImages[index];
                [self.pageNumArray addObject:pageNumView];
                [self addSubview:pageNumView];
            }

        }
    }else{
        for (int index = 0; index < self.pageNumArray.count; index++) {
            UMComPageNumberView *pageNumView = nil;
            if (index < itemImages.count) {
                pageNumView = self.pageNumArray[index];
                pageNumView.itemImageView.image = itemImages[index];
            }else{
                UMComPageNumberView *pageNumView = self.pageNumArray[index];
                [self.pageNumArray removeObjectAtIndex:index];
                [pageNumView removeFromSuperview];
            }
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage < self.pageNumArray.count) {
        _lastPage = _currentPage;
        _currentPage = currentPage;
        [self reloadPages];
    }
}

- (void)setTotalPages:(NSInteger)totalPages
{
    _totalPages = totalPages;
}

- (void)setUnselectedColor:(UIColor *)unselectedColor
{
    _unselectedColor = unselectedColor;
    [self reloadPages];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [self reloadPages];
}

- (void)reloadPages
{
    CGFloat numberHeight = self.frame.size.height;
    CGFloat numerWidth = self.frame.size.width/self.pageNumArray.count;
    for (int index = 0; index < self.pageNumArray.count; index++) {
        UMComPageNumberView *pageNumView = self.pageNumArray[index];
        if (index == 1) {
            numerWidth += 0.5;
        }
        pageNumView.frame = CGRectMake(index*numerWidth, 0, numerWidth, numberHeight);
        pageNumView.itemImageView.frame = CGRectMake(0, 0, numerWidth, numberHeight);
        pageNumView.itemLabel.frame = CGRectMake(0, 0, numerWidth, numberHeight);
        pageNumView.index = index;
        if (index == self.currentPage) {
            pageNumView.itemColor = _selectedColor;
            pageNumView.itemLabel.textColor = _selectedColor;
            pageNumView.itemImageView.hidden = NO;
        }else{
            pageNumView.itemColor = _unselectedColor;
            pageNumView.itemImageView.hidden = YES;
            pageNumView.itemNoticeImageView.hidden = YES;
            pageNumView.itemLabel.textColor = _unselectedColor;
        }
        if (self.indexesOfNotices.count > 0) {
            BOOL isShowNotice = NO;
            for (NSNumber *number in self.indexesOfNotices) {
                 if (index == [number intValue]) {
                     isShowNotice = YES;
                     break;
                }
            }
             pageNumView.itemNoticeImageView.hidden = !isShowNotice;
        }else{
            pageNumView.itemNoticeImageView.hidden = YES;
        }
        pageNumView.itemType = PageControlTitleType;
        pageNumView.clickOnItem = ^(NSInteger index){
            if (self.didSelectedAtIndexBlock) {
                self.currentPage = index;
                self.didSelectedAtIndexBlock(index);
            }
        };
    }
}

@end


@implementation UMComPageNumberView
{
    CGFloat itemOffset;
    CGFloat noticeViewWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        itemOffset = 0;
        noticeViewWidth = 8.6;
        self.backgroundColor = [UIColor clearColor];
        self.itemImageView = [[UIImageView alloc]initWithFrame: CGRectMake(itemOffset, itemOffset, frame.size.width-itemOffset*2, frame.size.height-itemOffset*2)];
        self.itemImageView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(itemOffset, itemOffset, frame.size.width, frame.size.height)];
        self.itemLabel.backgroundColor = [UIColor clearColor];
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        self.itemLabel.font = UMComFontNotoSansLightWithSafeSize(18);
        [self addSubview:self.itemImageView];
        [self addSubview:self.itemLabel];
        self.itemNoticeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-noticeViewWidth*3/2, -noticeViewWidth/2, noticeViewWidth, noticeViewWidth)];
        self.itemNoticeImageView.layer.cornerRadius = noticeViewWidth/2;
        self.itemNoticeImageView.clipsToBounds = YES;
        self.itemNoticeImageView.hidden = YES;
        self.itemNoticeImageView.image = UMComImageWithImageName(@"um_red");
        [self addSubview:self.itemNoticeImageView];
        self.itemImageView.userInteractionEnabled = YES;
        self.itemLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickOnItem)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)didClickOnItem
{
    if (self.clickOnItem) {
        self.clickOnItem(self.index);
    }
}


- (void)setItemType:(PageControlItemType)itemType
{
    _itemType = itemType;
    [self setNeedsDisplay];
}

- (void)reloadItems
{
    self.itemLabel.frame = CGRectMake(itemOffset, itemOffset, self.frame.size.width-2*itemOffset, self.frame.size.height-2*itemOffset);
    self.itemImageView.frame = CGRectMake(itemOffset, itemOffset, self.frame.size.width-2*itemOffset, self.frame.size.height-2*itemOffset);
    self.itemNoticeImageView.frame = CGRectMake(self.frame.size.width-noticeViewWidth*3/2, -noticeViewWidth/2, noticeViewWidth, noticeViewWidth);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.itemType == PageControlDefaultType) {
        // Border
        //    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetFillColorWithColor(context, self.itemColor.CGColor);
        CGContextFillEllipseInRect(context, self.bounds);
        // Body
        CGContextSetFillColorWithColor(context, self.itemColor.CGColor);
        CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
        // Checkmark
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetLineWidth(context, 0.5);
        CGContextStrokePath(context);
    }

}



@end