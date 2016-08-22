//
//  RefreshTableView.m
//  DJXRefresh
//
//  Created by Founderbn on 14-7-18.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//

#import "UMComRefreshView.h"
#import "UMComTools.h"
#import "UMComSession.h"

@interface UMComRefreshView ()

@property (nonatomic,assign) CGFloat beginPullHeight;/*达到松手即可刷新的高度 默认为65.0f*/
@end



@implementation UMComRefreshView

- (instancetype)initWithFrame:(CGRect)frame ScrollView:(UIScrollView *)scrollView
{
    self = [super init];
    if (self) {
        self.refreshScrollView = scrollView;
        self.beginPullHeight = 65;
        [self setHeadViewWithFrame:frame];
        [self setFootViewWithFrame:frame];
    }
    return self;
}

- (void)setRefreshScrollView:(UIScrollView *)refreshScrollView
{
    _refreshScrollView = refreshScrollView;
    self.startLocation = refreshScrollView.frame.origin.y;
    self.refreshDelegate = (id)refreshScrollView;
}

- (UMComLoadStatusView *)loadStatusViewWithFrame:(CGRect)frame isPull:(BOOL)isPull
{
    CGFloat height = kUMComRefreshOffsetHeight;
    if (isPull == NO) {
        height = kUMComLoadMoreOffsetHeight;
    }
    UMComLoadStatusView *loadStatusView = [[UMComLoadStatusView alloc]initWithFrame:CGRectMake(0, frame.size.height - height -5 , frame.size.width, height)];
    [loadStatusView hidenVews];
    loadStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    loadStatusView.isPull = isPull;
    return loadStatusView;
}

- (void)setHeadViewWithFrame:(CGRect)frame
{
    UMComLoadStatusView *headView = [self loadStatusViewWithFrame:frame isPull:YES];
    self.headView = headView;
}

- (void)setFootViewWithFrame:(CGRect)frame
{
    UMComLoadStatusView *footView = [self loadStatusViewWithFrame:frame isPull:NO];
    self.footView = footView;
}

#pragma mark -
- (void)refreshScrollViewDidScroll:(UIScrollView *)refreshScrollView haveNextPage:(BOOL)haveNextPage
{
    self.footView.haveNextPage = haveNextPage;
    self.headView.haveNextPage = haveNextPage;
    //下拉
    if (refreshScrollView.contentOffset.y < 0 && self.headView.loadStatus != loading && self.footView.loadStatus != loading) {
        [self.headView setLoadStatus:noLoad];
        if (refreshScrollView.contentOffset.y < -self.beginPullHeight && self.headView.loadStatus != loading && self.footView.loadStatus != loading) {
            [self.headView setLoadStatus:preLoad];
        }
    }else if (self.headView.loadStatus != loading && self.headView.loadStatus != finish){
        refreshScrollView.frame = CGRectMake(refreshScrollView.frame.origin.x, self.startLocation, refreshScrollView.frame.size.width, refreshScrollView.frame.size.height);
        [self.headView setLoadStatus:noLoad];
        self.headView.indicateImageView.transform = CGAffineTransformIdentity;
    }
    //上拉
    if ([self isBeginScrollBottom:refreshScrollView] && [refreshScrollView isDragging] && self.headView.loadStatus != loading && self.footView.loadStatus != loading && haveNextPage == YES) {//
        [self.footView setLoadStatus:noLoad];
        if ([self isScrollToBottom:refreshScrollView]){
          [self.footView setLoadStatus:preLoad];
        }
    }
    else if (self.footView.loadStatus != loading && self.footView.loadStatus != finish){
        if (haveNextPage == YES) {
            [self.footView setLoadStatus:noLoad];
            self.footView.indicateImageView.transform = CGAffineTransformIdentity;
        }else{
            [self.footView setLoadStatus:finish];
        }
    }else if (refreshScrollView.contentOffset.y <= 0){
         [self.footView hidenVews];
    }else if (haveNextPage == NO){
        [self.footView setLoadStatus:finish];
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)refreshScrollView haveNextPage:(BOOL)haveNextPage
{
    self.footView.haveNextPage = haveNextPage;
    self.headView.haveNextPage = haveNextPage;
    if (self.headView.loadStatus !=loading && self.footView.loadStatus != loading && (refreshScrollView.contentOffset.y<-self.beginPullHeight)) {
       // 执行代理方法
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(refreshData:loadingFinishHandler:)]) {
            [self.headView setLoadStatus:loading];
            refreshScrollView.frame = CGRectMake(refreshScrollView.frame.origin.x, self.startLocation+kUMComLoadMoreOffsetHeight, refreshScrollView.frame.size.width, refreshScrollView.frame.size.height);
            [self.refreshDelegate refreshData:self loadingFinishHandler:^(NSError *error) {
                [self.headView setLoadStatus:finish];
                [self.footView setLoadStatus:noLoad];
                [UIView animateWithDuration:0.5 animations:^{
                    refreshScrollView.frame = CGRectMake(refreshScrollView.frame.origin.x, self.startLocation, refreshScrollView.frame.size.width, refreshScrollView.frame.size.height);
                } completion:^(BOOL finished) {

                }];
            }];
        }else{
            [self.headView setLoadStatus:finish];
        }
    }
    //上拉加载
    if ([self isScrollToBottom:refreshScrollView] && self.headView.loadStatus != loading &&  self.footView.loadStatus != loading && haveNextPage == YES) {
        //执行代理方法
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(loadMoreData:loadingFinishHandler:)]) {
            [self.footView setLoadStatus:loading];
            [self.refreshDelegate loadMoreData:self loadingFinishHandler:^(NSError *error) {
                [self.footView setLoadStatus:finish];
                [self.headView setLoadStatus:noLoad];
                [UIView animateWithDuration:0.5 animations:^{
                    refreshScrollView.frame = CGRectMake(refreshScrollView.frame.origin.x,self.startLocation, refreshScrollView.frame.size.width, refreshScrollView.frame.size.height);
                } completion:^(BOOL finished) {
                }];
            }];
            
        }else{
            [self.footView setLoadStatus:finish];
        }

    }else if (haveNextPage == NO && refreshScrollView.contentSize.height > refreshScrollView.frame.size.height && self.footView.loadStatus != loading){
        [self.footView setLoadStatus:finish];
    }else if (haveNextPage == NO){
        [self.footView setLoadStatus:finish];
    }
}


- (BOOL)isBeginScrollBottom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0 && scrollView.contentSize.height >scrollView.frame.size.height && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.bounds.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isScrollToBottom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0 && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.bounds.size.height-50)) {
        return YES;
    }else{
        return NO;
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@interface UMComLoadStatusView ()

@property (nonatomic,copy) NSString *lastRefreshTime;

@end

@implementation UMComLoadStatusView

{
    UIImage *upImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat defualtHeight = 50;
        CGFloat height = frame.size.height;
        CGFloat width = frame.size.width;
        CGFloat dateLabelHeight = defualtHeight /3;
        CGFloat statusLableHeight = defualtHeight - dateLabelHeight;
        CGFloat commonLabelOriginX = 60;
        self.statusLable = [[UILabel alloc]initWithFrame:CGRectMake(commonLabelOriginX, height-defualtHeight-5, width-commonLabelOriginX*2, statusLableHeight)];
        self.dateLable = [[UILabel alloc]initWithFrame:CGRectMake(commonLabelOriginX,self.statusLable.frame.size.height+self.statusLable.frame.origin.y, width-commonLabelOriginX*2, dateLabelHeight)];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.frame = CGRectMake(10, height-(defualtHeight-(defualtHeight-40)/2), 40, 40);
        self.indicateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, height-(defualtHeight-(defualtHeight-40)/2), 15, 35)];
        self.statusLable.backgroundColor = [UIColor clearColor];
        self.dateLable.backgroundColor = [UIColor clearColor];
        self.statusLable.font = UMComFontNotoSansLightWithSafeSize(15);
        self.dateLable.font = UMComFontNotoSansLightWithSafeSize(10);
        self.statusLable.textAlignment = NSTextAlignmentCenter;
        self.dateLable.textAlignment = NSTextAlignmentCenter;
        self.statusLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.dateLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.indicateImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.dateLable];
        [self addSubview:self.statusLable];
        [self addSubview:self.indicateImageView];
        [self addSubview:self.activityIndicatorView];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.isPull = YES;
        self.loadStatus = noLoad;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.isPull = YES;
        UIView *lineSpace = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height -0.5, self.frame.size.width, 0.5)];
        lineSpace.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lineSpace.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1];
        [self addSubview:lineSpace];
        self.lineSpace = lineSpace;

    }
    return self;
}

- (void)setIsPull:(BOOL)isPull
{
    _isPull = isPull;
    if (isPull == NO) {
        self.dateLable.hidden = YES;
        self.statusLable.frame = CGRectMake(60, 0, self.frame.size.width-120, self.frame.size.height);
        self.activityIndicatorView.frame = CGRectMake(10, (self.frame.size.height - 40)/2, 40, 40);
        self.indicateImageView.frame= CGRectMake(20,(self.frame.size.height - 35)/2, 15, 35);
        self.lineSpace.hidden = YES;
    }
}

- (void)setLoadStatus:(LoadStatus)loadStatus
{
    _loadStatus = loadStatus;
    [self setLoadStatus:loadStatus IsPull:self.isPull];
}

- (void)setLoadStatus:(LoadStatus)loadStatus IsPull:(BOOL)isPull
{
    if (!upImage) {
        upImage = UMComImageWithImageName(@"grayArrow1");
    }
    UIImage *downImage = [self image:upImage rotation:UIImageOrientationDown];
    switch (loadStatus) {
        case noLoad:
        {
            self.indicateImageView.hidden = NO;
            self.statusLable.hidden = NO;
            if (isPull) {
                self.dateLable.hidden = NO;
                self.statusLable.text = UMComLocalizedString(@"Pull down", @"下拉刷新");
                self.indicateImageView.image = upImage;
                if (self.lastRefreshTime) {
                    self.dateLable.text = self.lastRefreshTime;
                }else{
                    
                    self.dateLable.text = [self nowDateString];
                }
                self.lastRefreshTime = [self nowDateString];
            }else{
                self.statusLable.text = UMComLocalizedString(@"Pull up", @"上拉可以加载更多");
                self.indicateImageView.image = downImage;
            }
        }
            break;
        case preLoad:
        {
            self.indicateImageView.hidden = NO;
            if (isPull) {
                [self setRotation:-2 animated:YES];
                self.statusLable.text = UMComLocalizedString(@"Pull down later", @"松手即可刷新");
            }else{
                [self setRotation:2 animated:YES];
                self.statusLable.text = UMComLocalizedString(@"Pull up later", @"松手即可加载更多");
            }
        }
            break;
        case loading:
        {
            self.statusLable.text = UMComLocalizedString(@"Loading", @"正在加载") ;
            self.indicateImageView.hidden = YES;
            self.indicateImageView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView startAnimating];
        }
            break;
        case finish:
        {
            [self.activityIndicatorView stopAnimating];
            self.indicateImageView.hidden = YES;
            self.statusLable.hidden = NO;
            if (isPull) {
                self.statusLable.text = UMComLocalizedString(@"Refresh Finish", @"刷新完成") ;
            }else if (_haveNextPage == NO && [UMComSession sharedInstance].uid){
                self.statusLable.text = UMComLocalizedString(@"Loading Last Page", @"已经是最后一页了");
            }else{
                self.statusLable.text = UMComLocalizedString(@"Loading Finish", @"加载完成");
            }
            self.indicateImageView.transform = CGAffineTransformIdentity;
        }
            break;
        default:
            break;
    }
}

- (void)hidenVews
{
    self.statusLable.hidden = YES;
    self.indicateImageView.hidden = YES;
    self.dateLable.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


- (NSString *)nowDateString
{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc]init];
    NSCalendar *calendar =
    [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [formatter setCalendar:calendar];
    [formatter setDateFormat:@"HH:mm:ss"];//yyyy-MM-dd HH:mm:ss
    NSString *todayTime = [formatter stringFromDate:today];
    if (todayTime) {
        return [NSString stringWithFormat:UMComLocalizedString(@"Last Refresh Time", @"上次下拉刷新时间：%@"),todayTime];
    }
    return nil;
}

- (void)setRotation:(NSInteger)rotation animated:(BOOL)animated
{
    if (rotation < -4)
        rotation = 4 - abs((int)rotation);
    if (rotation > 4)
        rotation = rotation - 4;
    if (animated)
    {
        [UIView animateWithDuration:0.1 animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation * M_PI / 2);
            self.indicateImageView.transform = rotationTransform;
        } completion:^(BOOL finished) {
        }];
    } else
    {
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation * M_PI / 2);
        self.indicateImageView.transform = rotationTransform;
    }
}

-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}

@end

