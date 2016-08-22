//
//  UMComHorizonMenuView.h
//  UMCommunity
//
//  Created by umeng on 15/11/10.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    menuDefaultType = 0,
    menuImageFullNoTitleType = 1,
    menuTitleFullNoImageType = 2,
    menuTitleFrontImageType = 3,
    menuTitleBottomAndImageTop = 4,
    menuTitleTopAndImageBottom = 5,
    menuTitleBottomAndNoImage = 6,
    menuTitleLeftAndImageRight = 7,
    menuTitleRightAndImageLeft = 8,
    menuButtonType = 9,//定义button点击效果
}UMComMenuItemViewType;

@class UMComMenuItem, UMComMenuItemView;

@interface UMComHorizonMenuView : UIView

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGFloat leftMargin;

@property (nonatomic, assign) CGFloat rightMargin;

@property (nonatomic, assign) CGFloat topMargin;

@property (nonatomic, readonly) NSInteger selectedIndex;

@property (nonatomic, readonly) NSInteger lastIndex;

@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic, assign) CGFloat itemSpace;

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, assign) BOOL isHighLightWhenDidSelected;

@property (nonatomic, assign) UIFont *itemTextFont;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) CGFloat bottomLineWidth;

@property (nonatomic, strong) UIImageView *scrollIndicatorView;

@property (nonatomic, assign) CGFloat scrollIndicatorWidth;


@property (nonatomic, copy ) void (^selectedAtIndex)(UMComHorizonMenuView *menuView, NSInteger index);

- (void)reloadWithMenuItems:(NSArray *)menuItems
                   itemSize:(CGSize)itemSize;

- (void)reloadWithMenuItems:(NSArray *)menuItems
                 leftMargin:(CGFloat)leftMargin
                rightMargin:(CGFloat)rightMargin
                   itemSize:(CGSize)itemSize;

- (void)reloadItems;

/**
 *  2.4版本的新方法的布局模型，|leftmargin-item-space....item-rightmargin|
 *
 */
- (void)reloadWithNewMenuItems:(NSArray *)menuItems
                 leftMargin:(CGFloat)leftMargin
                rightMargin:(CGFloat)rightMargin
                   itemSize:(CGSize)itemSize;

/**
 *  返回对应索引的控件
 *  如果menuButtonType，返回UIButton
 */
-(UIView*) viewWithIndex:(NSInteger)index;

@end

typedef enum {
    
    HighLightTextColor = 0,
    HighLightImage = 1,
    HighLightBgColor = 2,
    HighLightText = 3,
    
}HighLightType;



@interface UMComMenuItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *highLightTitle;

@property (nonatomic, copy) UIColor *highTextColor;

@property (nonatomic, copy) UIColor *textCorlor;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *highLightImageName;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIColor *highLightBgColor;

@property (nonatomic, assign) HighLightType highLightType;

@property (nonatomic, assign) UMComMenuItemViewType itemViewType;

@property (nonatomic, assign) BOOL isHighLighted;

+ (UMComMenuItem *)itemWithTitle:(NSString *)title imageName:(NSString *)name;

+ (UMComMenuItem *)itemWithTitle:(NSString *)title imageName:(NSString *)name highLightType:(HighLightType)highLightType itemViewType:(UMComMenuItemViewType)itemViewType;

+ (UMComMenuItem *)itemWithTitle:(NSString *)title imageName:(NSString *)name highLightImageName:(NSString *)highLightImageName;

+ (UMComMenuItem *)itemWithTitle:(NSString *)title imageName:(NSString *)name highLightTitle:(NSString *)highLightTitle highLightImageName:(NSString *)highLightImageName;


@end


@interface UMComMenuItemView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UMComMenuItem *menuItem;

@property (nonatomic, strong) UIButton *buton;//为高亮准备的


@property (nonatomic, copy) void (^clickBlock)(UMComMenuItemView *menuItemView,NSInteger index);

- (void)reloadWithTitle:(NSString *)title
                  image:(UIImage *)image
                  index:(NSInteger)index;
- (void)reloadWithTitle:(NSString *)title
                  image:(UIImage *)image;

- (void)highLight;

- (void)nomal;

@end