//
//  EssenceCell.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/1/29.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllModel.h"
#import <MediaPlayer/MediaPlayer.h>
@interface EssenceCell : UITableViewCell
{
    
    /********是固定的*************/
    //头像
    UIImageView*headerImageView;
    //用户昵称
    UILabel*userNameLabel;
    //发表时间
    UILabel*passTimeLabel;
    //VIP
    UIImageView*vipImageView;
    
    UIView*bgToolsView;
    
    /*******动态**************/
    //段子
    UILabel*contentLabel;
    
    
    //图片
    UIImageView*contentImageView;
    //gif标志
    UIImageView*gifImageView;
    
    
    //视频
    UIImageView*bgVideoImageView;
    UIButton*videoButton;
    
    //音频
    UIImageView*bgAudioImageView;
    UIButton*audioButton;
    
    

    MPMoviePlayerController*mp;

}
@property(nonatomic,assign)AllModel*dataModel;
@property(nonatomic)BOOL isVideoPlay;
-(void)config:(AllModel*)model;
@end




