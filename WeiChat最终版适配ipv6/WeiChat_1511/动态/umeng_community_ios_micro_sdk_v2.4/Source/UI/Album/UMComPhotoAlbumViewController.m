//
//  UMComPhotoAlbumViewController.m
//  UMCommunity
//
//  Created by umeng on 15/7/7.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComPhotoAlbumViewController.h"
#import "UMComImageView.h"
#import "UMComPullRequest.h"
#import "UMComAlbum+UMComManagedObject.h"
#import "UMComGridViewerController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComRefreshView.h"
#import "UMComUser.h"
#import "UMComImageUrl.h"
#import "UMComShowToast.h"

typedef void (^AlbumLoadCompletionHandler)(NSArray *data, NSError *error);

const CGFloat A_WEEK_SECONDES = 60*60*24*7;


@interface UMComPhotoAlbumViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UMComRefreshViewDelegate>

@property (nonatomic, strong) UICollectionView *albumCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UMComUserAlbumRequest *albumRequest;

@property (nonatomic, strong) NSArray *imageModelsArray;

@property (nonatomic, strong) UMComRefreshView *refreshViewController;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UILabel *noDataTipLabel;

@property (nonatomic, assign) BOOL haveNextPage;

@property (nonatomic,strong) UIView* emptyView;//无内容时候显示的view

-(void) createEmptyView;


@end

@implementation UMComPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithTitle:UMComLocalizedString(@"My_album", @"相册")];
    UMComUserAlbumRequest *albumRequest = [[UMComUserAlbumRequest alloc]initWithCount:BatchSize fuid:self.user.uid];
    self.albumRequest = albumRequest;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection =UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, kUMComRefreshOffsetHeight);
    layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, kUMComLoadMoreOffsetHeight);
    self.layout = layout;
    self.albumCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -kUMComRefreshOffsetHeight, self.view.frame.size.width, self.view.frame.size.height+kUMComRefreshOffsetHeight) collectionViewLayout:layout];
    self.albumCollectionView.backgroundColor = [UIColor whiteColor];
    self.albumCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    [self.albumCollectionView registerClass:[UMComPhotoAlbumCollectionCell class] forCellWithReuseIdentifier:@"PhotoAlbumCollectionCell"];
    [self.view addSubview:self.albumCollectionView];

    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.indicatorView];
    
    self.refreshViewController = [[UMComRefreshView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kUMComRefreshOffsetHeight) ScrollView:self.albumCollectionView];
    self.refreshViewController.refreshDelegate = self;
    
    [self.albumCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];//注册header的view
    [self.albumCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];//注册footView的view

    __weak typeof(self) weakSelf = self;
    [self fecthCoreDataImageUrlList:^(NSArray *data, NSError *error) {
        [weakSelf fecthRemoteImageUrlList:nil];
    }];
    
    [self createEmptyView];
    
    // Do any additional setup after loading the view from its nib.
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
    self.albumCollectionView.delegate = self;
    self.albumCollectionView.dataSource = self;
    CGFloat itemWidth = (self.view.frame.size.width-8)/3;
    self.layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    [self.albumCollectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)fecthCoreDataImageUrlList:(AlbumLoadCompletionHandler)handler
{
    [self.indicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    [self.albumRequest fetchRequestFromCoreData:^(NSArray *data, NSError *error) {
    
        if (!error && [data isKindOfClass:[NSArray class]]) {
            weakSelf.imageModelsArray = [weakSelf imageModelsWithData:data];
        }
        if (data.count > 0) {
            [weakSelf.indicatorView stopAnimating];
        }
        [weakSelf.albumCollectionView reloadData];
        if (handler) {
            handler(data, error);
        }
    }];
}

- (void)fecthRemoteImageUrlList:(AlbumLoadCompletionHandler)handler
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __weak typeof(self) weakSelf = self;
    [self.albumRequest fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        [UMComShowToast showFetchResultTipWithError:error];
        if (!error && [data isKindOfClass:[NSArray class]] && data.count <= 0) {
            weakSelf.emptyView.hidden = NO;
        }
        else{
            weakSelf.emptyView.hidden = YES;
        }
        [weakSelf.indicatorView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        weakSelf.haveNextPage = haveNextPage;
        if (!error && [data isKindOfClass:[NSArray class]]) {
            weakSelf.imageModelsArray = [weakSelf imageModelsWithData:data];
        }
        [weakSelf.albumCollectionView reloadData];
        if (handler) {
            handler(data, error);
        }
    }];
}


- (void)fecthNextPage:(AlbumLoadCompletionHandler)handler
{
    __weak typeof(self) weakSelf = self;
    [self.albumRequest fetchNextPageFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        [UMComShowToast showFetchResultTipWithError:error];
        weakSelf.haveNextPage = haveNextPage;
        if (!error) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakSelf.imageModelsArray];
            [tempArr addObjectsFromArray:[weakSelf imageModelsWithData:data]];
            weakSelf.imageModelsArray = tempArr;
        }
        [weakSelf.albumCollectionView reloadData];
        if (handler) {
            handler(data, error);
        }
    }];
}

- (NSArray *)imageModelsWithData:(NSArray *)data
{
    NSMutableArray *imageModels = [NSMutableArray array];
    for (UMComAlbum *album in data) {
        if (album.image_urls.count > 0) {
            [imageModels addObjectsFromArray:album.image_urls.array];
        }
    }
    return imageModels;
}

#pragma mark - UMComRefreshViewDelegate
- (void)refreshData:(UMComRefreshView *)refreshView loadingFinishHandler:(RefreshDataLoadFinishHandler)handler
{
    [self fecthRemoteImageUrlList:^(NSArray *data, NSError *error) {
        if (handler) {
            handler(error);
        }
    }];
}

- (void)loadMoreData:(UMComRefreshView *)refreshView loadingFinishHandler:(RefreshDataLoadFinishHandler)handler
{
    [self fecthNextPage:^(NSArray *data, NSError *error) {
        if (handler) {
            handler(error);
        }
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageModelsArray.count < 20) {
        return 20;
    }
    return self.imageModelsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMComPhotoAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoAlbumCollectionCell" forIndexPath:indexPath];
    if (indexPath.row < self.imageModelsArray.count) {
        UMComImageUrl *imageModel = self.imageModelsArray[indexPath.row];
        [cell.imageView setImageURL:imageModel.small_url_string placeHolderImage:UMComImageWithImageName(@"image-placeholder")];
    }else{
        cell.imageView.image = nil;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.imageModelsArray.count) {
        return;
    }
    UMComGridViewerController *viewerController = [[UMComGridViewerController alloc] initWithArray:self.imageModelsArray index:indexPath.row];
    [viewerController setCacheSecondes:A_WEEK_SECONDES];
    [self presentViewController:viewerController animated:YES completion:nil];
}

//显示header和footer的回调方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
        if (self.refreshViewController.footView.superview != footView) {
            [self.refreshViewController.footView removeFromSuperview];
            [footView addSubview:self.refreshViewController.footView];
        }
         self.refreshViewController.footView.frame = CGRectMake(0, 0, collectionView.frame.size.width, self.refreshViewController.footView.frame.size.height);
        return footView;
        
    }else{
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (self.refreshViewController.headView.superview != headView) {
            [self.refreshViewController.headView removeFromSuperview];
            [headView addSubview:self.refreshViewController.headView];
        }
        self.refreshViewController.headView.frame = CGRectMake(0, headView.frame.size.height - self.refreshViewController.headView.frame.size.height, self.view.frame.size.width, self.refreshViewController.headView.frame.size.height);
        return headView;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (self.view.frame.size.width-8)/3;
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth);
    return itemSize;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshViewController refreshScrollViewDidScroll:scrollView haveNextPage:self.haveNextPage];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshViewController refreshScrollViewDidEndDragging:scrollView haveNextPage:_haveNextPage];
}

- (void)dealloc
{
    self.albumCollectionView.delegate = nil;
    self.albumCollectionView.dataSource = nil;
    self.albumCollectionView = nil;
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

-(void) createEmptyView
{
    self.emptyView = [[UIView alloc] initWithFrame:self.view.bounds];

    UILabel *noticellabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.emptyView.bounds.size.width, 40)];
    noticellabel.text = @"无内容";
    noticellabel.center = CGPointMake(self.emptyView.frame.size.width/2, self.emptyView.frame.size.height/2 );
    noticellabel.textAlignment = NSTextAlignmentCenter;
    noticellabel.font = UMComFontNotoSansLightWithSafeSize(20);
    noticellabel.textColor = UMComColorWithColorValueString(@"#A5A5A5");
    noticellabel.backgroundColor = [UIColor whiteColor];
    noticellabel.alpha = 1;
    [self.emptyView addSubview:noticellabel];
    
    [self.albumCollectionView addSubview:self.emptyView];
    
    self.emptyView.hidden = YES;
}

@end




@implementation UMComPhotoAlbumCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageWidth = frame.size.width;
        self.imageView = [[[UMComImageView imageViewClassName] alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        self.imageView.needCutOff = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
