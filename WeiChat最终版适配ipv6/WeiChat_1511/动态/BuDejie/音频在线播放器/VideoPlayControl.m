//
//  VideoPlayControl.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/1/30.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "VideoPlayControl.h"

@implementation VideoPlayControl
static VideoPlayControl *vp=nil;
+(id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vp=[[VideoPlayControl  alloc]init];
        
    
    });
    return vp;
}
-(void)playWithURL:(NSString *)str toView:(UIView *)view
{
    [self stop];
    //判断地址是否是mp3 或者mp4
    if ([str hasSuffix:@"mp3"]) {
        //mp3地址
        if (streamer==nil) {
            streamer=[[AudioStreamer alloc]init];
        }
       streamer= [streamer initWithURL:[NSURL URLWithString:str]];
        //进行播放
        [streamer start];
        
    }else{
        //mp4地址
        if (mp==nil) {
            mp=[[MPMoviePlayerController alloc]init];
        }
        mp=[mp initWithContentURL:[NSURL URLWithString:str]];
        
        mp.view.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        [view addSubview:mp.view];
        [mp play];
    
    }
    
    
   }
-(void)stop{
    if (mp) {
        //停止
        [mp stop];
        //删除界面
        [mp.view removeFromSuperview];
    }
    
    if (streamer) {
        [streamer stop];
    }

}

@end
