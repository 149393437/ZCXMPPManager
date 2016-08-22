//
//  ZCiFLYTEK.h
//  Xunfei_demo_1401
//
//  Created by ZhangCheng on 14-4-19.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//版本说明 iOS研究院 305044955
//ZC封装语音识别2.0版本
//支持64位，改变了UI，更加好看 把UI的SDK和不带UI的SDK合并了
//ZC封装语音识别1.0版本
//进行了讯飞的初始封装
/*
 需要添加系统的库
 SystemConfiguration
 AudioToolBox
 libz
 CoreTelephony
 AVFoundation
 讯飞提供的库
 iflyMSC.frameWork
 
 代码示例
 //读取
 ZCiFLYTEK*xunfei=[ZCiFLYTEK shareManager];
 [xunfei playStart:@"我是最帅的"];

 //识别带UI界面的
 ZCiFLYTEK*xunfei=[ZCiFLYTEK shareManager];
 [xunfei discernShowView:self.view Block:^(NSString *xx) {
 NSLog(@"识别结果~~~%@",xx);
 }];
 
 //识别不带UI界面的
 ZCiFLYTEK*xunfei=[ZCiFLYTEK shareManager];
 [xunfei discernShowView:nil Block:^(NSString *xx) {
 NSLog(@"识别结果~~~%@",xx);
 }];
 */

#import <Foundation/Foundation.h>
//读取

#import "iflyMSC/IFlySpeechSynthesizer.h"
//识别
//带界面的语音识别
#import "iflyMSC/IFlyRecognizerView.h"
//不带界面的语音识别
#import "iflyMSC/IFlySpeechRecognizer.h"

@interface ZCiFLYTEK : NSObject
<IFlySpeechSynthesizerDelegate,IFlyRecognizerViewDelegate,IFlySpeechRecognizerDelegate>
{
    
    IFlySpeechSynthesizer* iFlySynthesizerView;//播放使用
    
    IFlyRecognizerView*iFlyRecognizerView;//界面识别
    
    IFlySpeechRecognizer*iFlyRecognizer;
    
}

@property(nonatomic,copy)void(^onResult)(NSString*);
//获得指针的单例
+(id)shareManager;
//识别
-(void)discernShowView:(UIView*)view Block:(void (^)(NSString *))a;
//读取
-(void)playStart:(NSString*)content;
@end
