//
//  RegisterViewController3.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RegisterViewController3.h"
#import "RegisterViewController4.h"
#import "RegisterManager.h"
@interface RegisterViewController3 ()<UITextFieldDelegate>
{
    RegisterManager*manager;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

@implementation RegisterViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    [self createView];
    manager=[RegisterManager shareManager];
    // Do any additional setup after loading the view from its nib.
}
-(void)createView{
    UIImageView*phoneImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"icon_register_mobile.png"];
    UIImageView*tempPhoneImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempPhoneImageView addSubview:phoneImageView];
    
    _phoneTextField.leftView=tempPhoneImageView;
    
    _phoneTextField.leftViewMode=UITextFieldViewModeAlways;
    
    _phoneTextField.delegate=self;

    
    
    //icon_register_password@2x.png
    UIImageView*passWordImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"icon_register_password.png"];
    UIImageView*tempPassWordImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempPassWordImageView addSubview:passWordImageView];
    _passWordTextField.leftView=tempPassWordImageView;
    _passWordTextField.leftViewMode=UITextFieldViewModeAlways;
    //密码遮掩
    _passWordTextField.secureTextEntry=YES;
    _passWordTextField.delegate=self;
  
}
-(void)createNav{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2"]];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick)];
    
    self.title=@"注册资料(3/4)";
    
    //设置返回按钮
    UIButton*back=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:@"header_leftbtn_black_nor.png" Target:self Action:@selector(backButtonClick) Title:@"返回"];
    
    //设置文字黑色
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:back];


}
#pragma mark 左按钮
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark 右按钮
-(void)rightBarButtonItemClick{
    if (_passWordTextField.text.length>0) {
        manager.passWord=_passWordTextField.text;
        if (_phoneTextField.text>0) {
            manager.phoneNum=_phoneTextField.text;
        }
        
    }
    
    
    //下一页
    RegisterViewController4*vc=[[RegisterViewController4 alloc]init];
    [self.navigationController pushViewController:vc animated:YES    ];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_phoneTextField) {
        [_passWordTextField becomeFirstResponder];
    }else{
        [self rightBarButtonItemClick];
    }
    return YES;
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
