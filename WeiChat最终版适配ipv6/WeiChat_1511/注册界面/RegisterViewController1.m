//
//  RegisterViewController1.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/7.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RegisterViewController1.h"
#import "RegisterViewController2.h"
#import "RegisterManager.h"
@interface RegisterViewController1 ()
{
    RegisterManager*manager;
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextField *nickName;

@end

@implementation RegisterViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    
    [self createTextField];
    //用于保存数据
    manager=[RegisterManager shareManager];
    // Do any additional setup after loading the view from its nib.
}
-(void)createTextField{
    UIImageView*imageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"icon_register_name.png"];
    
    UIImageView*tempImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempImageView addSubview:imageView];
    
    _nickName.leftView=tempImageView;
    _nickName.leftViewMode=UITextFieldViewModeAlways;

}
-(void)createNav{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2"]];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick)];
    
    self.title=@"请输入昵称(1/4)";
    
    _userName.text=[NSString stringWithFormat:@"您的数字账号为:%ld",DATETIME];
    
    //设置返回按钮
    UIButton*back=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:@"header_leftbtn_black_nor.png" Target:self Action:@selector(backButtonClick) Title:@"返回"];
    
    //设置文字黑色
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:back];
    
    

}
-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightBarButtonItemClick{
    //保存数据
    manager.userName=[_userName.text substringFromIndex:8];

    if (_nickName.text.length>0) {
        manager.nickName=_nickName.text;
    }
    
    RegisterViewController2*vc=[[RegisterViewController2 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)resetClick:(id)sender {
    
    _userName.text=[NSString stringWithFormat:@"您的数字账号为:%ld",DATETIME];
    
    
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
