//
//  SliderViewController.h
//  LeftRightSlider
//
//  Created by 张诚 on 13-11-27.
//  Copyright (c) 2013年 张诚. All rights reserved.
//

/*
ZC在原作者基础上，增加代码注释,同时修复几处bug
 1、修复了changeLeftView必须实现的问题
 2、增加释放单例的方法
 3、修改单例释放后无法重新被创建的问题
 4、在继承Slider后，需要在super ViewDidLoad前传值相关参数，否则无法显示
 */



#import <UIKit/UIKit.h>

@interface SliderViewController : UIViewController
@property(nonatomic,strong)UIViewController *LeftVC;
@property(nonatomic,strong)UIViewController *RightVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,copy)NSString*leftVCName;
@property(nonatomic,copy)NSString*rightVCName;
@property(nonatomic,copy)NSString*mainVCName;

@property(nonatomic,strong)NSMutableDictionary *controllersDict;
//左边滑动出来的范围默认值275
@property(nonatomic,assign)float LeftSContentOffset;
//左边内容页的偏移（没有什么作用）
@property(nonatomic,assign)float LeftContentViewSContentOffset;
@property(nonatomic,assign)float RightSContentOffset;
//当左边滑动出来的时候右边缩小多少，0.77为默认值
@property(nonatomic,assign)float LeftSContentScale;
@property(nonatomic,assign)float RightSContentScale;
//默认值为160（无实际意义）
@property(nonatomic,assign)float LeftSJudgeOffset;
@property(nonatomic,assign)float RightSJudgeOffset;

@property(nonatomic,assign)float LeftSOpenDuration;
@property(nonatomic,assign)float RightSOpenDuration;

@property(nonatomic,assign)float LeftSCloseDuration;
@property(nonatomic,assign)float RightSCloseDuration;

@property(nonatomic,assign)BOOL canShowLeft;
@property(nonatomic,assign)BOOL canShowRight;

@property (nonatomic, copy) void(^changeLeftView)(CGFloat sca, CGFloat transX);
@property(nonatomic,strong) UIPanGestureRecognizer *panGestureRec;
//清空所有控件
-(void)reSetConfig;
//重新配置所有控件
-(void)config;

//展现左边
- (void)showLeftViewController;
//展现右边
- (void)showRightViewController;

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes;
//关闭左边
- (void)closeSideBar;
//关闭左边，在动画结束的时候push一个页面，使用单例，然后调用navigationController，push一个界面出来
- (void)closeSideBarWithAnimate:(BOOL)bAnimate complete:(void(^)(BOOL finished))complete;



@end
