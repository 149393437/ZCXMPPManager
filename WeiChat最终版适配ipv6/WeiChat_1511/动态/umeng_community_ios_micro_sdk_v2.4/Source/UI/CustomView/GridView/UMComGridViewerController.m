//
//  UMComGridViewerController.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/2.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import "UMComGridViewerController.h"
#import "UMImageProgressView.h"
#import "UMComShowToast.h"
#import "UMComImageUrl.h"

typedef enum {
    preImage = 0,
    curImage = 1,
    rearImage = 2,
}ImageLocation;
#define A_WEEK_SECONDES (60*60*24*7)

@interface UMComGridViewerController ()
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *imageModels;
@property (nonatomic,strong) NSMutableArray *arrayImageView;
@property (nonatomic,strong) NSMutableArray *contentViews;
@property (nonatomic,assign) NSInteger totalPageCount;
@property (nonatomic,assign) NSInteger currentPageIndex;

@end

@implementation UMComGridViewerController
{
    BOOL fisrtime;
}

- (id)initWithArray:(NSArray *)array index:(NSUInteger)index
{
    self = [super init];
    
    if(self)
    {
        self.arrayImageView = [[NSMutableArray alloc] init];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self.scrollView setDelegate:self];
        
        for(int i=0;i<3; i++)
        {
            UMZoomScrollView *zoomScrollView = [[UMZoomScrollView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            UMImageProgressView *iv = [[UMImageProgressView alloc] initWithFrame:CGRectMake(0, 0, zoomScrollView.frame.size.width, zoomScrollView.frame.size.height)];
            iv.isAutoStart = NO;
            [iv setTag:i];
            [iv setCacheSecondes:A_WEEK_SECONDES];
            zoomScrollView.imageView = iv;
            [self.arrayImageView addObject:zoomScrollView];
        }
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 20, self.view.bounds.size.width, 20)];
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.pageControl];
        self.view.backgroundColor = [UIColor blackColor];
        
        //添加触控
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [self.view addGestureRecognizer:tapGesture];
        [self setArray:array index:index];
    }
    return self;
}

- (void)setArray:(NSArray *)array index:(NSUInteger)index
{
    fisrtime = YES;
    self.imageModels = array;

    NSUInteger count = [array count];
    if (count <= 9) {
        [self.pageControl setNumberOfPages:count];
        self.pageControl.currentPage = index;
    }
    self.currentPageIndex = index;
    self.contentViews = [NSMutableArray arrayWithCapacity:3];
    self.totalPageCount = count;
    [self configContentView];
}

- (void)tapImageView:(UITapGestureRecognizer *)tapGesture
{
    [self dismissViewControllerAnimated:YES completion:^{
        for (UMZoomScrollView *zoomView in self.arrayImageView) {
            zoomView.zoomScale = 1.0;
            zoomView.imageView.center = CGPointMake(zoomView.frame.size.width/2, zoomView.frame.size.height/2);
        }
    }];
}

//默认一周（60*60*24*7）
- (void)setCacheSecondes:(NSTimeInterval)secondes
{
    for(UMZoomScrollView *iv in self.arrayImageView)
    {
        [iv setCacheSecondes:secondes];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= (2*CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndext:self.currentPageIndex+1];
        [self configContentView];
    }
    if (scrollView.contentOffset.x <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndext:self.currentPageIndex-1];
        [self configContentView];
    }
    self.pageControl.currentPage = self.currentPageIndex;
}


- (void)setTotalPageCount:(NSInteger)totalPageCount
{
    _totalPageCount = totalPageCount;
    if (_totalPageCount > 0) {
        if (_totalPageCount == 1) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
            self.scrollView.contentOffset = CGPointMake(0, 0);
            self.scrollView.scrollEnabled = NO;
        }else{
            self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
            self.scrollView.scrollEnabled = YES;
        }
        
    }else{
        [self.contentViews removeAllObjects];
    }
}

- (void)configContentView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    NSInteger counter = 0;
    for (UMZoomScrollView *contenView in self.contentViews) {
        contenView.frame = CGRectMake(self.scrollView.frame.size.width *counter+((self.scrollView.frame.size.width - contenView.frame.size.width)/2), 0, contenView.frame.size.width, contenView.frame.size.height);
        counter ++;
        [contenView startDownload];
        [self.scrollView addSubview:contenView];
    }
   [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0.0f) animated:NO];
}

- (UMZoomScrollView *)zoomScrollViewWithPageIndex:(NSInteger)pageIndex imageLocation:(ImageLocation)imageLocation
{
    //
    if (self.imageModels.count > 0) {
        UMZoomScrollView *zoomView = nil;
        if (imageLocation == preImage) {
            zoomView = self.arrayImageView[0];
        }else if (imageLocation == curImage){
            zoomView = self.arrayImageView[1];
        }else{
            zoomView = self.arrayImageView[2];
        }
        if (zoomView.zoomScale > 1) {
            [zoomView setZoomScale:1 animated:NO];
        }
        if (self.imageModels.count > pageIndex) {
            ;
            UMComImageUrl *imageModel = self.imageModels[pageIndex];
            zoomView.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [zoomView.imageView setImageURL:[NSURL URLWithString:imageModel.large_url_string]];
            [zoomView.imageView setThumImageViewUrl:imageModel.small_url_string];
        }
        return zoomView;
    }
    return nil;
}

//获取将要加载图片
- (void)setScrollViewContentDataSource
{
    [self.contentViews removeAllObjects];
    @try {
        NSInteger prePageIndex = [self getValidNextPageIndexWithPageIndext:self.currentPageIndex-1];
        NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndext:self.currentPageIndex+1];
        
        UMZoomScrollView *resaultView = [self zoomScrollViewWithPageIndex:prePageIndex imageLocation:preImage];
        if(resaultView){
            [self.contentViews addObject:resaultView];
        }
        resaultView = [self zoomScrollViewWithPageIndex:self.currentPageIndex imageLocation:curImage];
        if(resaultView){
            [self.contentViews addObject:resaultView];
        }
        resaultView = [self zoomScrollViewWithPageIndex:rearPageIndex imageLocation:rearImage];
        if(resaultView){
            [self.contentViews addObject:resaultView];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndext:(NSInteger)currentPageIndex;
{
    if (currentPageIndex == -1) {
        return self.totalPageCount - 1;
    }else if (currentPageIndex == self.totalPageCount || currentPageIndex < -1){
        return 0;
    }else if (currentPageIndex > self.totalPageCount){
        return self.totalPageCount - 1;
    }else{
        return currentPageIndex;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end


@implementation UMZoomScrollView
{
    UIActionSheet *actionSheet;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImageToAssest:)];
        longPress.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)setImageView:(UMImageProgressView *)imageView
{
    _imageView = imageView;
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    _imageView.backgroundColor = [UIColor clearColor];
    if (imageView.isCacheImage) {
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 5.0;
    } else{
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 1.0;
    }
    [self addSubview:_imageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) /2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) /2 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width /2 + offsetX,scrollView.contentSize.height /2 + offsetY);
}

//默认一周（60*60*24*7）
- (void)setCacheSecondes:(NSTimeInterval)secondes
{
    [self.imageView setCacheSecondes:secondes];
}

- (void)startDownload
{
    [self.imageView startImageLoad];
}

- (void)saveImageToAssest:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (![actionSheet isVisible]) {
            actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:UMComLocalizedString(@"Cancel", @"取消") destructiveButtonTitle:UMComLocalizedString(@"Save image to album", @"保存图片到相册")otherButtonTitles:nil, nil];
            if (!actionSheet.superview) {
                [actionSheet showInView:self.superview];
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.imageView.image) {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
}



// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [UMComShowToast saveIamgeResultNotice:error];
}



@end
