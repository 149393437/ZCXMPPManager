//
//  RadarFriendViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/31.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RadarFriendViewController.h"

@interface RadarFriendViewController ()

@end

@implementation RadarFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)backClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(10, 0, WIDTH-20, 40) ImageName:nil Target:self Action:@selector(buttonClick) Title:@"添加好友"];
    UIImage*image=[UIImage imageNamed:@"common_button_red_nor.png"];
    image=[image stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIView*view=[ZCControl viewWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [view addSubview:button];
    return view;
    
}
-(void)buttonClick{
    [[ZCXMPPManager sharedInstance]addSomeBody:self.friendJid Newmessage:nil];
    
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
