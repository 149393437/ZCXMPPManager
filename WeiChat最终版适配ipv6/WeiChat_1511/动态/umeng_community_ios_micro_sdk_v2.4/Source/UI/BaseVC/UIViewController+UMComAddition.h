//
//  UIViewController+UMComAddition.h
//  UMCommunity
//
//  Created by umeng on 15/5/8.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIViewController (UMComAddition)

- (void)setBackButtonWithImage;

- (void)setLeftButtonWithTitle:(NSString *)title action:(SEL)action;
- (void)setLeftButtonWithImageName:(NSString *)imageName action:(SEL)action;
- (void)setBackButtonWithImageName:(NSString *)imageName buttonSize:(CGSize)size action:(SEL)action;

- (void)setRightButtonWithTitle:(NSString *)title action:(SEL)action;
- (void)setRightButtonWithImageName:(NSString *)imageName action:(SEL)action;

- (void)setTitleViewWithTitle:(NSString *)title;

//论坛版UItitle设置方法
- (void)setForumUITitle:(NSString *)title;
//论坛版返回按钮设置方法
- (void)setForumUIBackButton;


- (void)setTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color;

- (void)showTipLableFromTopWithTitle:(NSString *)title;

- (void)transitionFromViewControllerAtIndex:(NSInteger)fromIndex
                    toViewControllerAtIndex:(NSInteger)toIndex
                                   duration:(NSTimeInterval)duration
                                    options:(UIViewAnimationOptions)options
                                 animations:(void (^ __nullable)(void))animations
                                 completion:(void (^ __nullable)(BOOL finished))completion;

- (void)transitionFromViewControllerAtIndex:(NSInteger)fromIndex
                    toViewControllerAtIndex:(NSInteger)toIndex
                                 animations:(void (^ __nullable)(void))animations
                                 completion:(void (^ __nullable)(BOOL finished))completion;


@end
