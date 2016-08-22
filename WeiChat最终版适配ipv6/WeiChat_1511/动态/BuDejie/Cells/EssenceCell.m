//
//  EssenceCell.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/1/29.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "EssenceCell.h"
#import "AudioStreamer.h"
@implementation EssenceCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    
    return self;
}
-(void)makeUI{
    //头像
    headerImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 30, 30) ImageName:@"defaultUserIcon.png"];
    headerImageView.layer.cornerRadius=15;
    headerImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:headerImageView];
    
    //用户昵称
    userNameLabel=[ZCControl createLabelWithFrame:CGRectMake(45, 10, WIDTH-45, 12) Font:12 Text:nil];
    userNameLabel.textColor=[UIColor grayColor];
    userNameLabel.text=@"用户昵称";
    [self.contentView addSubview:userNameLabel];
    
    //发表时间
    passTimeLabel=[ZCControl createLabelWithFrame:CGRectMake(45, 25, WIDTH-45, 12) Font:10 Text:nil];
    passTimeLabel.text=@"1分钟前";
    passTimeLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:passTimeLabel];
    
    //VIP
    vipImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:@"Profile_AddV_authen.png"];
    [self.contentView addSubview:vipImageView];
    
    float space=(WIDTH-320)/5;
    
    //循环创建
    NSArray*imageNameArray=@[@"mainCellDing.png",@"mainCellCai.png",@"mainCellShare.png",@"mainCellComment.png"];
    
    //创建背景view
    bgToolsView=[LFZCControl createViewWithFrame:CGRectMake(0, 200, WIDTH, 30)];
    for (int i=0; i<4; i++) {
        UIButton*button=[LFZCControl createButtonWithFrame:CGRectMake(space+i*(80+space), 0, 80, 30) Target:self Method:@selector(buttonClick:) Title:@"123" ImageName:imageNameArray[i] BgImageName:nil];
        button.tag=100+i;
        [bgToolsView addSubview:button];
        
    }
    //灰色1像素
    UIView*view=[LFZCControl createViewWithFrame:CGRectMake(0, -1, WIDTH, 1)];
    view.backgroundColor=[UIColor grayColor];
    [bgToolsView addSubview:view];
    
    [self.contentView addSubview:bgToolsView];
    
    
    
    /*******动态**************/
    //段子
    
    contentLabel=[ZCControl createLabelWithFrame:CGRectMake(10, 45, WIDTH-20, 20) Font:12 Text:nil];
    [self.contentView addSubview:contentLabel];
    
    //图片
   contentImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:nil];
    //设置停靠模式
    contentImageView.contentMode=UIViewContentModeScaleAspectFit;
  
    [self.contentView addSubview:contentImageView];
    
    //gif标志
    gifImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"common-gif.png"];
    [contentImageView addSubview:gifImageView];
    
    
    //视频
    bgVideoImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:nil];
    bgVideoImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:bgVideoImageView];
    
    videoButton=[LFZCControl createButtonWithFrame:CGRectMake(bgVideoImageView.frame.size.width/2-40, bgVideoImageView.frame.size.height/2-40, 80, 80) Target:self Method:@selector(videoButtonClick) Title:nil ImageName:@"video-play.png" BgImageName:nil];
    [bgVideoImageView addSubview:videoButton];
    
    //音频
    bgAudioImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:nil];
    //设置停靠模式
    bgAudioImageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:bgAudioImageView];
    
    audioButton=[LFZCControl createButtonWithFrame:CGRectMake(bgAudioImageView.frame.size.width/2-40, bgAudioImageView.frame.size.height-80, 80, 80) Target:self Method:@selector(audioButtonClick) Title:nil ImageName:@"playButtonPlay.png" BgImageName:nil];
    [bgAudioImageView addSubview:audioButton];


}
#pragma mark 播放声音
-(void)audioButtonClick{

    /*
     苹果本身是不支持播放在线MP3,所以我们需要第三方库来播放音频
     */
    
//    AudioStreamer*streamer=[[AudioStreamer alloc]initWithURL:[NSURL URLWithString:_dataModel.voiceuri]];
//    [streamer start];
    VideoPlayControl*vp=[VideoPlayControl shareManager];
    [vp playWithURL:_dataModel.voiceuri toView:bgVideoImageView];
    
    _isVideoPlay=YES;

    
}
#pragma mark 播放视频
-(void)videoButtonClick{
    //地址 videouri
    
    /*
     苹果自身支持的播放器种类较少,仅支持,mp4等相关衍生类,但是异种格式多达400多种,如果要播放这些格式需要使用FFmepg进行万能解码,在这方面我们有先驱者做的很好,快播
     
     */
//    
//    mp=[[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:_dataModel.videouri]];
//    mp.view.frame=CGRectMake(0, 0, bgVideoImageView.frame.size.width, bgVideoImageView.frame.size.height);
//    [bgVideoImageView addSubview:mp.view];
//    
//    [mp play];
    
    VideoPlayControl*vp=[VideoPlayControl shareManager];
    [vp playWithURL:_dataModel.videouri toView:bgVideoImageView];
    
    _isVideoPlay=YES;
    

}
#pragma mark 功能按钮
-(void)buttonClick:(UIButton*)button{
    

}

-(void)config:(AllModel *)model
{
    self.dataModel=model;
    
    _isVideoPlay=NO;
    
    //设置基本信息
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon.png"]];
    //设置用户名
    userNameLabel.text=model.name;
    //设置时间
    passTimeLabel.text=model.passtime;
    //设置点赞数量
//   model.comment
    
    /*
     崩溃原因 -[__NSCFNumber length] 这个崩溃,还不是每个数据都必崩的,在于服务器方面出错了,前台需要进行容错,我们测试的方法respondsToSelector 尝试读取length是否可以调用
     */

    if (![model.comment respondsToSelector:@selector(length)]) {
        NSNumber*number=(NSNumber*)model.comment;
        //转换为string类型的
        model.comment=[number stringValue];
    }
    
    NSArray*array=@[model.ding,model.cai,model.repost,model.comment];
    
    //循环查找
    for (int i=0; i<4; i++) {
        UIButton*button1= [ bgToolsView viewWithTag:100+i];
        [button1 setTitle:array[i] forState:UIControlStateNormal];
    }
    
    
    
    //设置总体高度,经过不断累加
    float y=45;
    
    if (model.text.length) {
        contentLabel.hidden=NO;
        contentLabel.text=model.text;
        //计算文字大小
        float height=[contentLabel.text boundingRectWithSize:CGSizeMake(WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
        contentLabel.frame=CGRectMake(10, 45, WIDTH-20, height);
        y+=height;
        
        
        
    }else{
        contentLabel.hidden=YES;
        contentLabel.frame=CGRectZero;
    }

    
    //图片要在文字下方
    switch ([model.type intValue]) {
        case 10:
            //图片
            if ([model.is_gif intValue]) {
                gifImageView.hidden=NO;
            }else{
                gifImageView.hidden=YES;
            }
            contentImageView.hidden=NO;
            [contentImageView sd_setImageWithURL:[NSURL URLWithString:model.image1] placeholderImage:[UIImage imageNamed:@"imageBackground.png"]];
            //设置frame
            //计算图片的宽高是否超出边界
            float width=WIDTH<[model.width integerValue]?WIDTH:[model.width integerValue];
            float height=(width/WIDTH)*[model.height integerValue];
            if (height>300) {
                height=300;
            }
            
            contentImageView.frame=CGRectMake((WIDTH-width)/2, y+10, width, height);
            
            
            bgAudioImageView.hidden=YES;
            bgVideoImageView.hidden=YES;
            
            bgToolsView.frame=CGRectMake(0, y+height+20, WIDTH, 30);
            
            break;
        case 29:
            //段子
            contentImageView.hidden=YES;
            bgAudioImageView.hidden=YES;
            bgVideoImageView.hidden=YES;
            gifImageView.hidden=YES;
            bgToolsView.frame=CGRectMake(0, y+20, WIDTH, 30);
            break;
        case 31:
            //音频
            bgAudioImageView.hidden=NO;
            bgVideoImageView.hidden=YES;
            contentImageView.hidden=YES;
            gifImageView.hidden=YES;
            [bgAudioImageView sd_setImageWithURL:[NSURL URLWithString:model.image1] placeholderImage:[UIImage imageNamed:@"imageBackground.png"]];
            //设置frame
            //计算图片的宽高是否超出边界
            float width1=WIDTH<[model.width integerValue]?WIDTH:[model.width integerValue];
            float height1=(width1/WIDTH)*[model.height integerValue];
            if (height1>300) {
                height1=300;
            }
            
            bgAudioImageView.frame=CGRectMake((WIDTH-width1)/2, y+10, width1, height1);
            //调整播放按钮
            audioButton.frame=CGRectMake(WIDTH/2-40, bgAudioImageView.frame.size.height-80, 80, 80);
            
            
            bgToolsView.frame=CGRectMake(0, y+height1+20, WIDTH, 30);
            


            
            

            break;
        case 41:
            //视频
            bgAudioImageView.hidden=YES;
            bgVideoImageView.hidden=NO;
            contentImageView.hidden=YES;
            gifImageView.hidden=YES;
            
            [bgVideoImageView sd_setImageWithURL:[NSURL URLWithString:model.image1] placeholderImage:[UIImage imageNamed:@"imageBackground.png"]];
            //设置frame
            //计算图片的宽高是否超出边界
            float width2=WIDTH<[model.width integerValue]?WIDTH:[model.width integerValue];
            float height2=(width2/WIDTH)*[model.height integerValue];
            if (height2>300) {
                height2=300;
            }
            
            bgVideoImageView.frame=CGRectMake((WIDTH-width2)/2, y+10, width2, height2);
            //调整播放按钮
            videoButton.frame=CGRectMake(WIDTH/2-40, bgVideoImageView.frame.size.height/2-40, 80, 80);
            bgToolsView.frame=CGRectMake(0, y+height2+20, WIDTH, 30);
            
            
            

            break;
            
        default:
            break;
    }
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
