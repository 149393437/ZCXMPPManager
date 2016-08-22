//
//  UMComPageControlView.h
//  UMCommunity
//
//  Created by umeng on 15-4-20.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PageControlItemStyle{
    PageControlDefaultType = 0,
    PageControlTitleType = 1
}PageControlItemType;

@interface UMComPageControlView : UIView

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIColor *unselectedColor;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) NSMutableArray *indexesOfNotices;

@property (nonatomic, assign) PageControlItemType pageControlItemType;
@property (nonatomic, copy) void (^didSelectedAtIndexBlock)(NSInteger index);

- (id)initWithFrame:(CGRect)frame totalPages:(NSInteger)totalPages currentPage:(NSInteger)currentPage;

- (id)initWithFrame:(CGRect)frame itemTitles:(NSArray *)itemTitles currentPage:(NSInteger)currentPage;

- (id)initWithFrame:(CGRect)frame itemImages:(NSArray *)itemImages currentPage:(NSInteger)currentPage;

- (void)setItemTitles:(NSArray *)itemTitles;
- (void)setItemImages:(NSArray *)itemImages;

//刷新pages
- (void)reloadPages;

@end


@interface UMComPageNumberView : UIView

@property (nonatomic, strong) UIColor *itemColor;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel  *itemLabel;
@property (nonatomic, strong) UIImageView *itemNoticeImageView;

@property (nonatomic, assign) PageControlItemType itemType;

@property (nonatomic, copy) void (^clickOnItem)(NSInteger index);

@property (nonatomic, assign) NSInteger index;

@end