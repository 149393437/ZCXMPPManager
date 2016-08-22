//
//  SettingViewController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "LFSettingViewController.h"
#import "CollectViewController.h"
@interface LFSettingViewController ()

@end

@implementation LFSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor grayColor];
    //设置九宫格
    NSArray*array=@[[UIImage imageNamed:@"account_setting"],[UIImage imageNamed:@"account_favorite"],[UIImage imageNamed:@"account_user"],[UIImage imageNamed:@"account_collect"],[UIImage imageNamed:@"account_download"],[UIImage imageNamed:@"account_comment"],[UIImage imageNamed:@"account_help"],[UIImage imageNamed:@"account_help"]];
    
    NSArray*titleArray=@[@"我的设置",@"我的关注",@"我的账号",@"我的收藏",@"我的下载",@"我的评论",@"我的帮助",@"蚕豆应用"];
    
    //计算间隙
    float s=(WIDTH-180)/4;
    
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton*button=[LFZCControl createButtonWithFrame:CGRectMake(s+(s+60)*(i%3), s+(s+80)*(i/3), 60, 60) Target:self Method:@selector(buttonClick:) Title:nil ImageName:nil BgImageName:nil];
        [button setBackgroundImage:array[i] forState:UIControlStateNormal];
        button.tag=100+i;
        [self.view addSubview:button];
        
        //创建label
        UILabel*label=[LFZCControl createLabelWithFrame:CGRectMake(0, 70, 60, 10) Font:10 Text:titleArray[i]];
        label.textAlignment=NSTextAlignmentCenter;
        [button addSubview:label];
        
    }
    
    
    // Do any additional setup after loading the view.
}
-(void)buttonClick:(UIButton*)button{

    CollectViewController*vc=[[CollectViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
