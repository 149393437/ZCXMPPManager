//
//  ZCZBarViewController.h
//  ZbarDemo
//
//  Created by ZhangCheng on 14-4-18.
//  Copyright (c) 2014年 ZhangCheng. All rights reserved.
//
/*
 版本说明 iOS研究院 305044955
 1.4版本 支持iOS8系统，修改了相应UI的适配问题
 1.3版本 全新支持arm7s arm64 全新支持ARC
 1.2版本 ZC封装的ZBar二维码SDK
    1、更新类名从CustomViewController更改为ZCZBarViewController
    2、删除掉代理的相关代码
 1.1版本 ZC封装的ZBar二维码SDK~
    1、增加block回调
    2、取消代理
    3、增加适配IOS7（ios7在AVFoundation中增加了扫描二维码功能）
 1.0版本 ZC封装的ZBar二维码SDK~1.0版本初始建立
 
 二维码编译顺序
 Zbar编译
 需要添加AVFoundation  CoreMedia  CoreVideo QuartzCore libiconv
 
 
//示例代码
扫描代码

ZCZBarViewController*vc=[[ZCZBarViewController alloc]initWithBlock:^(NSString *str, BOOL isScceed) {
    if (isScceed) {
    NSLog(@"扫描后的结果~%@",str);
            }
 }];
 [self presentViewController:vc animated:YES completion:nil];
 
 
生成二维码
 拖拽libqrencode包进入工程，注意点copy
 添加头文件#import "QRCodeGenerator.h"
 imageView.image=[QRCodeGenerator qrImageForString:@"这个是什么" imageSize:imageView.bounds.size.width];
 */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"
#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7
@interface ZCZBarViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,ZBarReaderDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView*_line;
}


@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, assign) BOOL isScanning;

@property (nonatomic,copy)void(^ScanResult)(NSString*result,BOOL isSucceed);
//初始化函数
-(id)initWithBlock:(void(^)(NSString*,BOOL))a;

//正则表达式对扫描结果筛选
+(NSString*)zhengze:(NSString*)str;


@end
