//
//  UMComImageView.h
//  UMCommunity
//
//  Created by Gavin Ye on 5/6/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import "UMImageView.h"

@class UMComImageView;
@protocol UMComImageViewDelegate <NSObject>
@optional
- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView;

- (void)umcomImageViewLoadedImageSizePercent:(float)percent imageView:(UMComImageView *)imageView;
- (void)umcomImageViewFailedToLoadImage:(UMComImageView *)imageView error:(NSError*)error;
@end

@interface UMComImageView : UMImageView<UMImageViewDelegate>

@property (nonatomic, weak) id<UMComImageViewDelegate> imageLoaderDelegate;

@property (nonatomic, copy) void (^loadedImageSizePercentBlock)(UMComImageView *imageView ,float percent);
@property (nonatomic, copy) void (^loadedImageBlock)(UMComImageView *imageView);
@property (nonatomic, copy) void (^loadImageFailedBlock)(UMComImageView *imageView, NSError *error);

+ (Class)imageViewClassName;

+ (void)registUMImageView:(Class)imageViewClass;

+ (UIImage *)placeHolderImageGender:(NSInteger )gender;

- (void)setImageURL:(NSString *)imageURLString placeHolderImage:(UIImage *)placeHolderImage;


@end
