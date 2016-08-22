//
//  ZCChatAVAdioPlay.h
//  AVAudioPlay_demo
//
//  Created by ZhangCheng on 14-4-19.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//版本说明  iOS中国开发者2群 305044955
//1.1版本 更正类名 CustomAVAdioPlay更正为ZCChatAVAdioPlay
//1.0版本 ZC封装的本地单例播放器（聊天版）初始创建
/*
 1、模拟器下无法调用麦克风，如果调用麦克风，会产生系统崩溃
 2、主要用在聊天界面进行语音播放使用，用于录音+转换格式+保存，加清空缓存，以及语音转码
 3、为什么要转码，因为苹果默认是WAV文件相对比较大，进行转码后的AMR格式比转之前小10倍
 4、本类特点是调用的方法少，很多使用Block进行回调
 */
/*
 需要添加的支持库
 AVFoundation
 第三方
 Base64（音频转文字）、
 amr_wav（格式互转）2个文件夹
 录音需要真机才可以进行，模拟器会自动判断不启动录音
 */
/*
 代码示例
 //开始录音
 ZCChatAVAdioPlay*avAdio=[ZCChatAVAdioPlay sharedInstance];
 [avAdio startRecording];
 
 //结束录音
 ZCChatAVAdioPlay*avAdio=[ZCChatAVAdioPlay sharedInstance];
 [avAdio endRecordingWithBlock:^(NSString *aa) {
 NSLog(@"amr转码base64，可以进行发送数据%@",aa);
 }];
 
 //播放声音
 NSArray*file=[ZCChatAVAdioPlay getVoiceFileName];
 NSLog(@"获取文件夹下目录%@",file);
 //读取出amr文件名
 NSString*last=[file objectAtIndex:file.count-2];
 //拼接路径
 NSString*path=[NSString stringWithFormat:@"%@/Library/Caches/Voice/%@",NSHomeDirectory(),last];
 NSLog(@"Main~%@",path);
 //读取文件
 NSData*data=[NSData dataWithContentsOfFile:path];
 ZCChatAVAdioPlay*av=[ZCChatAVAdioPlay sharedInstance];
 //播放
 [av playSetAvAudio:data];
 
 */
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceRecorderBaseVC.h"
#import "ChatVoiceRecorderVC.h"
@interface ZCChatAudioPlay : NSObject<AVAudioPlayerDelegate,VoiceRecorderBaseVCDelegate>
{
    AVAudioPlayer *avAudioPlayer;   //播放器player
    BOOL isOpen;
    UIButton *oldButton;
}@property(nonatomic,copy)NSString*recordFilePath;
//设置在不同状态显示的文字 recorderVC.recorderView.countDownLabel.text
@property(nonatomic,copy)__block ChatVoiceRecorderVC*recorderVC;

@property(nonatomic,strong)NSMutableDictionary*blockDic;

@property(nonatomic,copy)void(^endRecord)(NSString*sendStr);

@property(nonatomic,copy)NSString*dataStr;
//开启单例
+ (ZCChatAudioPlay*)sharedInstance;
//播放声音
-(void)playSetAvAudio:(NSString *)str1 Block:(void(^)())a;

//录音的处理
//开始录音
-(void)startRecording;
//结束录音  录音完成后WAV格式转换为AMR格式进行  AMR格式转换base64
-(void)endRecordingWithBlock:(void(^)(NSString*))a;

//获得录音文件夹下的所有文件
+(NSArray*)getVoiceFileName;
//清理缓存
+(void)clear;

@end
