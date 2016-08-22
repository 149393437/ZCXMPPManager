//
//  UMImageView.h
//  UMImageView
//
//  Created by Shaun Harrison on 9/15/09.
//  Copyright (c) 2009-2010 enormego
//  Modifyed by Umeng on 6/6/12
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "UMImageLoader.h"

typedef enum
{
    UMImageView_Init,
    UMImageView_Success,
    UMImageView_Failed,
}UMImageView_Status;


@protocol UMImageViewDelegate;
@interface UMImageView : UIImageView<UMImageLoaderObserver>

@property(nonatomic,retain) NSURL* imageURL;
@property(nonatomic,retain) UIImage* placeholderImage;
@property(nonatomic,assign) id<UMImageViewDelegate> delegate;

@property (nonatomic) BOOL isAutoStart;//是否设置 URL 后自动下载。默认 YES，如果 NO，配合 StartLoad 开始
@property (nonatomic, assign) BOOL isCacheImage;  // 是否从cache获取图片，或者从网上获取
@property   UMImageView_Status status;
@property (nonatomic, assign) BOOL needCutOff;  //设置是否需要裁剪成正方形


- (id) initWithPlaceholderImage:(UIImage*)anImage; // delegate:nil
- (id) initWithPlaceholderImage:(UIImage*)anImage delegate:(id<UMImageViewDelegate>)aDelegate;

- (void)setImageURL:(NSURL *)aImageURL placeholderImage:(UIImage *)aPlaceholderImage;

- (void) startImageLoad;
- (void) cancelImageLoad;
- (void) startAnimating;
- (void) setCacheSecondes:(NSTimeInterval)secondes;
- (void) clearCache;

@end

@protocol UMImageViewDelegate<NSObject>
@optional
- (void)imageViewLoadedImageSizePercent:(float)percent imageView:(UMImageView*)imageView;
- (void)imageViewLoadedImage:(UMImageView*)imageView;
- (void)imageViewFailedToLoadImage:(UMImageView*)imageView error:(NSError*)error;
@end