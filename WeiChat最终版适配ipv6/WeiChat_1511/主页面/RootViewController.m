//
//  RootViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RootViewController.h"
#import "UIImage+Scale.h"
#import "ThemeManager.h"
@interface RootViewController ()

@end

@implementation RootViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:THEME object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    manager=[ZCXMPPManager sharedInstance];
    imageView=[ZCControl createImageViewWithFrame:self.view.frame ImageName:nil];
    self.view=imageView;

    //设置导航和背景色
    [self createNav];
    
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createNav) name:THEME object:nil];
    // Do any additional setup after loading the view.
}
-(void)createNav{
    //先读取路径
    [self createImagePathStr];
    
    [self.navigationController.navigationBar setBackgroundImage:[[self imageNameStringToImage:@"header_bg_ios7.png"] scaleToSize:CGSizeMake(WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView*xx=(UIImageView*)self.view;
    
    xx.image=[self imageNameStringToImage:@"user_bg.jpg"];
    //设置导航文字颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置隐藏导航的阴影线
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[ThemeManager themeColorStrToColor:kNavigationBarTitleColor]}];
    
    
    
    [self leftNav];

    [self themeClick];
}
-(void)themeClick{

}
-(void)leftNav{
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[self imageNameStringToImage:@"header_leftbtn_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createImagePathStr{
    //读取当前默认主题
    NSString*themeStr=[[NSUserDefaults standardUserDefaults]objectForKey:THEME];
    
    //开始拼接路径
    self.imagePath=[NSString stringWithFormat:@"%@%@/",LIBPATH,themeStr];
}
-(UIImage*)imageNameStringToImage:(NSString*)imageName{
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.imagePath,imageName]];

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
