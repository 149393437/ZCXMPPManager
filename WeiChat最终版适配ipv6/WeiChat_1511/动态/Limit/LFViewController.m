
//
//  LFViewController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/3/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "LFViewController.h"
#import "MainTabBarController.h"
@interface LFViewController ()

@end

@implementation LFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MainTabBarController *tbc=[[MainTabBarController alloc]init];
    [self.navigationController pushViewController:tbc animated:YES];
    
//    [self presentViewController:tbc animated:YES completion:nil];

    
    
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
