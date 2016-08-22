//
//  LoginViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/7.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController1.h"
#import "MainSliderViewController.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    //logo
    UIImageView*logoImageView;
    //用户名
    UITextField*_userNameTextField;
    //密码
    UITextField*_passWordTextField;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    // Do any additional setup after loading the view.
}
-(void)createView{
    //设置背景色
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2"]];
    
    //设置logo的位置
    logoImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH/2-60, 60, 120, 120) ImageName:@"logo_2"];
    //切圆角
    logoImageView.layer.cornerRadius=60;
    //裁剪
    logoImageView.layer.masksToBounds=YES;
    [self.view addSubview:logoImageView];
    
    //设置输入框背景
    UIImageView*bgTextFieldImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 200, WIDTH-20, 150) ImageName:@"login.png"];
    
    [self.view addSubview:bgTextFieldImageView];
    
    //设置输入框
    [self createTextField:bgTextFieldImageView];
    
    //注册
    UIButton*_registerButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2-110, 400, 80, 30) ImageName:@"btn_login_bg_2.png" Target:self Action:@selector(registerClick) Title:@"注册"];
    [self.view addSubview:_registerButton];
    
    //登陆
    UIButton*_loginButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2+40, 400, 80, 30) ImageName:@"btn_login_bg_2.png" Target:self Action:@selector(loginClick) Title:@"登陆"];
    [self.view addSubview:_loginButton];
    

}
-(void)createTextField:(UIImageView*)bgImageView{

    UIImageView*_userNameIcon=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"userName.png"];
    
    //设置临时的一个层
    UIImageView*_tempUserNameIcon=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [_tempUserNameIcon addSubview:_userNameIcon];
    
    //加载在输入框内
        _userNameTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 20, WIDTH-20, 40) placeholder:@"请输入用户名" passWord:NO leftImageView:_tempUserNameIcon rightImageView:nil Font:20 backgRoundImageName:nil];
    _userNameTextField.delegate=self;
    
    //设置键盘
    _userNameTextField.returnKeyType=UIReturnKeyNext;
    [bgImageView addSubview:_userNameTextField];
    
    
    //密码图标
    UIImageView*passWordIcon=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"passWord.png"];
    
    //设置临时层
    UIImageView*tempPassWordIcon=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempPassWordIcon addSubview:passWordIcon];
    
    //设置密码输入框
    _passWordTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 100, WIDTH-20, 40) placeholder:@"请输入密码" passWord:YES leftImageView:tempPassWordIcon rightImageView:nil Font:20 backgRoundImageName:nil];
    _passWordTextField.returnKeyType=UIReturnKeyGo;
    _passWordTextField.delegate=self;
    
    [bgImageView addSubview:_passWordTextField];
    
    //设置观察键盘高度
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    

    //添加一个手势
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];

}
#pragma mark 手势
-(void)tapClick{
    //结束编辑
    [self.view endEditing:YES];
}
#pragma mark 键盘弹出
-(void)keyboardShow:(NSNotification*)not{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0, -180, WIDTH, HEIGHT);
        logoImageView.transform=CGAffineTransformMakeScale(0.1, 0.1);
    }];


}
#pragma mark 键盘消息
-(void)keyboardHide:(NSNotification*)not{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
        logoImageView.transform=CGAffineTransformMakeScale(1,1);
    }];
    

    
}

#pragma mark 注册
-(void)registerClick{
    RegisterViewController1*vc=[[RegisterViewController1 alloc]init];
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
    
}
#pragma mark 登陆
-(void)loginClick{

    //判断用户密码都有值得情况下进行登陆操作者
    
    if (_userNameTextField.text.length>0&&_passWordTextField.text.length>0) {
        //进行登陆操作
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        [user setObject:_userNameTextField.text forKey:kXMPPmyJID];
        [user setObject:_passWordTextField.text forKey:kXMPPmyPassword];
        [user synchronize];
        //执行登陆操作
        /*
         执行的过程
         1.先使用用户名连接服务器
         2.连接成功后,开始验证密码
         3.验证密码成功后,完成连接,返回响应的个人数据以及激活的相关模块,比如好友数据
         */
        
       MBProgressHUD*hud= [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText=@"正在登陆";
        hud.detailsLabelText=@"请稍后";
        [hud show:YES];
        [[ZCXMPPManager sharedInstance]connectLogin:^(BOOL isSuccess) {
           

            if (isSuccess) {
                hud.labelText=@"登陆成功";
                hud.detailsLabelText=nil;
                [hud hide:YES];
                //单例创建主界面
                MainSliderViewController*slider=[MainSliderViewController sharedSliderController];
                

                    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:slider];
                
                    [self presentViewController:nc animated:YES completion:nil];
                
                
                
            }else{
                hud.labelText=@"登陆失败";
                hud.detailsLabelText=nil;
                [hud hide:YES];
                
            }
        }];
        
        
    }else{
    //否则告知用户,请填写完成用户名密码
        [[[UIAlertView alloc]initWithTitle:@"请填写完整用户名密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    
    
    }
    
}

#pragma mark 输入框的相关代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_userNameTextField) {
        [_passWordTextField becomeFirstResponder];
    }else{
        //执行登陆按钮响应事件
        [self loginClick];

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
