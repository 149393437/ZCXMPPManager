//
//  MainTabBarController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "MainTabBarController.h"
//最近联系人
#import "RecentViewController.h"
//联系人
#import "FriendViewController.h"
//动态
#import "ZoomViewController.h"

#import "UIImage+Scale.h"
#import "ThemeManager.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:THEME object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //先创建viewController
    [self createViewController];
    
    //设置tabbar
    [self createTabBarItems];
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createTabBarItems) name:THEME object:nil];
    // Do any additional setup after loading the view.
}
-(void)createTabBarItems{
    NSArray*titleArray=@[@"最近联系人",@"联系人",@"动态"];
    NSArray*selectImageNameArray=@[@"tab_recent_press.png",@"tab_buddy_press.png",@"tab_qworld_press.png"];
    NSArray*unSelectImageNameArray=@[@"tab_recent_nor@2x.png",@"tab_buddy_nor.png",@"tab_qworld_nor.png"];
    
    //读取地址
    
    UIColor*unSelectColor=[ThemeManager themeColorStrToColor:@"kTabBarItemTitleColorNormal"];
    
    UIColor*selectColor=[ThemeManager themeColorStrToColor:@"kTabBarItemTitleColorHighlighted"];

    NSString*imagePath=[NSString stringWithFormat:@"%@%@/",LIBPATH,[[NSUserDefaults standardUserDefaults] objectForKey:THEME]];

    
    
    for (int i=0; i<selectImageNameArray.count; i++) {
        UIImage*selectImage=[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",imagePath,selectImageNameArray[i]]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage*unSelectImage=[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",imagePath,unSelectImageNameArray[i]]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem*itme=self.tabBar.items[i];
        itme=[itme initWithTitle:titleArray[i] image:unSelectImage selectedImage:selectImage];
        
        [itme setTitleTextAttributes:@{NSForegroundColorAttributeName:unSelectColor} forState:UIControlStateNormal];
        [itme setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor} forState:UIControlStateSelected];
        
    }
    //设置tabbar背景色
    UIImage*bgImage=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@tabbar_bg_ios7.png",imagePath]];
    
    [self.tabBar setBackgroundImage:[bgImage scaleToSize:CGSizeMake(WIDTH, 49)]];
    
    //去除阴影线
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
//appearance 只是针对还没有加载在界面前可以使用,如果加载,是无法修改的,所以在切换主题,不可以去该方法进行切换
//    [UITabBarItem appearance]setTitleTextAttributes:<#(nullable NSDictionary<NSString *,id> *)#> forState:<#(UIControlState)#>
//        itme setTitleTextAttributes:<#(nullable NSDictionary<NSString *,id> *)#> forState:<#(UIControlState)#>


}
-(void)createViewController{
    RecentViewController*vc1=[[RecentViewController alloc]init];
    vc1.title=@"最近联系人";
    UINavigationController*nc1=[[UINavigationController alloc]initWithRootViewController:vc1];
    
    FriendViewController*vc2=[[FriendViewController alloc]init];
    vc2.title=@"联系人";
    UINavigationController*nc2=[[UINavigationController alloc]initWithRootViewController:vc2];
    
    ZoomViewController*vc3=[[ZoomViewController alloc]init];
    vc3.title=@"动态";
    UINavigationController*nc3=[[UINavigationController alloc]initWithRootViewController:vc3];
    
    self.viewControllers=@[nc1,nc2,nc3];

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
