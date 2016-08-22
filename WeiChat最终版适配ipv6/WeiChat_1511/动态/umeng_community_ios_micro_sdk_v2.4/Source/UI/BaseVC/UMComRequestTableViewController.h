//
//  UMComDataRequestViewController.h
//  UMCommunity
//
//  Created by umeng on 15/11/16.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^LoadCoreDataCompletionHandler)(NSArray *data, NSError *error);
typedef void (^LoadSeverDataCompletionHandler)(NSArray *data, BOOL haveNextPage,NSError *error);
typedef void (^DataHandleFinish)();

@class UMComRequestTableViewController;
@class UMComTopFeedTableViewHelper;

@protocol UMComScrollViewDragDelegate <NSObject>

- (void)requestTableViewController:(UMComRequestTableViewController *)requestTableViewController refreshData:(void (^)())completion;

- (void)requestTableViewController:(UMComRequestTableViewController *)requestTableViewController loadMoreData:(void (^)())completion;

@end


@protocol UMComTableViewHandleDataDelegate1 <NSObject>

- (void)handleCoreDataDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler;

- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler;

- (void)handleLoadMoreDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler;

@end

@protocol UMComScrollViewDelegate;

@class UMComPullRequest, UMComStatusView;


@interface UMComRequestTableViewController : UITableViewController<UMComTableViewHandleDataDelegate1>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UILabel *noDataTipLabel;

@property (nonatomic, assign, readonly) CGPoint lastPosition;

@property (nonatomic, strong) UMComPullRequest *fetchRequest;

@property (nonatomic, assign) BOOL isAutoStartLoadData;

@property (nonatomic, assign) BOOL isLoadLoacalData;

@property (nonatomic, assign) BOOL haveNextPage;

@property (nonatomic, assign) BOOL isLoadFinish;

@property (nonatomic, assign) BOOL doNotShowNodataNote;


@property (nonatomic, strong) UMComStatusView *loadMoreStatusView;

@property (nonatomic, weak) id<UMComTableViewHandleDataDelegate1> handleDataDelegate;

@property (nonatomic, weak) id<UMComScrollViewDelegate> scrollViewDelegate;

@property (nonatomic, copy) LoadSeverDataCompletionHandler loadSeverDataCompletionHandler;

- (instancetype)initWithFetchRequest:(UMComPullRequest *)request;

#pragma mark - data
- (void)loadAllData:(LoadCoreDataCompletionHandler)coreDataHandler fromServer:(LoadSeverDataCompletionHandler)serverDataHandler;

- (void)fetchDataFromCoreData:(LoadCoreDataCompletionHandler)coreDataHandler;

- (void)refreshNewDataFromServer:(LoadSeverDataCompletionHandler)complection;

- (void)loadNextPageDataFromServer:(LoadSeverDataCompletionHandler)complection;

- (void)refreshData;

#pragma mark - views
- (void)relloadCellAtRow:(NSInteger)row section:(NSInteger)section;
- (void)insertCellAtRow:(NSInteger)row section:(NSInteger)section;
- (void)deleteCellAtRow:(NSInteger)row section:(NSInteger)section;
- (void)relloadCellAtIndextPath:(NSIndexPath *)indexPath;
- (void)insertRowsAtIndexPath:(NSIndexPath *)indePath;
- (void)deleteRowsAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - scrollView
- (BOOL)isBeginScrollBottom:(UIScrollView *)scrollView;
- (BOOL)isScrollToBottom:(UIScrollView *)scrollView;



@end


typedef enum{
    UMComNoLoad = 0,//还未加载
    UMComPreLoad = 1,//准备加载
    UMComLoading = 2,//正在加载
    UMComFinish = 3//完成加载
} UMComLoadStatus;


@interface UMComStatusView : UIView

@property (nonatomic, assign) BOOL isPull;

@property (nonatomic, assign) BOOL haveNextPage;

@property (nonatomic,retain) UILabel *statusLable;//显示状态信息

@property (nonatomic,retain) UIImageView *indicateImageView;//显示图片箭头图片

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;//透明指示器

@property (nonatomic,assign) UMComLoadStatus  loadStatus;

@property (nonatomic, strong) UIView *lineSpace;

- (void)hidenVews;

@end
