//
//  UMComEditForwardView.h
//  UMCommunity
//
//  Created by umeng on 15/11/20.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UMComImageView, UMComEditTextView;
@interface UMComEditForwardView : UIImageView

@property (nonatomic, strong) UMComEditTextView *forwardEditTextView;

@property (nonatomic, strong) UMComImageView *forwardImageView;

@property (nonatomic, strong) NSMutableArray *forwardCheckWords;

- (void)reloadViewsWithText:(NSString *)text checkWords:(NSArray *)checkWords urlString:(NSString *)urlString;

/**
 *  重新布局转发的内容
 *
 *  @param forwardCreator 转发feed的作者
 *  @param forwardContent 转发的内容
 *  @param checkWords     需要检查的高亮关键词（比如:作者的名字等）
 *  @param urlString      转发的图片
 */
- (void)reloadViewsWithForwardCreator:(NSString *)forwardCreator forwardContent:(NSString*)forwardContent checkWords:(NSArray *)checkWords urlString:(NSString *)urlString;
@end