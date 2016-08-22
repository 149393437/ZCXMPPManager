//
//  UMComHorizonMenuView.m
//  UMCommunity
//
//  Created by umeng on 15/11/10.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComHorizonMenuView.h"
#import "UMComTools.h"

#define textFont UMComFontNotoSansLightWithSafeSize(15)
#define ButtonTextFont UMComFontNotoSansLightWithSafeSize(18)


/***************************************************************************/

@interface UMComHorizonMenuView ()

@property (nonatomic, strong) NSMutableArray *menuItemViews;

@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) NSInteger lastIndex;

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation UMComHorizonMenuView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UMComTools colorWithHexString:@"#ececec"];
        self.leftMargin = 0;
        self.rightMargin = 0;
        self.bottomLineWidth = 1;
        self.itemSize = CGSizeMake(30, 30);
        self.isHighLightWhenDidSelected = NO;
        self.menuItemViews = [NSMutableArray array];
        self.itemTextFont = textFont;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
        self.bgImageView = imageView;
    }
    return self;
}

- (void)setBottomLineWidth:(CGFloat)bottomLineWidth
{
    _bottomLineWidth = bottomLineWidth;
    if (!self.bottomLine) {
        self.bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-bottomLineWidth, self.frame.size.width, bottomLineWidth)];
        [self addSubview:self.bottomLine];
    }else{
        self.bottomLine.frame = CGRectMake(0, self.frame.size.height-bottomLineWidth, self.frame.size.width, bottomLineWidth);
    }
}

- (void)setScrollIndicatorWidth:(CGFloat)scrollIndicatorWidth
{
    _scrollIndicatorWidth = scrollIndicatorWidth;
    CGFloat width = self.itemSize.width;
    if (width == 0) {
        width = 1;
    }
    if (!self.scrollIndicatorView) {
        self.scrollIndicatorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-scrollIndicatorWidth, width, scrollIndicatorWidth)];
        [self addSubview:self.scrollIndicatorView];
    }else{
        self.scrollIndicatorView.frame = CGRectMake(0, self.frame.size.height-scrollIndicatorWidth, width, scrollIndicatorWidth);
    }
}
- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    self.scrollIndicatorView.frame = CGRectMake(self.scrollIndicatorView.frame.origin.x, self.scrollIndicatorView.frame.origin.y, itemSize.width, self.scrollIndicatorView.frame.size.height);
}

- (void)setBgImage:(UIImage *)bgImage
{
    _bgImage = bgImage;
    self.bgImageView.image = bgImage;
}

- (void)setMenuItems:(NSArray *)menuItems
{
    _menuItems = menuItems;
    if (menuItems.count == self.menuItemViews.count) {
        for (int index = 0; index < menuItems.count; index ++ ) {
            UMComMenuItemView *menuItemView = self.menuItemViews[index];
            UMComMenuItem *item = self.menuItems[index];
            menuItemView.menuItem = item;
            menuItemView.index = index;
        }
    }else{
        for (UMComMenuItemView *menuItemView in self.menuItemViews) {
            [menuItemView removeFromSuperview];
        }
        [self.menuItemViews removeAllObjects];
        for (int index = 0; index < menuItems.count; index ++ ) {
            UMComMenuItemView *menuItemView = [[UMComMenuItemView alloc] initWithFrame:CGRectMake(0, 0, self.itemSize.width, self.itemSize.height)];
            menuItemView.titleLabel.font = self.itemTextFont;
            UMComMenuItem *item = self.menuItems[index];
            menuItemView.menuItem = item;
            menuItemView.index = index;
            [self.menuItemViews addObject:menuItemView];
        }
    }
}

- (void)reloadWithMenuItems:(NSArray *)menuItems
                   itemSize:(CGSize)itemSize
{
    self.itemSize = itemSize;
    self.menuItems = menuItems;
    [self reloadItems];
}

- (void)reloadWithMenuItems:(NSArray *)menuItems
                 leftMargin:(CGFloat)leftMargin
                rightMargin:(CGFloat)rightMargin
                   itemSize:(CGSize)itemSize
{
    self.leftMargin = leftMargin;
    self.rightMargin = rightMargin;
    if (menuItems.count == 0) {
        return;
    }
    [self reloadWithMenuItems:menuItems itemSize:itemSize];
}

- (void)reloadWithNewMenuItems:(NSArray *)menuItems
                    leftMargin:(CGFloat)leftMargin
                   rightMargin:(CGFloat)rightMargin
                      itemSize:(CGSize)itemSize
{
    if (menuItems.count == 0) {
        return;
    }
    self.leftMargin = leftMargin;
    self.rightMargin = rightMargin;
    self.itemSize = itemSize;
    self.menuItems = menuItems;

    {
        CGFloat itemSpace = 0;
        NSInteger spaceCount = self.menuItemViews.count - 1;
        itemSpace = (self.frame.size.width - self.leftMargin - self.rightMargin - self.itemSize.width * self.menuItemViews.count)/spaceCount;
        self.itemSpace = itemSpace;
        for (int index = 0; index < self.menuItemViews.count; index ++) {
            UMComMenuItemView *menuItemView = self.menuItemViews[index];
            CGRect tempFrame = CGRectMake(self.leftMargin + index*(self.itemSpace + self.itemSize.width), (self.frame.size.height - self.itemSize.height)/2, self.itemSize.width, self.frame.size.height-self.bottomLineWidth);
            menuItemView.frame = tempFrame;
            [self menuItemsFrameWithMenuItem:menuItemView];
            [self menuItemView:menuItemView index:index];
            [self setMenuItemViewBlock:menuItemView];
            [self addSubview:menuItemView];
        }
    }

}

-(UIView*) viewWithIndex:(NSInteger)index
{
    if (index >= 0 && index < self.menuItemViews.count) {
        
        UMComMenuItemView* view = self.menuItemViews[index];
        if (view) {
            return view.buton;
        }
        return nil;
    }
    return nil;
}

- (void)reloadItems
{
    if (self.menuItems.count == 0 || self.menuItemViews.count == 0) {
        return;
    }
    CGFloat itemSpace = 0;
    NSInteger spaceCount = self.menuItemViews.count + 1;
    itemSpace = (self.frame.size.width - self.leftMargin - self.rightMargin - self.itemSize.width * self.menuItemViews.count)/spaceCount;
    self.itemSpace = itemSpace;
    self.bottomLine.frame = CGRectMake(self.leftMargin+itemSpace, self.bottomLine.frame.origin.y, self.frame.size.width-self.leftMargin-self.rightMargin-itemSpace*2, self.bottomLine.frame.size.height);
    self.scrollIndicatorView.center = CGPointMake(self.leftMargin+itemSpace+self.itemSize.width/2, self.scrollIndicatorView.center.y);
    [self reloadAnyTypeOfMenuItems];
}


- (void)reloadAnyTypeOfMenuItems
{
    if (self.menuItems.count == 0 || self.menuItemViews.count == 0) {
        return;
    }
    CGFloat itemSpace = 0;
    NSInteger spaceCount = self.menuItemViews.count + 1;
    itemSpace = (self.frame.size.width - self.leftMargin - self.rightMargin - self.itemSize.width * self.menuItemViews.count)/spaceCount;
    self.itemSpace = itemSpace;
    for (int index = 0; index < self.menuItemViews.count; index ++) {
        UMComMenuItemView *menuItemView = self.menuItemViews[index];
        menuItemView.frame = [self itemFrameWithIndex:index];
        [self menuItemsFrameWithMenuItem:menuItemView];
        [self menuItemView:menuItemView index:index];
        [self setMenuItemViewBlock:menuItemView];
        [self addSubview:menuItemView];
    }
}

- (CGRect)itemFrameWithIndex:(NSInteger)index
{
    CGRect frame = CGRectMake(self.leftMargin + index*(self.itemSpace + self.itemSize.width) + self.itemSpace, (self.frame.size.height - self.itemSize.height)/2, self.itemSize.width, self.frame.size.height-self.bottomLineWidth);
    return frame;
}

- (void)menuItemsFrameWithMenuItem:(UMComMenuItemView *)itemView
{
    UMComMenuItemViewType itemType = itemView.menuItem.itemViewType;
    CGFloat topMargin = self.topMargin+self.bottomLineWidth;
    if (itemType == menuImageFullNoTitleType || itemType == menuDefaultType) {
        itemView.imageView.frame = CGRectMake(0, topMargin/2, self.itemSize.width, self.itemSize.height-topMargin);
    }else if (itemType == menuTitleFrontImageType){
        itemView.imageView.frame = CGRectMake(0, topMargin/2, self.itemSize.width, self.itemSize.height-topMargin);
    }else if (itemType == menuTitleFullNoImageType){
        itemView.imageView.hidden = YES;
        itemView.titleLabel.frame = CGRectMake(0, topMargin/2, self.itemSize.width, self.itemSize.height-topMargin);
    }else if(itemType == menuTitleBottomAndNoImage){
        itemView.titleLabel.frame = CGRectMake(0, topMargin/2, self.itemSize.width, self.itemSize.height-topMargin);
    }else if (itemType == menuTitleBottomAndImageTop){
        CGFloat titleHeight = self.itemSize.height/3;
        itemView.titleLabel.frame = CGRectMake(0, topMargin/2, self.itemSize.width, titleHeight);
        itemView.imageView.frame = CGRectMake(0, topMargin/2+itemView.titleLabel.frame.size.height, self.itemSize.width, self.itemSize.height - titleHeight-topMargin);
    }else if (itemType == menuTitleTopAndImageBottom){
        CGFloat titleHeight = self.itemSize.height*2/3;
        itemView.imageView.frame = CGRectMake(0, topMargin/2, self.itemSize.width, titleHeight);
        itemView.titleLabel.frame = CGRectMake(0, topMargin/2+itemView.titleLabel.frame.size.height, self.itemSize.width, self.itemSize.height - titleHeight-topMargin);
    }else if (itemType == menuTitleRightAndImageLeft){
        CGFloat imageWidth = self.itemSize.height;
        itemView.imageView.frame = CGRectMake(0, topMargin/2, imageWidth, imageWidth);
        itemView.titleLabel.frame = CGRectMake(imageWidth, topMargin/2, self.itemSize.width-imageWidth, self.itemSize.height-topMargin);
    }else if (itemType == menuTitleLeftAndImageRight){
        CGFloat imageWidth = self.itemSize.height;
        itemView.imageView.frame = CGRectMake(self.itemSize.width-imageWidth, topMargin/2, imageWidth, imageWidth);
        itemView.titleLabel.frame = CGRectMake(0, topMargin/2, self.itemSize.width-imageWidth, self.itemSize.height-topMargin);
    }
    else if (itemType == menuButtonType)
    {
        itemView.imageView.hidden = YES;
        NSString* imageName = itemView.menuItem.imageName;
        NSString* highLightImageName = itemView.menuItem.highLightImageName;
        if (imageName) {
            [itemView.buton setBackgroundImage:UMComImageWithImageName(imageName) forState:UIControlStateNormal];
        }
        if (highLightImageName) {
            [itemView.buton setBackgroundImage:UMComImageWithImageName(highLightImageName) forState:UIControlStateHighlighted];
            itemView.buton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
}

- (void)menuItemView:(UMComMenuItemView *)menuItemView index:(NSInteger)index
{
    if (self.isHighLightWhenDidSelected == YES) {
        if (self.selectedIndex == index) {
            [menuItemView highLight];
        }else{
            [menuItemView nomal];
        }
    }else{
        [menuItemView nomal];
    }
}

- (void)setMenuItemViewBlock:(UMComMenuItemView *)menuItemView
{
    __weak typeof(self) weakSelf = self;
    menuItemView.clickBlock = ^(UMComMenuItemView *menuItemView,NSInteger index){
        __weak typeof(weakSelf) strongSelf = self;
        weakSelf.lastIndex = weakSelf.selectedIndex;
        weakSelf.selectedIndex = index;
        if (weakSelf.isHighLightWhenDidSelected == YES) {
            [weakSelf reloadAnyTypeOfMenuItems];
        }
        [weakSelf scrollViewScrollToPageMenuItemView:menuItemView];
        if (weakSelf.selectedAtIndex) {
            weakSelf.selectedAtIndex(strongSelf, index);
        }
    };
}

- (void)scrollViewScrollToPageMenuItemView:(UMComMenuItemView *)menuItemView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.scrollIndicatorView.center = CGPointMake(menuItemView.center.x, weakSelf.scrollIndicatorView.center.y);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation UMComMenuItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textCorlor = [UIColor blackColor];
        self.highTextColor = [UIColor redColor];
        self.bgColor = [UIColor clearColor];
        self.highLightBgColor = [UIColor blueColor];
    }
    return self;
}

+ (UMComMenuItem *)itemWithTitle:(NSString *)title
                       imageName:(NSString *)imageName
{
    UMComMenuItem *item = [[UMComMenuItem alloc]init];
    item.title = title;
    item.imageName = imageName;
    return item;
}

+ (UMComMenuItem *)itemWithTitle:(NSString *)title
                       imageName:(NSString *)name
                   highLightType:(HighLightType)highLightType
                    itemViewType:(UMComMenuItemViewType)itemViewType
{
    UMComMenuItem *menuItem = [UMComMenuItem itemWithTitle:title imageName:name];
    menuItem.highLightType = highLightType;
    menuItem.itemViewType = itemViewType;
    return menuItem;
}

+ (UMComMenuItem *)itemWithTitle:(NSString *)title
                       imageName:(NSString *)name
              highLightImageName:(NSString *)highLightImageName
{
    UMComMenuItem *item = [UMComMenuItem itemWithTitle:title imageName:name];
    item.highLightImageName = highLightImageName;
    return item;
}

+ (UMComMenuItem *)itemWithTitle:(NSString *)title
                       imageName:(NSString *)name
                  highLightTitle:(NSString *)highLightTitle
              highLightImageName:(NSString *)highLightImageName
{
    UMComMenuItem *item = [UMComMenuItem itemWithTitle:title imageName:name];
    item.highLightTitle = highLightTitle;
    item.highLightImageName = highLightImageName;
    return item;
}

@end



@implementation UMComMenuItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickOnItem:)];
        [self addGestureRecognizer:tap];
        _titleLabel = [[UILabel alloc]initWithFrame:frame];
        _titleLabel.font = UMComFontNotoSansLightWithSafeSize(14);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _buton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _buton.frame = frame;
        _buton.backgroundColor = [UIColor clearColor];
        [_buton addTarget:self action:@selector(didClickOnItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buton];
    }
    return self;
}

+ (UMComMenuItemView *)menuItemViewWithMenuItem:(UMComMenuItem *)menuItem
{
    UMComMenuItemView *menuItemView = [[UMComMenuItemView alloc]initWithFrame:CGRectMake(0, 0, 1 , 1)];

    return menuItemView;
}

- (void)reloadWithTitle:(NSString *)title
                  image:(UIImage *)image
                  index:(NSInteger)index
{
    self.index = index;
    self.titleLabel.text = title;
    self.imageView.image = image;
}

- (void)reloadWithTitle:(NSString *)title
                  image:(UIImage *)image
{
    if (title) {
        self.titleLabel.text = title;
    }
    if (image) {
        self.imageView.image = image;
    }
}

- (void)highLight
{
    UMComMenuItem *item = self.menuItem;
    if (item.highLightType == HighLightText) {
        self.titleLabel.text = item.highLightTitle;
    }else if (item.highLightType == HighLightTextColor){
        self.titleLabel.textColor = item.highTextColor;
        self.titleLabel.text = item.title;
        self.backgroundColor = item.bgColor;
    }else if (item.highLightType == HighLightImage){
        self.titleLabel.text = item.title;
        self.imageView.image = UMComImageWithImageName(item.highLightImageName);
    }else if (item.highLightType == HighLightBgColor){
        self.titleLabel.text = item.title;
        self.backgroundColor = item.highLightBgColor;
    }
}

- (void)nomal
{
    UMComMenuItem *item = self.menuItem;
    self.titleLabel.text = item.title;
    self.titleLabel.textColor = item.textCorlor;
    self.imageView.image = UMComImageWithImageName(item.imageName);
    self.backgroundColor = item.bgColor;
}

- (void)didClickOnItem:(id)item
{
    if (self.clickBlock) {
        self.clickBlock(self,self.index);
    }
}

@end

