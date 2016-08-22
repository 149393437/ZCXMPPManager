//
//  MainTabBarController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "LFMainTabBarController.h"

#import "LimitViewController.h"
#import "HOTViewController.h"
#import "ReduceViewController.h"
#import "FreeViewController.h"
//使用xib创建的
#import "TopViewController.h"

#import "UIImage+Scale.h"
@interface LFMainTabBarController ()

@end

@implementation LFMainTabBarController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pop" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewControllers];
    [self createTabBar];
        //接收通知 pop是自定义频道
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backClick) name:@"pop" object:nil];
    // Do any additional setup after loading the view.
}
-(void)backClick{
    [self.nc popViewControllerAnimated:YES];
}
//-(void)ccc{
//    
////    self.navigationController和self.nc一样吗
//    
////    [self.nc popViewControllerAnimated:YES];
//}
-(void)createTabBar{
    NSArray*titleArray=@[@"限免",@"降价",@"免费",@"专题",@"热榜"];
    
    NSArray*unSelectImage=@[[UIImage imageNamed:@"tabbar_account"],[UIImage imageNamed:@"tabbar_reduceprice"],[UIImage imageNamed:@"tabbar_appfree"],[UIImage imageNamed:@"tabbar_subject"],[UIImage imageNamed:@"tabbar_rank"]];
    
    NSArray*selectImage=@[[UIImage imageNamed:@"tabbar_account_press"],[UIImage imageNamed:@"tabbar_reduceprice_press"],[UIImage imageNamed:@"tabbar_appfree_press"],[UIImage imageNamed:@"tabbar_subject_press"],[UIImage imageNamed:@"tabbar_rank_press"]];
    
    for (int i=0; i<selectImage.count; i++) {
        UITabBarItem*item=self.tabBar.items[i];
        item=[item initWithTitle:titleArray[i] image:[unSelectImage[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectImage[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    //设置tabbar的背景色
    [self.tabBar setBackgroundImage:[[UIImage imageNamed:@"tabbar_bg1.png"] scaleToSize:CGSizeMake(WIDTH, 49)]];
    //设置文字颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    


}
-(void)createViewControllers{
    LimitViewController*vc1=[[LimitViewController alloc]init];
    vc1.title=@"限免";
    vc1.urlStr=LIMIT;
    UINavigationController*nc1=[[UINavigationController alloc]initWithRootViewController:vc1];
    
    FreeViewController*vc2=[[FreeViewController alloc]init];
    vc2.title=@"限免";
    vc2.urlStr=FREE;
    UINavigationController*nc2=[[UINavigationController alloc]initWithRootViewController:vc2];
    
    ReduceViewController*vc3=[[ReduceViewController alloc]init];
    vc3.title=@"限免";
    vc3.urlStr=REDUCE;
    UINavigationController*nc3=[[UINavigationController alloc]initWithRootViewController:vc3];
    
    
//    LimitViewController*vc4=[[LimitViewController alloc]init];
    
    TopViewController*vc4=[[[NSBundle mainBundle]loadNibNamed:@"TopViewController" owner:nil options:nil]firstObject];
    vc4.title=@"专题";
//    vc4.urlStr=LIMIT;
    UINavigationController*nc4=[[UINavigationController alloc]initWithRootViewController:vc4];
    HOTViewController*vc5=[[HOTViewController alloc]init];
    vc5.title=@"热榜";
    vc5.urlStr=HOT;
    UINavigationController*nc5=[[UINavigationController alloc]initWithRootViewController:vc5];
   
    self.viewControllers=@[nc1,nc2,nc3,nc4,nc5];
    

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
