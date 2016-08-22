//
//  SettingViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MainSliderViewController.h"
//主题
#import "ThemeViewController.h"
//Vcard
#import "MyVcardViewController.h"

#import "HttpDownLoad.h"
//显示二维码
#import "QRViewController.h"
//关于我们
#import "AboutViewController.h"
//气泡下载
#import "BubbleDownLoadViewController.h"
//聊天背景
#import "ChatBgViewController.h"
//反馈
#import "UMFeedback.h"
//字体
#import "FontViewController.h"
//清理缓存
#import "ClearViewController.h"

#import "AppDelegate.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //头像
    UIImageView*headerImageView;
    //昵称
    UILabel*nickNameLabel;
    //签名
    UILabel*qmdLabel;
    //二维码
    UIButton*qrButton;
    //VIP SVIP
    UIImageView*vipImageView;
    
    //tableView
    UITableView*_tableView;
    
    //设置
    UIButton*setButton;
    
    //夜间模式
    UIButton*nightButton;
    
    //天气
    UILabel*weatherLabel;
    
    //城市
    UILabel*cityLabel;
    
    //天气图标
    UIImageView*weatherImageView;
    
    //天气的文字说明
    UILabel*weatherLabel1;
    
}
//数据源
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSArray*titleArray;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //先创建UI
    [self createView];
    
    [self createTabelView];
    
    [self loadData];
    
    [self createBottomView];

    
    //先判断是否是从登陆界面过来了
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    
    if (![user objectForKey:isLogin1]) {
        //从登陆界面过来的,已经执行过登陆
        [user setObject:isLogin1 forKey:isLogin1];
        [user synchronize];
        [self loadMyVcard];

    }else{
        //直接进入主界面的,需要我们自己执行登陆操作
        MBProgressHUD*hud= [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        hud.labelText=@"正在登陆";
        hud.detailsLabelText=@"请稍后";
        [hud show:YES];

        [manager connectLogin:^(BOOL isOK) {
            if (isOK) {
                NSLog(@"登陆成功");
                [hud hide:YES];
                [self loadMyVcard];

            }
        }];
    }
    
    
    [self createWeatherView];
    [self createWeatherLoadData];
    
       // Do any additional setup after loading the view.
}
-(void)createWeatherView{
    weatherLabel=[ZCControl createLabelWithFrame:CGRectMake(WIDTH-64-60, HEIGHT-64, 40, 40) Font:20 Text:nil];
    weatherLabel.textColor=[UIColor whiteColor];
    [self.view  addSubview:weatherLabel];
    
    cityLabel=[ZCControl createLabelWithFrame:CGRectMake(WIDTH-64-60, HEIGHT-20, 40, 20) Font:15 Text:nil];
    cityLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:cityLabel];

    weatherImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-124-30, HEIGHT-60, 30, 30) ImageName:nil];
    [self.view addSubview:weatherImageView];
    
    weatherLabel1=[ZCControl createLabelWithFrame:CGRectMake(WIDTH-124-30, HEIGHT-20,60, 20) Font:15 Text:nil];
    weatherLabel1.textColor=[UIColor whiteColor];
    [self.view addSubview:weatherLabel1];
}
-(void)createWeatherLoadData{
        HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:@"https://api.thinkpage.cn/v3/weather/now.json?key=AD1PFZORSW&location=ip" Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
            if (isSuccess) {
                weatherLabel.text=[NSString stringWithFormat:@"%@°",xx.dataDic[@"results"][0][@"now"][@"temperature"]];
                
                cityLabel.text=xx.dataDic[@"results"][0][@"location"][@"name"];
                weatherImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",xx.dataDic[@"results"][0][@"now"][@"code"]]];
                weatherLabel1.text=xx.dataDic[@"results"][0][@"now"][@"text"];
            }
            
        }];
        http=nil;



}
//获取Vcard信息
-(void)loadMyVcard{
    [manager getMyVcardBlock:^(BOOL isOK, XMPPvCardTemp *myVcard) {
        if (isOK) {
        //获取成功
            if (myVcard.photo) {
                headerImageView.image=[UIImage imageWithData:myVcard.photo];
            }
        //昵称
            if (myVcard.nickname) {
                nickNameLabel.text=UNCODE(myVcard.nickname);
            }else{
                //否则我显示账号
                nickNameLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
            }
        //签名
            NSString*qmd=[[myVcard elementForName:QMD]stringValue];
            if (qmd) {
                qmdLabel.text=UNCODE(qmd);
            }else{
                qmdLabel.text=@"这家伙很懒,什么都写";
            }
            
            
        }
        
    }];


}


-(void)createBottomView{
    setButton=[ZCControl createButtonWithFrame:CGRectMake(20, HEIGHT-64, 80, 40) ImageName:nil Target:self Action:@selector(settingClick) Title:@" 注销"];
    
    [setButton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [self.view addSubview:setButton];
    
//    nightButton=[ZCControl createButtonWithFrame:CGRectMake(100, HEIGHT-64, 80, 40) ImageName:nil Target:self Action:@selector(nightClick) Title:@" 夜间"];
    [nightButton setImage:[UIImage imageNamed:@"夜间"] forState:UIControlStateNormal];
    [self.view addSubview:nightButton];
    

}
#pragma mark 进入注销
-(void)settingClick{
//告知服务器用户下线
//切断链接
//删除用户名密码
    [manager disconnect];
    
//初始化登陆界面
    LoginViewController*vc=[[LoginViewController alloc]init];
    
    AppDelegate*app=[UIApplication sharedApplication].delegate;
    
    app.window.rootViewController=vc;
////释放主界面
    MainSliderViewController*slider=(MainSliderViewController*)[MainSliderViewController sharedSliderController];

    [slider reSetConfig];
    
    
}
#pragma mark 夜间模式
-(void)nightClick{

}
-(void)loadData{
    self.dataArray=@[@"我的超级会员",@"我的钱包",@"个性装扮",@"我的图片",@"我的收藏",@"我的文件",@"我的文件"];
    self.titleArray=@[@"个人资料",@"气泡背景",@"聊天背景",@"个性装扮",@"关于我们",@"反馈",@"清理缓存"];

    [_tableView reloadData];
}
-(void)createTabelView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 150, WIDTH-64, HEIGHT-215) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
-(void)createView{
    imageView=[ZCControl createImageViewWithFrame:self.view.frame ImageName:nil];
    imageView.image=[self imageNameStringToImage:@"sidebar_fullbg.jpg"];
    self.view=imageView;
    
    headerImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 64, 60, 60) ImageName:@"logo_2"];
    //圆角
    headerImageView.layer.cornerRadius=30;
    headerImageView.layer.masksToBounds=YES;
    [self.view addSubview:headerImageView];
    
    //昵称
    nickNameLabel=[ZCControl createLabelWithFrame:CGRectMake(90, 64, 200, 30) Font:15 Text:@"萌呆🐻"];
    nickNameLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:nickNameLabel];
    
    //vip
    vipImageView=[ZCControl createImageViewWithFrame:CGRectMake(90, 100, 30, 15) ImageName:@"vip_nor.png"];
    [self.view addSubview:vipImageView];
    
    //签名
    qmdLabel=[ZCControl createLabelWithFrame:CGRectMake(20, 130, 280, 20) Font:15 Text:@"萌呆🐻带你遨游世界"];
    qmdLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:qmdLabel];
    
    
    //添加点击事件
    UIControl*control=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH-64, 150)];
    [control addTarget:self action:@selector(controlClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    
    qrButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-128, 64, 44, 44) ImageName:@"二维码.png" Target:self Action:@selector(qrButtonClick) Title:nil];
    [self.view addSubview:qrButton];
    
}
-(void)themeClick{

    self.view=imageView;
    UIImageView*xx=(UIImageView*)self.view;
    xx.image=[self imageNameStringToImage:@"sidebar_fullbg.jpg"];
}
-(void)qrButtonClick{
    NSLog(@"二维码");
    QRViewController*vc=[[QRViewController alloc]init];
    MainSliderViewController*slider=[MainSliderViewController sharedSliderController];
    [slider.navigationController pushViewController:vc animated:YES];
    
    
    
}
-(void)controlClcik{
    NSLog(@"设置个人信息");
    
    MyVcardViewController*vc=[[MyVcardViewController alloc]initWithBlock:^{
        //刷新当前UI
        [self loadMyVcard];
    }];
    MainSliderViewController*slider=[MainSliderViewController sharedSliderController];
    [slider.navigationController pushViewController:vc animated:YES];
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        //设置选择无颜色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=self.titleArray[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:self.dataArray[indexPath.row]];
    
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //获取MainSlider的指针
    MainSliderViewController*slider=[MainSliderViewController sharedSliderController];
    

    switch (indexPath.row) {
        case 0:
            //设置个人资料
            [self controlClcik];
            break;
        case 1:
            //气泡背景
        {
            BubbleDownLoadViewController*vc=[[BubbleDownLoadViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [slider.navigationController pushViewController:vc animated:YES];
        
        }
            break;
        case 2:
        {
        //聊天背景
            ChatBgViewController*vc=[[ChatBgViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [slider.navigationController pushViewController:vc animated:YES];
        
        }
            break;
        case 3:
        {
            //主题设置
            ThemeViewController*vc=[[ThemeViewController alloc]init];
            //关闭左边
            [slider.navigationController pushViewController:vc animated:YES];
            [slider closeSideBar];

        
        }
            break;
        case 4:
        {
            //关于我们
            AboutViewController*vc=[[AboutViewController alloc]init];
            [slider.navigationController pushViewController:vc animated:YES];
            [slider closeSideBar];

        }
            break;
        case 5:
        {
            //反馈
            [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
            
        }
            break;
        case 6:
        {
            
//            //聊天字体
//            FontViewController*vc=[[FontViewController alloc]init];
//            vc.hidesBottomBarWhenPushed=YES;
//            [slider.navigationController pushViewController:vc animated:YES];
            //清理缓存
            ClearViewController*vc=[[ClearViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [slider.navigationController pushViewController:vc animated:YES];

        }
        default:
            break;
    }

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
