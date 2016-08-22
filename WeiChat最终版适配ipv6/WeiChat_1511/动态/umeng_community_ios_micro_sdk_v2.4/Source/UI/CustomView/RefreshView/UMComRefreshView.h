//
//  RefreshTableView.h
//  DJXRefresh
//
//  Created by Founderbn on 14-7-18.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    noLoad = 0,//还未加载
    preLoad = 1,//准备加载
    loading = 2,//正在加载
    finish = 3//完成加载
} LoadStatus;

typedef void(^RefreshDataLoadFinishHandler)(NSError *error);

@class UMComRefreshView, UMComLoadStatusView;

@protocol UMComRefreshViewDelegate <NSObject>

@optional

- (void)refreshData:(UMComRefreshView *)refreshView loadingFinishHandler:(RefreshDataLoadFinishHandler)handler;

- (void)loadMoreData:(UMComRefreshView *)refreshView loadingFinishHandler:(RefreshDataLoadFinishHandler)handler;

@end

@interface UMComRefreshView : NSObject

@property (nonatomic, strong) UMComLoadStatusView *headView;

@property (nonatomic, strong) UMComLoadStatusView *footView;

@property (nonatomic, weak) id <UMComRefreshViewDelegate>refreshDelegate;

@property (nonatomic, assign) CGFloat startLocation;

@property (nonatomic, strong) UIScrollView *refreshScrollView;

- (instancetype)initWithFrame:(CGRect)frame ScrollView:(UIScrollView *)scrollView;

- (void)refreshScrollViewDidScroll:(UIScrollView *)refreshScrollView haveNextPage:(BOOL)haveNextPage;

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)refreshScrollView haveNextPage:(BOOL)haveNextPage;

@end


@interface UMComLoadStatusView : UIView

@property (nonatomic, assign) BOOL isPull;

@property (nonatomic, assign) BOOL haveNextPage;

@property (nonatomic,retain) UILabel *dateLable;//显示上次刷新时间

@property (nonatomic,retain) UILabel *statusLable;//显示状态信息

@property (nonatomic,retain) UIImageView *indicateImageView;//显示图片箭头图片

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;//透明指示器
@property (nonatomic,assign) LoadStatus  loadStatus;

@property (nonatomic, strong) UIView *lineSpace;

- (void)hidenVews;

@end
