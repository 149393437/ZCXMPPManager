//
//  QRViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/17.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "QRViewController.h"
#import "QRCodeGenerator.h"
@interface QRViewController ()

@end

@implementation QRViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"二维码";
    
    //生成二维码
    [self createView];
    
    
    // Do any additional setup after loading the view.
}
-(void)createView{
    UIImageView*bgImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 320, 320) ImageName:@"QRBgImage.png"];
    //设置中心点
    bgImageView.center=CGPointMake(self.view.center.x, self.view.center.y);
    
    [self.view addSubview:bgImageView];
    
    UIImageView*qrImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 130, 130) ImageName:nil];
    UIImage*image=[QRCodeGenerator qrImageForString:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID] imageSize:1000];
    qrImageView.image=image;
    
    qrImageView.center=CGPointMake(bgImageView.center.x+14, bgImageView.center.y+60);
    
    [self.view addSubview:qrImageView];
    

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
