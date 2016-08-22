//
//  UIView+Animation.h
//  
//
//  Created by Jeans on 3/9/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultAnimateTime             0.25f

typedef enum AnimateType{       //动画类型
    AnimateTypeOfTV,            //电视
    AnimateTypeOfPopping,       //弹性缩小放大
    AnimateTypeOfLeft,          //左
    AnimateTypeOfRight,         //右
    AnimateTypeOfTop,           //上
    AnimateTypeOfBottom         //下
}AnimateType;

@interface UIView (Animation)

#pragma mark - 获取顶部View
+ (UIView *)getTopView;

#pragma mark - 顶层maskView触摸
+ (void)setTopMaskViewCanTouch:(BOOL)_canTouch;

/**
 显示view
 @param _view 需要显示的view
 @param _aType 动画类型
 @param _fRect 最终位置
 */
+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect;


/**
 消失view
 */
+ (void)hideView;


/**
 消失view
 @param _aType 动画类型
 */
+ (void)hideViewByType:(AnimateType)_aType;


#pragma mark - 下面的增加了完成块
+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect completion:(void(^)(BOOL finished))completion;
+ (void)hideViewByCompletion:(void(^)(BOOL finished))completion;
+ (void)hideViewByType:(AnimateType)_aType completion:(void(^)(BOOL finished))completion;
@end
