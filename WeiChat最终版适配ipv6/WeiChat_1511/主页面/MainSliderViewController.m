//
//  MainSliderViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "MainSliderViewController.h"
#import "MainTabBarController.h"
#import "SettingViewController.h"
@interface MainSliderViewController ()
@property(nonatomic)BOOL isViewDidLoad;
@end

@implementation MainSliderViewController
static MainSliderViewController *sharedSVC=nil;
- (void)viewDidLoad {
    
    [self createViewControllers];
    [super viewDidLoad];
    _isViewDidLoad=YES;
    
    // Do any additional setup after loading the view.
}
+ (id)sharedSliderController
{
    
    if (sharedSVC==nil) {
        sharedSVC=[[MainSliderViewController alloc]init];
    }
    if (sharedSVC.MainVC==nil&&sharedSVC.isViewDidLoad==YES) {
        [sharedSVC config];
    }
    
    
    return sharedSVC;
}

#pragma mark 重写该方法
-(void)createViewControllers{

    self.MainVC=[[MainTabBarController alloc]init];
    self.LeftVC=[[SettingViewController alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
