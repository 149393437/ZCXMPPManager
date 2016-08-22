//
//  VideoPlayControl.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/1/30.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
//在线音频播放
#import "AudioStreamer.h"
@interface VideoPlayControl : NSObject
{
    //这里声明,保证mp不被释放
    MPMoviePlayerController*mp;
    //在线音频播放器
    AudioStreamer*streamer;
}
+(id)shareManager;
@property(nonatomic,strong)UIView*playView;
//开始播放
-(void)playWithURL:(NSString*)str toView:(UIView*)view;

//停止播放并删除界面
-(void)stop;



@end
