
//
//  UMComDataRequestViewController.m
//  UMCommunity
//
//  Created by umeng on 15/11/16.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComRequestTableViewController.h"
#import "UMComPullRequest.h"
#import "UMComScrollViewDelegate.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSession.h"
#import "UMComShowToast.h"

@interface UMComRequestTableViewController ()<UITableViewDelegate, UITableViewDataSource, UMComTableViewHandleDataDelegate1, UMComScrollViewDelegate>

@property (nonatomic, assign) CGPoint lastPosition;

@end

@implementation UMComRequestTableViewController

- (instancetype)initWithFetchRequest:(UMComPullRequest *)request
{
    self = [self init];
    if (self) {
        self.fetchRequest = request;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoadLoacalData = YES;
        self.isLoadFinish = YES;
        self.isAutoStartLoadData = YES;
    }
    return self;
}

- (BOOL)haveNextPage
{
    return self.fetchRequest.isHaveNextPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadFinish = YES;

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.clearsSelectionOnViewWillAppear = YES;
    self.refreshControl = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];

    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉可以刷新"]];
    
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    self.loadMoreStatusView = [[UMComStatusView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.tableView.tableFooterView addSubview:self.loadMoreStatusView];
    self.tableView.separatorColor = UMComColorWithColorValueString(UMCom_Feed_BgColor);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    self.handleDataDelegate = self;
    self.scrollViewDelegate = self;
    
    [self setForumUIBackButton];
    [self setForumUITitle:self.title];
}

- (void)creatNoFeedTip
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-40, self.view.frame.size.width,40)];
    label.backgroundColor = [UIColor clearColor];
    label.text = UMComLocalizedString(@"No_Data", @"内容为空");
    label.font = UMComFontNotoSansLightWithSafeSize(17);
    label.textColor = [UMComTools colorWithHexString:FontColorGray];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    label.hidden = YES;
    [self.view addSubview:label];
    self.noDataTipLabel = label;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.noDataTipLabel && self.doNotShowNodataNote == NO) {
        [self creatNoFeedTip];
    }
    if (self.fetchRequest && self.isAutoStartLoadData && self.dataArray.count == 0) {
        if (self.isLoadLoacalData) {
            [self loadAllData:nil fromServer:nil];
        }else{
            [self refreshNewDataFromServer:nil];
        }
    }
    // 未登录时发送请求可能会不断收到未登录错误码而不断弹出登录
    // 修改为第一次加载后开始手动下拉刷新加载
    self.isAutoStartLoadData = NO;
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count > 0) {
        self.noDataTipLabel.hidden = YES;
        if (self.dataArray.count >= self.fetchRequest.fetchRequest.fetchLimit || self.haveNextPage) {
            self.loadMoreStatusView.hidden = NO;
            if (!self.haveNextPage) {
                [self.loadMoreStatusView setLoadStatus:UMComFinish];
            }
        }else {
            self.loadMoreStatusView.hidden = YES;
        }
    }else{
        self.loadMoreStatusView.hidden = YES;
        self.noDataTipLabel.hidden = NO;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

#pragma mark -

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
    if (scrollView.contentOffset.y>0 && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.bounds.size.height-65)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)refreshScrollView haveNextPage:(BOOL)haveNextPage
{
    self.loadMoreStatusView.haveNextPage = haveNextPage;
    //上拉加载
    if ([self isScrollToBottom:refreshScrollView] && self.loadMoreStatusView.loadStatus != UMComLoading &&  self.refreshControl.refreshing != YES && haveNextPage == YES) {
        self.loadMoreStatusView.hidden = NO;
        //执行代理方法
        [self.loadMoreStatusView setLoadStatus:UMComLoading];
        [self loadMoreData];
        
    }else if (haveNextPage == NO && refreshScrollView.contentSize.height > refreshScrollView.frame.size.height && self.loadMoreStatusView.loadStatus != UMComLoading){
        [self.loadMoreStatusView setLoadStatus:UMComFinish];
    }else if (haveNextPage == NO){
        [self.loadMoreStatusView setLoadStatus:UMComFinish];
    }
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)refreshScrollView haveNextPage:(BOOL)haveNextPage
{
    if (refreshScrollView.contentOffset.y < -150 && !self.refreshControl.refreshing) {
        [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手即可刷新"]];
    }else if (refreshScrollView.contentOffset.y < 0){
        if (self.isLoadFinish) {
            [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉可以刷新"]];
        }else{
            [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"正在刷新"]];
        }
    }
    self.loadMoreStatusView.haveNextPage = haveNextPage;
    //上拉
    if ([self isBeginScrollBottom:refreshScrollView] && [refreshScrollView isDragging] && self.loadMoreStatusView.loadStatus != UMComLoading && self.refreshControl.refreshing != YES && haveNextPage == YES) {//
        [self.loadMoreStatusView setLoadStatus:UMComNoLoad];
        if ([self isScrollToBottom:refreshScrollView]){
            [self.loadMoreStatusView setLoadStatus:UMComPreLoad];
        }
    }
    else if (self.loadMoreStatusView.loadStatus != UMComLoading && self.loadMoreStatusView.loadStatus != UMComFinish){
        if (haveNextPage == YES) {
            if ([self isScrollToBottom:refreshScrollView]){
                [self.loadMoreStatusView setLoadStatus:UMComPreLoad];
                self.loadMoreStatusView.indicateImageView.transform = CGAffineTransformIdentity;
            }
        }else{
            [self.loadMoreStatusView setLoadStatus:UMComFinish];
        }
    }else if (refreshScrollView.contentOffset.y <= 0){
        [self.loadMoreStatusView hidenVews];
    }else if (haveNextPage == NO){
        [self.loadMoreStatusView setLoadStatus:UMComFinish];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshScrollViewDidScroll:scrollView haveNextPage:self.haveNextPage];
    if (self.isLoadFinish && self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewDidScroll:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewDidScroll:scrollView lastPosition:self.lastPosition];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.lastPosition = scrollView.contentOffset;
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewDidEnd:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewDidEnd:scrollView lastPosition:self.lastPosition];
    }
    self.lastPosition = scrollView.contentOffset;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self refreshScrollViewDidEndDragging:scrollView haveNextPage:self.haveNextPage];
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(customScrollViewEndDrag:lastPosition:)]) {
        [self.scrollViewDelegate customScrollViewEndDrag:scrollView lastPosition:self.lastPosition];
    }
    self.lastPosition = scrollView.contentOffset;
}


#pragma mark - UMComRefreshTableViewDelegate

- (void)refreshData
{
    [self refreshNewDataFromServer:nil];
}

- (void)loadMoreData
{
    [self loadNextPageDataFromServer:nil];
}


#pragma mark - Data Request
- (void)loadAllData:(LoadCoreDataCompletionHandler)coreDataHandler fromServer:(LoadSeverDataCompletionHandler)complection
{
    __weak typeof(self) weakSelf = self;
    [self fetchDataFromCoreData:^(NSArray *data, NSError *error) {
        if (coreDataHandler) {
            coreDataHandler(data, error);
        }
        [weakSelf refreshNewDataFromServer:complection];
    }];
}

- (void)fetchDataFromCoreData:(LoadCoreDataCompletionHandler)coreDataHandler
{
    if (!self.fetchRequest) {
        [self.refreshControl endRefreshing];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.fetchRequest fetchRequestFromCoreData:^(NSArray *data, NSError *error) {
        if (coreDataHandler) {
            coreDataHandler(data,error);
        }
        if (weakSelf.handleDataDelegate && [weakSelf.handleDataDelegate respondsToSelector:@selector(handleCoreDataDataWithData:error:dataHandleFinish:)]) {
            [weakSelf.handleDataDelegate handleCoreDataDataWithData:data error:error dataHandleFinish:^{
                [weakSelf.tableView reloadData];
            }];
        }
    }];
}

- (void)refreshNewDataFromServer:(LoadSeverDataCompletionHandler)complection
{
    if (!self.fetchRequest) {
        [self.refreshControl endRefreshing];
        return;
    }
    if (self.isLoadFinish == NO) {
        return;
    }
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"正在刷新"]];
    [self.refreshControl beginRefreshing];
    self.isLoadFinish = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    [self.fetchRequest fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        [UMComShowToast showFetchResultTipWithError:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [weakSelf.refreshControl endRefreshing];
        weakSelf.isLoadFinish = YES;
        if (complection) {
            complection(data, haveNextPage, error);
        }
        if (weakSelf.loadSeverDataCompletionHandler) {
            weakSelf.loadSeverDataCompletionHandler(data, haveNextPage, error);
        }
        if (weakSelf.dataArray.count == 0 && data.count == 0) {
            weakSelf.loadMoreStatusView.hidden = YES;
        }
        if (!error) {
            if (data.count > 0) {
                weakSelf.noDataTipLabel.hidden = YES;
            }else{
                weakSelf.noDataTipLabel.hidden = NO;
            }
        }else{
            weakSelf.noDataTipLabel.hidden = YES;
        }
        [weakSelf.handleDataDelegate handleServerDataWithData:data error:error dataHandleFinish:^{
            [weakSelf.tableView reloadData];

        }];
    }];
}

- (void)loadNextPageDataFromServer:(LoadSeverDataCompletionHandler)complection
{
    if (!self.fetchRequest || !self.haveNextPage) {
        [self.loadMoreStatusView setLoadStatus:UMComFinish];
        [self.refreshControl endRefreshing];
        return;
    }
    if (self.isLoadFinish == NO) {
        return;
    }
    self.isLoadFinish = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    __weak typeof(self) weakSelf = self;
    [self.fetchRequest fetchNextPageFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        [UMComShowToast showFetchResultTipWithError:error];
        [weakSelf.loadMoreStatusView setLoadStatus:UMComFinish];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        weakSelf.isLoadFinish = YES;
        [weakSelf.refreshControl endRefreshing];
        if (complection) {
            complection(data, haveNextPage, error);
        }
        if (weakSelf.handleDataDelegate && [weakSelf.handleDataDelegate respondsToSelector:@selector(handleLoadMoreDataWithData:error:dataHandleFinish:)]) {
            [weakSelf.handleDataDelegate handleLoadMoreDataWithData:data error:error dataHandleFinish:^{
                [weakSelf.tableView reloadData];
            }];
        };
    }];
}


#pragma mark - data handle

- (void)handleCoreDataDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        self.dataArray = data;
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        self.dataArray = data;
    }
    else
    {
        //提示用户
        [UMComShowToast showFetchResultTipWithError:error];
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (void)handleLoadMoreDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
        [tempArray addObjectsFromArray:data];
        self.dataArray = tempArray;
    }
    if (finishHandler) {
        finishHandler();
    }
}

#pragma mark - updata insert delele indexPath
- (void)relloadCellAtRow:(NSInteger)row section:(NSInteger)section
{
    if (row < 0 ||section < 0) {
        return;
    }
    if (row < self.dataArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self relloadCellAtIndextPath:indexPath];
    }
}

- (void)insertCellAtRow:(NSInteger)row section:(NSInteger)section
{
    if (row < 0 ||section < 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self insertRowsAtIndexPath:indexPath];
}

- (void)deleteCellAtRow:(NSInteger)row section:(NSInteger)section
{
    if (row < 0 ||section < 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self deleteRowsAtIndexPath:indexPath];
}

- (void)relloadCellAtIndextPath:(NSIndexPath *)indexPath
{
    if ([indexPath isKindOfClass:[NSIndexPath class]] && [self.tableView cellForRowAtIndexPath:indexPath]) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableView reloadData];
    }
}

- (void)insertRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isKindOfClass:[NSIndexPath class]] && [self.tableView cellForRowAtIndexPath:indexPath]) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
- (void)deleteRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isKindOfClass:[NSIndexPath class]] && [self.tableView cellForRowAtIndexPath:indexPath]) {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@implementation UMComStatusView

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
        CGFloat statusLableHeight = defualtHeight;
        CGFloat commonLabelOriginX = 60;
        self.statusLable = [[UILabel alloc]initWithFrame:CGRectMake(commonLabelOriginX, height-defualtHeight-5, width-commonLabelOriginX*2, statusLableHeight)];
        self.statusLable.textAlignment = NSTextAlignmentCenter;
        self.statusLable.font = UMComFontNotoSansLightWithSafeSize(15);
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.frame = CGRectMake(10, height-(defualtHeight-(defualtHeight-40)/2), 40, 40);
        self.indicateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, height-(defualtHeight-(defualtHeight-40)/2), 15, 35)];
        self.statusLable.backgroundColor = [UIColor clearColor];
        self.indicateImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.statusLable];
        [self addSubview:self.indicateImageView];
        [self addSubview:self.activityIndicatorView];
        self.isPull = NO;
        self.loadStatus = UMComNoLoad;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIsPull:(BOOL)isPull
{
    _isPull = isPull;
    if (isPull == NO) {
        self.statusLable.frame = CGRectMake(60, 0, self.frame.size.width-120, self.frame.size.height);
        self.activityIndicatorView.frame = CGRectMake(10, (self.frame.size.height - 40)/2, 40, 40);
        self.indicateImageView.frame= CGRectMake(20,(self.frame.size.height - 35)/2, 15, 35);
        self.lineSpace.hidden = YES;
    }
}

- (void)setLoadStatus:(UMComLoadStatus)loadStatus
{
    _loadStatus = loadStatus;
    [self setLoadStatus:loadStatus IsPull:self.isPull];
}

- (void)setLoadStatus:(UMComLoadStatus)loadStatus IsPull:(BOOL)isPull
{
    if (!upImage) {
        upImage = UMComImageWithImageName(@"grayArrow1");
    }
    UIImage *downImage = [self image:upImage rotation:UIImageOrientationDown];
    switch (loadStatus) {
        case UMComNoLoad:
        {
            self.indicateImageView.hidden = NO;
            self.statusLable.hidden = NO;
            if (isPull) {
                self.statusLable.text = UMComLocalizedString(@"Pull down", @"下拉刷新");
                self.indicateImageView.image = upImage;
            }else{
                self.statusLable.text = UMComLocalizedString(@"Pull up", @"上拉可以加载更多");
                self.indicateImageView.image = downImage;
            }
        }
            break;
        case UMComPreLoad:
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
        case UMComLoading:
        {
            self.statusLable.text = UMComLocalizedString(@"Loading", @"正在加载") ;
            self.indicateImageView.hidden = YES;
            self.indicateImageView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView startAnimating];
        }
            break;
        case UMComFinish:
        {
            [self.activityIndicatorView stopAnimating];
            self.indicateImageView.hidden = YES;
            self.statusLable.hidden = NO;
            if (isPull) {
                self.statusLable.text = UMComLocalizedString(@"Refresh Finish", @"刷新完成") ;
            }else if (_haveNextPage == NO){
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
    [self.activityIndicatorView stopAnimating];
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
