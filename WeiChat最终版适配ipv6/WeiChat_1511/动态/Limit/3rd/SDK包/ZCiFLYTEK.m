//
//  ZCiFLYTEK.m
//  Xunfei_demo_1401
//
//  Created by ZhangCheng on 14-4-19.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCiFLYTEK.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlyResourceUtil.h"
@implementation ZCiFLYTEK
static ZCiFLYTEK *manager=nil;
-(id)init
{
    if (self=[super init]) {
        [IFlySpeechUtility createUtility:@"appid=54759baa,timeout=1000"];

    }
    return self;
}
+(id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager==nil) {
            manager=[[self alloc]init];
        }
    });
    return manager;
}
-(void)playStart:(NSString*)content
{
    [[IFlySpeechUtility getUtility] setParameter:@"tts" forKey:[IFlyResourceUtil ENGINE_START]];
    iFlySynthesizerView = [IFlySpeechSynthesizer sharedInstance];
    iFlySynthesizerView.delegate = self;
    [iFlySynthesizerView setParameter:[IFlySpeechConstant TYPE_CLOUD] forKey:[IFlySpeechConstant ENGINE_TYPE]];
    [iFlySynthesizerView setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
   
    iFlySynthesizerView.delegate=self;
    [iFlySynthesizerView startSpeaking:content];
}
-(void)discernShowView:(UIView*)view Block:(void (^)(NSString *))a{
    self.onResult=a;
    if(view==nil){
    //无界面
        iFlyRecognizer=[IFlySpeechRecognizer sharedInstance];
        iFlyRecognizer.delegate=self;
        [iFlyRecognizer setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        [iFlyRecognizer setParameter: @"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        // | result_type   | 返回结果的数据格式，可设置为json，xml，plain，默认为json。
        [iFlyRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        //设置多少ms后断开录音
        [iFlyRecognizer setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
        
        //    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];   当你再不需要保存音频时，请在必要的地方加上这行。
        [iFlyRecognizer startListening];
        
    }else{
        iFlyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:view.center];
        iFlyRecognizerView.delegate = self;
        
        [iFlyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        [iFlyRecognizerView setParameter: @"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        // | result_type   | 返回结果的数据格式，可设置为json，xml，plain，默认为json。
        [iFlyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        //设置多少ms后断开录音
        [iFlyRecognizerView setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
        
        //    [_iflyRecognizerView setParameter:@"asr_audio_path" value:nil];   当你再不需要保存音频时，请在必要的地方加上这行。
        [iFlyRecognizerView start];

    
    }

}

//代理
//识别完成
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@(置信度:%@)\n",key,[dic objectForKey:key]];
        
    }
    if ([result hasPrefix:@"。"]) {
        return;
    }
    self.onResult(result);
}
- (void)onError:(IFlySpeechError *)error
{
    self.onResult(nil);
}

/****播放的代理****/
#pragma mark - IFlySpeechSynthesizerDelegate
//开始播放
- (void) onSpeakBegin
{
 
}

/*
 * @brief   缓冲进度
 * @param   progress            -[out] 缓冲进度
 * @param   msg                 -[out] 附加信息
*/
- (void) onBufferProgress:(int) progress message:(NSString *)msg
{

}

/*
 * @brief   播放进度
 * @param   progress            -[out] 播放进度
 */
- (void) onSpeakProgress:(int) progress
{
    NSLog(@"play progress:%d",progress);
}
//暂停播放暂停播放
- (void) onSpeakPaused
{

}

//恢复播放
- (void) onSpeakResumed
{

}


//结束回调 结束回调
- (void) onCompleted:(IFlySpeechError *) error
{
}
//正在取消
- (void) onSpeakCancel
{

}


@end
