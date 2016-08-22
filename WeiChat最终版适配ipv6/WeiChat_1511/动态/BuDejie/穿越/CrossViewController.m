//
//  CrossViewController.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/1/30.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "CrossViewController.h"
@interface CrossViewController ()

@end

@implementation CrossViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //重写导航左按钮
    [self createNavLeftButton];
    
    //把导航重新设置坐标
    
    _tableView.frame=CGRectMake(0, 64, WIDTH, HEIGHT);
    
    // Do any additional setup after loading the view.
}
-(void)createNavLeftButton{
//navigationButtonReturn.png
    UIButton*leftButton=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) Target:self Method:@selector(leftButtonClick) Title:@"返回" ImageName:@"navigationButtonReturn.png" BgImageName:nil];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //设置title
    self.navigationItem.titleView=nil;
    self.navigationItem.title=@"穿越";
    self.navigationItem.rightBarButtonItem=nil;


}
-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];

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
