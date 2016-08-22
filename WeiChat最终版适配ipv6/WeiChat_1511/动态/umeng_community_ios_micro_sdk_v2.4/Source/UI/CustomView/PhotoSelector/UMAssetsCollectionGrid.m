//
//  UMAssetsCollectionGrid.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/10.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMAssetsCollectionGrid.h"
#import "UMAssetsCollectionCheckMarkView.h"
#import "UMAssetsCollectionOverlayView.h"

#define kNUMBEROFGRIDSINROW 4

@interface UMAssetsCollectionGrid()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UMAssetsCollectionOverlayView *overlayView;
@property (nonatomic, strong) UIImage *blankImage;
@end

@implementation UMAssetsCollectionGrid

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isSelected = NO;
        

        self.backgroundColor = [UIColor brownColor];
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    // Show/hide overlay view
    if (isSelected) {
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
}

- (void)showOverlayView
{
    [self hideOverlayView];
    
    UMAssetsCollectionOverlayView *overlayView = [[UMAssetsCollectionOverlayView alloc] initWithFrame:self.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:overlayView];
    self.overlayView = overlayView;
}

- (void)hideOverlayView
{
    if (self.overlayView) {
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }
}

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    
    // Update view
    CGImageRef thumbnailImageRef = [asset thumbnail];
    
    if (thumbnailImageRef) {
        self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
    } else {
        self.imageView.image = [self blankImage];
    }
}

- (UIImage *)blankImage
{
    if (_blankImage == nil) {
        CGSize size = CGSizeMake(100.0, 100.0);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        [[UIColor colorWithWhite:(240.0 / 255.0) alpha:1.0] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        _blankImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return _blankImage;
}

@end
