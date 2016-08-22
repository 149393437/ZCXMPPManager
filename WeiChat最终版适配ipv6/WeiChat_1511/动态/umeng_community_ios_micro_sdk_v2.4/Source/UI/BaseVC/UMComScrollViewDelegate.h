//
//  UMComScrollViewDelegate.h
//  UMCommunity
//
//  Created by umeng on 15/7/27.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UMComScrollViewDelegate <NSObject>

@optional;
- (void)customScrollViewDidScroll:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition;

- (void)customScrollViewDidEnd:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition;

- (void)customScrollViewEndDrag:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition;

@end
