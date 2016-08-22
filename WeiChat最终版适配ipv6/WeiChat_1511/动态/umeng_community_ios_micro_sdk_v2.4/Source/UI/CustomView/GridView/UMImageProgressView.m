//
//  UMImageViewWithProgress.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/3.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import "UMImageProgressView.h"
#import "UMComProgressView.h"
#import "UMComShowToast.h"

@interface UMImageProgressView ()
@property (nonatomic,strong) UMComProgressView *progressView;
@end



@implementation UMImageProgressView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.progressView = [[UMComProgressView alloc] initWithColor:[UIColor whiteColor]];
        self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+40);
        [self addSubview:self.progressView];
        self.progressView.progress = 0.0f;
        self.imageLoaderDelegate = self;

    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) startImageLoad
{
    [super startImageLoad];
     self.thumImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-40);
    self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+40);
    if ([self ifNeedShowThumImage]) {
        self.thumImageView.hidden = NO;
        self.progressView.hidden = NO;
    }else{
        self.thumImageView.hidden = YES;
        self.progressView.hidden = YES;
    }
}

- (BOOL)ifNeedShowThumImage
{
    if(!self.isCacheImage)
    {
        if (self.image) {
            return NO;
        }else{
            return YES;
        }
        
    }else{
        return NO;
    }
}

- (void)cancelImageLoad
{
    [super cancelImageLoad];
    self.progressView.hidden = YES;
}

#pragma mark - UMComImageViewDelegate
- (void)umcomImageViewLoadedImageSizePercent:(float)percent imageView:(UMComImageView *)imageView
{
    self.progressView.progress = percent;
    
    [self.progressView setNeedsDisplay];
}

- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView
{
    self.progressView.hidden = YES;//zhangjunhua
    self.thumImageView.hidden = YES;
    UIScrollView * zoomView = (UIScrollView *)self.superview;
    [self resetSizeWithURLImage:imageView];
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        zoomView.maximumZoomScale = 5;
    }
    //zhangjunhua---begin
    zoomView.contentOffset = CGPointMake(0, 0);
    zoomView.contentSize = CGSizeMake(0, 0);
    CGRect org_rc = imageView.frame;
    if (org_rc.size.height >  zoomView.bounds.size.height) {
        org_rc.origin.y = 0;
        org_rc.origin.x = 0;
        org_rc.size.height = imageView.image.size.height;
        self.frame = org_rc;
        zoomView.contentSize = imageView.bounds.size;
        zoomView.contentOffset = CGPointMake(org_rc.origin.x, org_rc.origin.y);
    }
    //zhangjunhua---end
}

//- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView
//{
//    self.progressView.hidden = YES;
//    self.thumImageView.hidden = YES;
//    UIScrollView * zoomView = (UIScrollView *)self.superview;
//    [self resetSizeWithURLImage:imageView];
//        if ([self.superview isKindOfClass:[UIScrollView class]]) {
//        zoomView.maximumZoomScale = 5;
//    }
//}
- (void)umcomImageViewFailedToLoadImage:(UMComImageView *)imageView error:(NSError *)error
{
    UIScrollView * zoomView = (UIScrollView *)self.superview;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        zoomView.maximumZoomScale = 1;
    }
    self.progressView.hidden = YES;
    [UMComShowToast showFetchResultTipWithError:error];
}


- (void)setThumImageViewUrl:(NSString *)urlString
{
    if ([self ifNeedShowThumImage]) {
        if (self.thumImageView == nil) {
            UMComImageView *thumImageView = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
            thumImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-40);
            thumImageView.hidden = YES;
            thumImageView.needCutOff = YES;
            [self addSubview:thumImageView];
            self.thumImageView = thumImageView;
            self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+40);
        }else{
            self.thumImageView.hidden = NO;
            self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+40);
        }
        [self.thumImageView setImageURL:urlString placeHolderImage:self.thumImageView.placeholderImage];
    }else{
        self.thumImageView.hidden = YES;
    }
}

- (void)resetSizeWithURLImage:(UMComImageView *)imageView
{
    self.thumImageView.hidden = YES;
    UIScrollView * zoomView = (UIScrollView *)self.superview;
    if ([self.superview isKindOfClass:[UIScrollView class]] && zoomView.zoomScale > 1) {
//        zoomView.zoomScale = 1;
    }else{
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGSize viewSize = [UIScreen mainScreen].bounds.size;
        CGSize imageSize = imageView.image.size;
        int height = viewSize.width * imageSize.height / imageSize.width;
//        imageView.frame = CGRectMake(0,viewSize.height/2-height/2, viewSize.width, height);
        imageView.frame = CGRectMake(0, 0, zoomView.bounds.size.width, zoomView.bounds.size.height);
        
    }

//    NSLog(@"imageView center is :%@",NSStringFromCGPoint(imageView.center));

}


@end
