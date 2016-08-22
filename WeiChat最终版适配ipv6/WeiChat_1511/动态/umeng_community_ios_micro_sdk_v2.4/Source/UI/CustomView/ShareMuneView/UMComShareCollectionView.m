//
//  UMComCollectionView.m
//  UMCommunity
//
//  Created by umeng on 15-4-27.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComShareCollectionView.h"
#import "UMComTools.h"
#import "UMComSession.h"
#import "UMComFeed.h"
#import "UMComShareManager.h"

#define MaxShareLength 139
#define MaxLinkLength 10

@interface UMComShareCollectionView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *shareCollectionView;
@property (nonatomic, strong) NSArray *imageNameList;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *platformArray;

@end

@implementation UMComShareCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self resetSubViewsFrame];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}


- (void)resetSubViewsFrame
{

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation)){
            self.frame = CGRectMake(120, self.frame.size.width, self.frame.size.height,[UIScreen mainScreen].bounds.size.height);
            if (orientation == UIInterfaceOrientationLandscapeRight) {
                self.transform = CGAffineTransformMakeRotation(M_PI/2);
            }else{
                self.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }
        }
    }
    if (self.titleLabel) {
        [self.titleLabel removeFromSuperview];
    }
    if (self.shareCollectionView) {
        [self.shareCollectionView  removeFromSuperview];
    }
    CGFloat titleLabelHeight = 30;
    CGFloat cellWidth = self.frame.size.width/4.61;
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, titleLabelHeight)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    self.titleLabel.textColor = [UMComTools colorWithHexString:FontColorGray];
    self.titleLabel.text = UMComLocalizedString(@"share_to", @"分享至");
    [self addSubview:self.titleLabel];
    
    UICollectionViewFlowLayout *myLayout  = [[UICollectionViewFlowLayout alloc]init];
    myLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    myLayout.minimumInteritemSpacing = 2;
    myLayout.minimumLineSpacing = 2;
    myLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;;
    CGFloat shareViewOriginY = titleLabelHeight + (self.frame.size.height-titleLabelHeight)/2-cellWidth/2;
    self.shareCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, shareViewOriginY, self.frame.size.width, cellWidth) collectionViewLayout:myLayout];
    self.shareCollectionView.dataSource = self;
    self.shareCollectionView.delegate = self;
    self.shareCollectionView.backgroundColor  = [UIColor whiteColor];
    self.shareCollectionView.scrollsToTop = NO;
    [self.shareCollectionView registerClass:[UMComCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self addSubview:self.shareCollectionView];
    self.imageNameList = [NSArray arrayWithObjects:@"um_sina_logo",@"um_friend_logo",@"um_wechat_logo",@"um_qzone_logo",@"um_qq_logo", nil];
    
    self.titleList = @[@"新浪微博",@"朋友圈",@"微信",@"Qzone",@"QQ"];
}


- (void)reloadData
{
    [self.shareCollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageNameList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UMComCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UMComCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, collectionView.frame.size.height, collectionView.frame.size.height)];
    }
    cell.index = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.didSelectedIndex = ^(NSInteger index){
        if ([UMComShareManager shareInstance].shareHadleDelegate && [[UMComShareManager shareInstance].shareHadleDelegate respondsToSelector:@selector(didSelectPlatformAtIndex:feed:viewController:)]) {
            [[UMComShareManager shareInstance].shareHadleDelegate didSelectPlatformAtIndex:index feed:weakSelf.feed viewController:weakSelf.shareViewController];
            [weakSelf dismiss];
            if (weakSelf.didSelectedIndex) {
                weakSelf.didSelectedIndex(indexPath);
            }
        }else{
            NSLog(@"你没有实现分享代理方法");
        }
    };
    cell.portrait.image = UMComImageWithImageName(self.imageNameList[indexPath.row]);
    cell.titleLabel.text = self.titleList[indexPath.row];
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *platformName = [self.platformArray objectAtIndex:indexPath.row] ;
//    [[UMComLoginManager getLoginHandler] didSelectPlatform:platformName feed:self.feed viewController:self.shareViewController];
//    [self dismiss];
//    if (self.didSelectedIndex) {
//        self.didSelectedIndex(indexPath);
//    }
//}


- (void)shareViewShow
{
    [self removeFromSuperview];
    self.hidden = NO;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect  mainScreem = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat statusBarFrameHeight = 20;
    CGFloat originY = 0;
    //iOS 8 以上的bounds 会随着屏幕旋转而改变
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
//            mainScreem.size = CGSizeMake(mainScreem.size.height, mainScreem.size.width);
//        }
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            statusBarFrameHeight += statusBarFrameHeight;
        }
        originY = 20;
#endif
    }else{
        if (![UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            statusBarFrameHeight = 0;
        }else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
            statusBarFrameHeight = 20;
        }
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [backgroundView addGestureRecognizer:tapGesture];
    [window addSubview:backgroundView];
    [backgroundView addSubview:self];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        if (orientation == UIInterfaceOrientationPortrait){
            if (statusBarFrameHeight != 0) {
                statusBarFrameHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            }
            self.frame = CGRectMake(0, window.frame.size.height, self.frame.size.width,self.frame.size.height);
        }else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            self.frame = CGRectMake(0, -window.frame.size.height, self.frame.size.width,self.frame.size.height);
             if (statusBarFrameHeight != 0) {
                 statusBarFrameHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
             }
            self.transform = CGAffineTransformMakeRotation(M_PI);
        } else if (orientation == UIInterfaceOrientationLandscapeLeft){
            if (statusBarFrameHeight != 0) {
                statusBarFrameHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
            }
            self.frame = CGRectMake(window.frame.size.width,mainScreem.size.height-self.frame.size.height, window.frame.size.height,self.frame.size.height);
            self.transform = CGAffineTransformMakeRotation(-M_PI/2);
            
        }else if (orientation == UIInterfaceOrientationLandscapeRight){
            if (statusBarFrameHeight != 0) {
                statusBarFrameHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
            }
            self.frame = CGRectMake(-window.frame.size.height+self.frame.size.height+statusBarFrameHeight*2,0, window.frame.size.height,self.frame.size.height);
            self.transform = CGAffineTransformMakeRotation(M_PI/2);
        }else{
            self.frame = CGRectMake(self.frame.origin.x, window.frame.size.height-statusBarFrameHeight, self.frame.size.width,self.frame.size.height);
        }
    }else{
        self.frame = CGRectMake(0, mainScreem.size.height-originY,mainScreem.size.width, self.frame.size.height);
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                             if (orientation == UIInterfaceOrientationPortrait){
                                 self.frame = CGRectMake(self.frame.origin.x, window.frame.size.height-self.frame.size.height-statusBarFrameHeight, self.frame.size.width,self.frame.size.height);
                             }else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                                 self.frame = CGRectMake(self.frame.origin.x, statusBarFrameHeight, self.frame.size.width,self.frame.size.height);
                             }else if (orientation == UIInterfaceOrientationLandscapeLeft){
                                 self.frame = CGRectMake(window.frame.size.width-120-2*statusBarFrameHeight,self.frame.origin.y, self.frame.size.width,self.frame.size.height);
                             }else if (orientation == UIInterfaceOrientationLandscapeRight){
                                 self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
                             }else{
                                 self.frame = CGRectMake(self.frame.origin.x, window.frame.size.height-statusBarFrameHeight, self.frame.size.width,self.frame.size.height);
                             }
                         }else{
                             self.frame = CGRectMake(0, mainScreem.size.height-self.frame.size.height-statusBarFrameHeight, self.frame.size.width,self.frame.size.height);
                         }
                         
                     } completion:^(BOOL finished) {
                     }];

}

- (void)dismiss
{

    [UIView animateWithDuration:0.2 animations:^{
        self.hidden = YES;
//        self.transform = CGAffineTransformIdentity;
//        self.frame = CGRectMake(self.frame.origin.x, window.frame.size.height, self.parentView.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
        [self removeFromSuperview];
    }];
}


//- (void)layoutSubviews
//{
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
////        self.transform = CGAffineTransformIdentity;
////        [self dismiss];
////        [self shareViewShow];
//    }else{
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        CGRect applicationFrame = [[UIScreen mainScreen] bounds];
//        CGFloat originY = self.frame.origin.y;
//        
//        if (UIInterfaceOrientationIsLandscape(orientation)) {
//            //iOS 8以后applicationFrame的宽高的值会随着横竖屏而改变
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
//#endif
//            {
//                applicationFrame.size = CGSizeMake(applicationFrame.size.height, applicationFrame.size.width);
//            }
//            if (self.superview.frame.size.height > self.superview.frame.size.width) {
//                self.superview.frame = CGRectMake(0, 0, self.superview.frame.size.height,self.superview.frame.size.width);
//            }
//            originY += 20;
//        }
//        else{
//            if (self.superview.superview.frame.size.height > self.superview.superview.frame.size.width) {
//                self.superview.frame = CGRectMake(0, 0, self.superview.superview.frame.size.width, self.superview.superview.frame.size.height);
//            }
//        }
//        [self resetSubViewsFrame];
//    }
//
//}
//

@end





#pragma mark  -  cell init method
@implementation UMComCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageHeight = frame.size.height/3;
        CGFloat imageWidth = frame.size.height/3;

        CGFloat titleHeight = frame.size.height/3;
        CGFloat imageOriginY = (frame.size.height - imageWidth- titleHeight)/2-5;
        self.portrait = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-imageWidth)/2, imageOriginY, imageWidth, imageHeight)];
        [self.contentView addSubview:self.portrait];
        CGFloat imageBottomY = (frame.size.height-imageHeight-imageOriginY);
        CGFloat titleOriginY = (imageBottomY-titleHeight)/2+imageBottomY-3;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleOriginY, frame.size.width, titleHeight)];
        self.titleLabel.font = UMComFontNotoSansLightWithSafeSize(14);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UMComTools colorWithHexString:FontColorGray];
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedAtIndex)];
        [self.contentView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)didSelectedAtIndex
{
    if (self.didSelectedIndex) {
        self.didSelectedIndex(self.index);
    }
}


@end
