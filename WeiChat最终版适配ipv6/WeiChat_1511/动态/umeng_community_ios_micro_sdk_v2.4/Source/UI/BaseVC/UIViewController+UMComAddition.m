//
//  UIViewController+UMComAddition.m
//  UMCommunity
//
//  Created by umeng on 15/5/8.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UIViewController+UMComAddition.h"
#import "UMComTools.h"
#import <objc/runtime.h>
#import "UMComBarButtonItem.h"
#import "UMComShareCollectionView.h"


const char kTopTipLabelKey;

const char kAnimationCompletion;

@implementation UIViewController (UMComAddition)


- (void)setBackButtonWithTitle:(NSString *)title
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0 || self.navigationController.viewControllers.count == 1) {
        self.navigationController.navigationItem.leftBarButtonItem = nil;
        UIBarButtonItem *backButtonItem = [[UMComBarButtonItem alloc] initWithTitle:title target:self action:@selector(goBack)];
        backButtonItem.customView.frame = CGRectMake(0, 0, 40, 35);
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
}

- (void)setBackButtonWithImage
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0 || self.navigationController.viewControllers.count <= 1) {
        self.navigationController.navigationItem.leftBarButtonItem = nil;
        UMComBarButtonItem *backButtonItem = [[UMComBarButtonItem alloc] initWithNormalImageName:@"Backx" target:self action:@selector(goBack)];
        backButtonItem.customView.frame = CGRectMake(0, 0, 40, 35);
        backButtonItem.customButtonView.frame = CGRectMake(5, 0, 20, 20);
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
}

- (void)setLeftButtonWithTitle:(NSString *)title action:(SEL)action
{
    UIBarButtonItem *backButtonItem = [[UMComBarButtonItem alloc] initWithTitle:title target:self action:@selector(action)];
    backButtonItem.customView.frame = CGRectMake(0, 0, 40, 35);
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setLeftButtonWithImageName:(NSString *)imageName action:(SEL)action
{
    
    [self setBackButtonWithImageName:imageName buttonSize:CGSizeMake(20, 20) action:action];
}

- (void)setBackButtonWithImageName:(NSString *)imageName buttonSize:(CGSize)size action:(SEL)action
{
    UMComBarButtonItem *backButtonItem = [[UMComBarButtonItem alloc] initWithNormalImageNameWithBackItem:imageName target:self action:@selector(goBack)];
    
    if (!backButtonItem) {
        NSLog(@"backButtonItem must not  nil");
        return;
    }
    
    backButtonItem.customView.frame = CGRectMake(0, 0, size.width + 10 , size.height);
    backButtonItem.customButtonView.frame = CGRectMake(10, 0, size.width, size.height);
    //self.navigationItem.leftBarButtonItem = backButtonItem;
    //通过设置leftBarButtonItems中一个固定偏移来设置左边返回按钮的点击返回，让用户方便点击
    if ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]< 8) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backButtonItem];
    }else{
        //在IOS8.0以上把返回按钮的坐标设置为0
        CGRect backButtonRC = backButtonItem.customButtonView.frame;
        backButtonRC.origin.x = 0;
        backButtonItem.customButtonView.frame = backButtonRC;
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
}

- (void)setRightButtonWithTitle:(NSString *)title action:(SEL)action
{
    UIBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithTitle:title target:self action:action];
    rightButtonItem.customView.frame = CGRectMake(0, 0, 40, 35);
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setRightButtonWithImageName:(NSString *)imageName action:(SEL)action
{
    UMComBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithNormalImageName:imageName target:self action:action];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setTitleViewWithTitle:(NSString *)title
{
    [self setForumUITitle:title];
//    [self setTitle:title font:UMComFontNotoSansLightWithSafeSize(18) titleColor:[UIColor blackColor]];
}

- (void)setForumUITitle:(NSString *)title
{
    [self setTitle:title font:UMComFontNotoSansLightWithSafeSize(UMCom_ForumUI_Title_Font) titleColor:UMComColorWithColorValueString(UMCom_ForumUI_Title_Color)];
}

- (void)setTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-200, 100)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = font;
    titleLabel.text= title;
    titleLabel.textColor = color;
    [self.navigationItem setTitleView:titleLabel];
}

- (void)setForumUIBackButton
{
    [self setBackButtonWithImageName:@"um_forum_back_gray" buttonSize:CGSizeMake(10, 19) action:@selector(goBack)];
}

- (void)goBack
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
    }
}

- (void)showTipLableFromTopWithTitle:(NSString *)title
{
    UILabel *tipLabel = objc_getAssociatedObject(self, &kTopTipLabelKey);//[self creatTipLabelWithTitle:title];
    if (!tipLabel) {
       tipLabel = [self creatTipLabel];
        tipLabel.backgroundColor = [UMComTools colorWithHexString:FontColorBlue];
        tipLabel.textColor = [UIColor whiteColor];
        objc_setAssociatedObject(self, &kTopTipLabelKey, tipLabel, OBJC_ASSOCIATION_ASSIGN);
    }
    tipLabel.text = title;
    tipLabel.frame = CGRectMake(0, -40, tipLabel.frame.size.width, tipLabel.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tipLabel.frame = CGRectMake(0, 0, tipLabel.frame.size.width, tipLabel.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            tipLabel.frame = CGRectMake(0, -40, tipLabel.frame.size.width, tipLabel.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (UILabel *)creatTipLabel
{
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 40)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.alpha = 0.8;
    tipLabel.font = UMComFontNotoSansLightWithSafeSize(16);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    return tipLabel;
}

- (void)transitionFromViewControllerAtIndex:(NSInteger)fromIndex toViewControllerAtIndex:(NSInteger)toIndex duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))animations completion:(void (^ __nullable)(BOOL finished))completion
{
    if (fromIndex >= self.childViewControllers.count || toIndex >= self.childViewControllers.count) {
        NSLog(@"index is beyond self.childViewControllers.count");
        return;
    }
    
   __block NSNumber *animationCompletionNum = objc_getAssociatedObject(self, &kAnimationCompletion);//[self creatTipLabelWithTitle:title];
    if (animationCompletionNum == nil) {
        animationCompletionNum = [NSNumber numberWithBool:YES];
        objc_setAssociatedObject(self, &kAnimationCompletion, animationCompletionNum, OBJC_ASSOCIATION_ASSIGN);
    }
    if ([animationCompletionNum boolValue] == NO) {
        return;
    }
    animationCompletionNum = [NSNumber numberWithBool:NO];
    objc_setAssociatedObject(self, &kAnimationCompletion, animationCompletionNum, OBJC_ASSOCIATION_ASSIGN);
    UIViewController *fromViewController = self.childViewControllers[fromIndex];
    UIViewController *toViewController = self.childViewControllers[toIndex];
    __block CGPoint fromCenter = fromViewController.view.center;
    CGRect currentFrame = toViewController.view.frame;
    currentFrame.size.height = self.view.frame.size.height - currentFrame.origin.y;
    if (currentFrame.size.height != toViewController.view.frame.size.height) {
        toViewController.view.frame = currentFrame;
    }
    CGPoint toCenter = toViewController.view.center;
    if (fromIndex == toIndex) {
        toCenter.x = self.view.frame.size.width/2;
        toViewController.view.center = toCenter;
        animationCompletionNum = [NSNumber numberWithBool:YES];
        objc_setAssociatedObject(self, &kAnimationCompletion, animationCompletionNum, OBJC_ASSOCIATION_ASSIGN);
        return;
    }
    if (toIndex > fromIndex) {
        if (toViewController.view.frame.origin.x <= 0) {
            toCenter.x = self.view.frame.size.width*3/2;
            toViewController.view.center = toCenter;
        }
    }else if(toIndex < fromIndex){
        if (toViewController.view.frame.origin.x >= 0) {
            toCenter.x = - self.view.frame.size.width*3/2;
            toViewController.view.center = toCenter;
        }
    }
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:duration options:options animations:^{
        if (fromViewController == toViewController) {
            animationCompletionNum = [NSNumber numberWithBool:YES];
            objc_setAssociatedObject(self, &kAnimationCompletion, animationCompletionNum, OBJC_ASSOCIATION_ASSIGN);
            return ;
        }
        toViewController.view.center = CGPointMake(weakSelf.view.frame.size.width/2, toViewController.view.center.y);
        if (toIndex > fromIndex) {
            fromCenter.x = - weakSelf.view.frame.size.width*3/2;
        }else if(toIndex < fromIndex){
            fromCenter.x = weakSelf.view.frame.size.width*3/2;
        }
        fromViewController.view.center = fromCenter;
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        animationCompletionNum = [NSNumber numberWithBool:YES];
        objc_setAssociatedObject(self, &kAnimationCompletion, animationCompletionNum, OBJC_ASSOCIATION_ASSIGN);
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)transitionFromViewControllerAtIndex:(NSInteger)fromIndex
                    toViewControllerAtIndex:(NSInteger)toIndex
                                 animations:(void (^ __nullable)(void))animations
                                 completion:(void (^ __nullable)(BOOL finished))completion
{
    [self transitionFromViewControllerAtIndex:fromIndex toViewControllerAtIndex:toIndex duration:0.25 options:UIViewAnimationOptionCurveEaseIn animations:animations completion:completion];
}


@end
