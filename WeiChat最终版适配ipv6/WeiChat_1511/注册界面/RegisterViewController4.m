//
//  RegisterViewController4.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RegisterViewController4.h"
#import "RegisterManager.h"
#import "MainSliderViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
@interface RegisterViewController4 ()<UITextFieldDelegate,CLLocationManagerDelegate>
{
    //注册类
    RegisterManager*_registerManager;
    //通讯核心类
    ZCXMPPManager*_xmppManager;
    
    UIAlertView*al;
    
    CLLocationManager*locationManager;
    
    MBProgressHUD*hud;
    CLGeocoder*geo;
}
@property (weak, nonatomic) IBOutlet UITextField *qmdTextField;
@property (weak, nonatomic) IBOutlet UITextField *addRessTextField;

@end

@implementation RegisterViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createView];
    _registerManager=[RegisterManager shareManager];
    
    hud=[[MBProgressHUD alloc]init];
    hud.labelText=@"正在定位";
    [self.view addSubview:hud];
    [hud show:YES];
    locationManager=[[CLLocationManager alloc]init];
    locationManager.distanceFilter=1000;
    locationManager.delegate=self;
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //定位
    CLLocation*newLocation=[locations lastObject];
    [manager stopUpdatingLocation];
    //获取经纬度
    geo=[[CLGeocoder alloc]init];
    [geo reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count) {
          CLPlacemark*place=  [placemarks firstObject];            _addRessTextField.text=[place.addressDictionary[@"FormattedAddressLines"] firstObject];
            [hud hide:YES];

        }
    }];
    
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [hud hide:YES];
    NSLog(@"定位失败");
    [manager stopUpdatingLocation];

}
-(void)createView{
    UIImageView*qmdImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"icon_edit.png"];
    UIImageView*tempQmdImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempQmdImageView addSubview:qmdImageView];
    
    _qmdTextField.leftView=tempQmdImageView;
    
    _qmdTextField.leftViewMode=UITextFieldViewModeAlways;
    
    _qmdTextField.delegate=self;
    
    
    
    UIImageView*addRessImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"feed_loc_new.png"];
    UIImageView*tempAddRessImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempAddRessImageView addSubview:addRessImageView];
    _addRessTextField.leftView=tempAddRessImageView;
    _addRessTextField.leftViewMode=UITextFieldViewModeAlways;
    _addRessTextField.delegate=self;
    
}
-(void)createNav{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2"]];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick)];
    
    self.title=@"完善资料(4/4)";
    
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
    if (al) {
        [al dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }
    
    //下一页
    if (_qmdTextField.text.length>0) {
        _registerManager.qmd=_qmdTextField.text;
    }
    if (_addRessTextField.text.length>0) {
        _registerManager.address=_addRessTextField.text;
    }
    
    //开始进行注册
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    [user setObject:_registerManager.userName forKey:kXMPPmyJID];
    [user setObject:_registerManager.passWord forKey:kXMPPmyPassword];
    [user synchronize];

    hud= [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText=@"正在登陆";
    hud.detailsLabelText=@"请稍后";
    [hud show:YES];
    _xmppManager=[ZCXMPPManager sharedInstance];

    [_xmppManager registerMothod:^(BOOL isSuccess) {
        if (isSuccess) {
            //注册完成  直接执行登陆操作
            [_xmppManager connectLogin:^(BOOL isOK) {
                if (isOK) {
                    //获取自己的资料
                    [_xmppManager getMyVcardBlock:^(BOOL is, XMPPvCardTemp *myVcard) {
                        if (is) {
                            //设置昵称
                            if (_registerManager.nickName) {
                                myVcard.nickname=CODE(_registerManager.nickName);
                            }
                            //设置头衔
                            if (_registerManager.headerImage) {
                                myVcard.photo=UIImageJPEGRepresentation(_registerManager.headerImage, 0.1);
                            }
                            //设置生日
                            if (_registerManager.birthday) {
                            [_xmppManager customVcardXML:_registerManager.birthday name:BYD myVcard:myVcard];    
                            }
                            //设置性别
                            if (_registerManager.sex) {
                                [_xmppManager customVcardXML:CODE(_registerManager.sex) name:SEX myVcard:myVcard];
                            }
                            //电话
                            if (_registerManager.phoneNum) {
                                //一零三八
                                [_xmppManager customVcardXML:CODE(_registerManager.phoneNum) name:PHONENUM myVcard:myVcard];
                            }
                            //签名
                            if (_registerManager.qmd) {
                                [_xmppManager customVcardXML:CODE(_registerManager.qmd) name:QMD myVcard:myVcard];
                            }
                            //地址
                            if (_registerManager.address) {
                                [_xmppManager customVcardXML:CODE(_registerManager.address) name:ADDRESS myVcard:myVcard];
                            }
                            //进行数据请求开始进行更新数据
                            [_xmppManager upData:myVcard];
                            //更新数据的时候,需要把block指空,防止循环调用
                            _xmppManager.myVcardBlock=nil;
                            
                            NSLog(@"进入主页面");
                            [hud hide:YES];

                            MainSliderViewController*slider=[MainSliderViewController sharedSliderController];
                            [self.navigationController pushViewController:slider animated:YES];
                            
                        }else{
                            UIAlertView*al2=[[UIAlertView alloc]initWithTitle:@"更新个人资料失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [al2 show];
                        
                        }
                        
                        
                    }];
                    
                    
                }else{
                    [hud show:YES];

                    UIAlertView*al1=[[UIAlertView alloc]initWithTitle:@"您的网络有问题,请稍后重试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [al1 show];
                    
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
                
                
            }];
            
            
            
            
        }else{
            _registerManager.userName=[NSString stringWithFormat:@"%ld",DATETIME];
            
            al=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"用户名重复,为您更换用户名%@",_registerManager.userName]message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [al show];
            
            [self performSelector:@selector(rightBarButtonItemClick) withObject:nil afterDelay:2];
        
        }
        
        
    }];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_qmdTextField) {
        [_addRessTextField becomeFirstResponder];
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
