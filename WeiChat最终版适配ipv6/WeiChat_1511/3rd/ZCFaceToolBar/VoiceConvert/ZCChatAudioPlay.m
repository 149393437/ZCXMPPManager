//
//  ZCChatAVAdioPlay.m
//  AVAudioPlay_demo
//
//  Created by ZhangCheng on 14-4-19.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCChatAudioPlay.h"
#import "ZCVoiceConverter.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
@implementation ZCChatAudioPlay
static ZCChatAudioPlay*sharedObj = nil;
+ (ZCChatAudioPlay*)sharedInstance//第一步
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj=  [[ZCChatAudioPlay alloc] init];
            sharedObj.blockDic=[NSMutableDictionary dictionary];
        }
    }
    return sharedObj;
}
-(void)playSetAvAudio:(NSString *)str1 Block:(void(^)())a
{
    if (_dataStr) {
        void(^myBlock)()=[self.blockDic objectForKey:_dataStr];
        
        if (myBlock) {
            myBlock();
            [self.blockDic removeObjectForKey:str1];
            
        }
    }

    _dataStr=str1;
    //保存block
    [self.blockDic setObject:[a copy]forKey:str1];
    
    [self playSetAvAudio:str1];
}
-(void)playSetAvAudio:(NSString*)str1{
    //data原本是amr
    if (isOpen) {
        [avAudioPlayer stop];
        isOpen=NO;
    }
    NSData*data=[str1 base64DecodedData];
    //数据的处理
    NSString*originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    NSString*str=[VoiceRecorderBaseVC getPathByFileName:originWav ofType:@"amr"];
    
   [data writeToFile:str atomically:YES];
    
   [ZCVoiceConverter amrToWav:[VoiceRecorderBaseVC getPathByFileName:originWav ofType:@"amr"] wavSavePath:[VoiceRecorderBaseVC getPathByFileName:originWav ofType:@"wav"]];
    
    //环境的处理
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    //播放的处理
    avAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[VoiceRecorderBaseVC getPathByFileName:originWav ofType:@"wav"]] error:nil];
    avAudioPlayer.delegate=self;
    [avAudioPlayer play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"111111");
    //完成播放
    [avAudioPlayer stop];
    avAudioPlayer=nil;
    isOpen=!isOpen;
    
    void(^myBlock)()=[self.blockDic objectForKey:_dataStr];
    
    if (myBlock) {
        myBlock();
        [self.blockDic removeObjectForKey:_dataStr];
        _dataStr=nil;
        
    }
    
}
-(void)startRecording
{
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        //询问用户是否可以开启麦克风 iOS7需要询问
        
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            NSLog(@"granted = %d",granted);
            if (granted) {
                self.recordFilePath= [VoiceRecorderBaseVC getCurrentTimeString];
                //开始录音
                if (_recorderVC==nil) {
                    _recorderVC = [[ChatVoiceRecorderVC alloc]init];
                    
                    _recorderVC.vrbDelegate=self;
                }
                
                [_recorderVC beginRecordByFileName:self.recordFilePath];

                
            }
           
            
        }];
    }
    
}
-(void)endRecordingWithBlock:(void(^)(NSString*))a
{
    self.endRecord=a;
    //用户手指离开后,应当在录制0.3秒后,否则录制不全
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:0.3];
}
-(void)stopRecord{
    [_recorderVC touchEnded];//停止录音
    [ZCVoiceConverter wavToAmr:[VoiceRecorderBaseVC getPathByFileName:self.recordFilePath ofType:@"wav"] amrSavePath:[VoiceRecorderBaseVC getPathByFileName:self.recordFilePath ofType:@"amr"]];
}

-(void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString *)_fileName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[[paths objectAtIndex:0]stringByAppendingPathComponent:@"Voice"] stringByAppendingPathComponent:[[_fileName stringByAppendingString:@".amr"] stringByReplacingOccurrencesOfString:@".wav" withString:@""]];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *base64 = [data base64EncodedString];
        self.endRecord(base64);
    }
    
}

+(NSArray*)getVoiceFileName{
    NSFileManager*manager=[NSFileManager defaultManager];
    
    //获得文件夹下的所有文件
    
    NSError*error;
    NSArray*array= [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Library/Caches/Voice",NSHomeDirectory()] error:&error];
    return array;
    
    
}
+(void)clear{
    //2获得枚举
    //数组转换成枚举
    NSFileManager*manager=[NSFileManager defaultManager];
    
    //获得文件夹下的所有文件
    NSError*error;
    NSArray*array= [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Library/Caches/Voice",NSHomeDirectory()] error:&error];
    
    NSEnumerator*enumerator=[array objectEnumerator];
    NSString*fileName;
    while (fileName=[enumerator nextObject]) {
        
        NSLog(@"%@",fileName);
        
        //每一次while循环时候都会被重新赋值
        //拼接前缀地址后进行删除
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Library/Caches/Voice/%@",NSHomeDirectory(),fileName] error:nil];
        
    }
    
}

- (void) release1
{
    if (avAudioPlayer) {
        [avAudioPlayer stop];
        avAudioPlayer=nil;
        
    }
    sharedObj=nil;
    
}

@end
