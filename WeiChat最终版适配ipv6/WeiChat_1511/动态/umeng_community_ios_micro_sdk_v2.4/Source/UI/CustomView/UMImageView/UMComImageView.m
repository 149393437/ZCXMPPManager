//
//  UMComImageView.m
//  UMCommunity
//
//  Created by Gavin Ye on 5/6/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import "UMComImageView.h"
#import "UMComTools.h"

@interface UMComImageView ()

@property (nonatomic ,copy) Class imageViewClass;

@end

@implementation UMComImageView

static UMComImageView *_instance = nil;
+ (UMComImageView *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

+ (Class)imageViewClassName
{
    Class returnClass = [self class];
    if ([self shareInstance].imageViewClass) {
        returnClass = [self shareInstance].imageViewClass;
    }
    return returnClass;
}

+ (void)registUMImageView:(Class)imageViewClass
{
    [self shareInstance].imageViewClass = imageViewClass;
}

+ (UIImage *)placeHolderImageGender:(NSInteger )gender
{
    UIImage *placeHolder = nil;
    if (gender == 0) {
        placeHolder = UMComImageWithImageName(@"female");
    } else{
        placeHolder = UMComImageWithImageName(@"male");
    }
    return placeHolder;
}


- (void)setImageURL:(NSString *)imageURLString placeHolderImage:(UIImage *)placeHolderImage
{
    if (imageURLString) {
        NSURL *url = [NSURL URLWithString:imageURLString];
        [super setImageURL:url];
        if (!self.isCacheImage) {
            self.placeholderImage = placeHolderImage;
            [self startImageLoad];
        }
    } else {
        self.placeholderImage = placeHolderImage;
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAutoStart = NO;
        self.delegate = self;
    }
    return self;
}



- (void)imageViewLoadedImageSizePercent:(float)percent imageView:(UMImageView*)imageView
{
    if (self.imageLoaderDelegate && [self.imageLoaderDelegate respondsToSelector:@selector(umcomImageViewLoadedImageSizePercent:imageView:)]) {
        [self.imageLoaderDelegate umcomImageViewLoadedImageSizePercent:percent imageView:self];
    }
    if (self.loadedImageSizePercentBlock) {
        self.loadedImageSizePercentBlock(self,percent);
    }
}
- (void)imageViewLoadedImage:(UMImageView*)imageView
{
    if (self.imageLoaderDelegate && [self.imageLoaderDelegate respondsToSelector:@selector(umcomImageViewLoadedImage:)]) {
        [self.imageLoaderDelegate umcomImageViewLoadedImage:self];
    }
    if (self.loadedImageBlock) {
        self.loadedImageBlock(self);
    }
}
- (void)imageViewFailedToLoadImage:(UMImageView*)imageView error:(NSError*)error
{
    if (self.imageLoaderDelegate && [self.imageLoaderDelegate respondsToSelector:@selector(umcomImageViewFailedToLoadImage:error:)]) {
        [self.imageLoaderDelegate umcomImageViewFailedToLoadImage:self error:error];
    }
    if (self.loadImageFailedBlock) {
        self.loadImageFailedBlock(self,error);
    }
}
@end
