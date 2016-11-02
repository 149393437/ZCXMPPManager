//
//  MessageCell.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/11.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "MessageCell.h"
#import "MMTextParser+ExtData.h"
#import "Photo.h"
#import "ZCChatAudioPlay.h"
#import "NSString+Base64.h"
#import "LocationViewController.h"
@implementation MessageCell
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BUBBLE object:nil];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;

}
-(void)notClick{
    rightBubbleImageView.image=[self imageNameToImageLeftOrRight:NO];
    leftBubbleImageView.image=[self imageNameToImageLeftOrRight:YES];
}
-(void)makeUI{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notClick) name:BUBBLE object:nil];
    leftImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 8, 30, 30) ImageName:@"logo_2"];
    leftImageView.layer.cornerRadius=15;
    leftImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:leftImageView];
    
    //左边气泡
    leftBubbleImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:nil];
    leftBubbleImageView.image=[self imageNameToImageLeftOrRight:YES];
    [self.contentView addSubview:leftBubbleImageView];
    
    //文字控件
    leftTextView=[[MMTextView alloc]initWithFrame:CGRectZero];
    leftTextView.editable=NO;
    leftTextView.backgroundColor=[UIColor clearColor];
    leftTextView.mmFont=[MessageCell customFont];
    [leftBubbleImageView addSubview:leftTextView];
    
    //语音控件
    leftVoiceImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:nil];
    leftVoiceImageView.image=[UIImage imageNamed:@"chat_receiver_audio_playing003.png"];
    leftVoiceImageView.animationImages=@[[UIImage imageNamed:@"chat_receiver_audio_playing000.png"],[UIImage imageNamed:@"chat_receiver_audio_playing001.png"],[UIImage imageNamed:@"chat_receiver_audio_playing002.png"],[UIImage imageNamed:@"chat_receiver_audio_playing003.png"]];
    leftVoiceImageView.animationDuration=2;
//    UIControl*leftControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [leftControl addTarget:self action:@selector(voiceButton) forControlEvents:UIControlEventTouchUpInside];
    UIButton*leftButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) ImageName:nil Target:self Action:@selector(voiceButton) Title:nil];
    
    [leftVoiceImageView addSubview:leftButton];
    [leftBubbleImageView addSubview:leftVoiceImageView];
    
    //图像
    leftPhotoButton=[ZCControl createButtonWithFrame:CGRectZero ImageName:nil Target:self Action:@selector(buttonScaleClick:) Title:nil];
     [rightPhotoButton setImage:[UIImage imageNamed:@"watermark template.png"] forState:UIControlStateNormal];
    leftPhotoButton.layer.cornerRadius=15;
    leftPhotoButton.layer.masksToBounds=YES;
    [leftBubbleImageView addSubview:leftPhotoButton];
  
    
    
    //大表情
    leftBigImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 0, 80, 80) ImageName:nil];
    [leftBubbleImageView addSubview:leftBigImageView];
    
    //定位
    leftLocationButton=[ZCControl createButtonWithFrame:CGRectMake(20, 20, 60, 60) ImageName:@"chat_location_preview.png" Target:self Action:@selector(locationClick:) Title:nil];
    leftLocationButton.layer.cornerRadius=15;
    leftLocationButton.layer.masksToBounds=YES;
    
    [leftBubbleImageView addSubview:leftLocationButton];
    
    
    
    //右边
    rightImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-40, 8, 30, 30) ImageName:nil];
    
    //裁剪
    rightImageView.layer.cornerRadius=15;
    rightImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:rightImageView];
    
    //气泡
    rightBubbleImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:nil];
    rightBubbleImageView.image=[self imageNameToImageLeftOrRight:NO];
    [self.contentView addSubview:rightBubbleImageView];
    
    //文字
    rightTextView=[[MMTextView alloc]initWithFrame:CGRectZero];
    rightTextView.backgroundColor=[UIColor clearColor];
    rightTextView.mmFont=[MessageCell customFont];
    rightTextView.editable=NO;

    
    [rightBubbleImageView addSubview:rightTextView];
    
    //语音
    rightVoiceImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:nil];
    rightVoiceImageView.image=[UIImage imageNamed:@"chat_sender_audio_playing_003.png"];
    rightVoiceImageView.animationImages=@[[UIImage imageNamed:@"chat_sender_audio_playing_000.png"],[UIImage imageNamed:@"chat_sender_audio_playing_001.png"],[UIImage imageNamed:@"chat_sender_audio_playing_002.png"],[UIImage imageNamed:@"chat_sender_audio_playing_003.png"]];
    rightVoiceImageView.animationDuration=2;
//    UIControl*rightControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [rightControl addTarget:self action:@selector(voiceButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) ImageName:nil Target:self Action:@selector(voiceButton) Title:nil];
    
    [rightVoiceImageView addSubview:rightButton];


    [rightBubbleImageView addSubview:rightVoiceImageView];
    
    //图片
    rightPhotoButton =[ZCControl createButtonWithFrame:CGRectZero ImageName:nil Target:self Action:@selector(buttonScaleClick:) Title:nil];
    rightPhotoButton.backgroundColor=[UIColor blackColor];
    [rightPhotoButton setImage:[UIImage imageNamed:@"watermark template.png"] forState:UIControlStateNormal];
    rightPhotoButton.layer.cornerRadius=15;
    rightPhotoButton.layer.masksToBounds=YES;
    [rightBubbleImageView addSubview:rightPhotoButton];
    //大表情
    rightBigImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 0, 80, 80) ImageName:nil];
    [rightBubbleImageView addSubview:rightBigImageView];
    
    rightLocationButton=[ZCControl createButtonWithFrame:CGRectMake(20, 20, 60, 60) ImageName:@"chat_location_preview.png" Target:self Action:@selector(locationClick:) Title:nil];
    rightLocationButton.layer.cornerRadius=15;
    rightLocationButton.layer.masksToBounds=YES;
    [rightBubbleImageView addSubview:rightLocationButton];
    
    
    timeLabel=[ZCControl createLabelWithFrame:CGRectMake(0, 0, WIDTH, 10) Font:10 Text:nil];
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:timeLabel];
    
    

}
#pragma mark 响应定位
-(void)locationClick:(UIButton*)button{
    //拆解坐标
    NSArray*array=[_str componentsSeparatedByString:@","];
    
    LocationViewController*vc=[LocationViewController shareLocation:CLLocationCoordinate2DMake([[array firstObject]floatValue], [[array lastObject]floatValue])];
   
    //移动到顶层VC上
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    [topVC presentViewController:vc animated:YES completion:nil];

}

#pragma mark 播放语音
-(void)voiceButton{
    NSLog(@"播放语音");
    
    [[ZCChatAudioPlay sharedInstance]playSetAvAudio:_str Block:^{
        if (rightVoiceImageView.isHidden) {
            [leftVoiceImageView stopAnimating];
            [rightVoiceImageView stopAnimating];
        }else{
            [rightVoiceImageView stopAnimating];
            [leftVoiceImageView stopAnimating];
        }
    }];
    //开始播放
    if (rightBubbleImageView.isHidden) {
        [leftVoiceImageView startAnimating];
    }else{
        [rightVoiceImageView startAnimating];
    }

}
-(UIImage*)imageNameToImageLeftOrRight:(BOOL)isLeft{
    /*
     思路
     1.先读取当前气泡主题  如果有就进行读取气泡的主题
     2.拼接路径,拼接路径后对气泡进行拉伸操作
     3.如果是左边进行翻转操作
     
     如果没有主题气泡,使用当前整体主题的默认气泡
     整体主题的默认气泡是有左右区分的
     */
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    NSString*bubbleImage=[user objectForKey:BUBBLE];
    //读取路径theme
        if (bubbleImage) {
            self.path=[NSString stringWithFormat:@"%@/%@/static/%@",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject],bubbleImage,@"chat_bubble_thumbnail.png"];
             UIImage*image=[UIImage imageWithContentsOfFile:self.path];
            //进行拉伸
            
            if (isLeft) {
                //单独气泡只有右边,需要进行翻转
                image=[UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUpMirrored];
                image=[image stretchableImageWithLeftCapWidth:20 topCapHeight:17];
                return image;
                    }
            image=[UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];

            image=[image stretchableImageWithLeftCapWidth:20 topCapHeight:17];

            return image;


        }else{
            if (isLeft) {
                if ([user objectForKey:@"theme"]==nil) {
                    //如果没有主题
                    self.path=[NSString stringWithFormat:@"%@/chat_recive_nor.png",[[NSBundle mainBundle]bundlePath]];
                }else{
                    self.path=[NSString stringWithFormat:@"%@/%@/chat_recive_nor.png",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject],[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]];
                }

                UIImage*image=[UIImage imageWithContentsOfFile:self.path];
                //进行拉伸
                image=[image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                return image;
            }else{
                if ([user objectForKey:@"theme"]==nil) {
                    self.path=[NSString stringWithFormat:@"%@/chat_send_nor.png",[[NSBundle mainBundle]bundlePath]];
                    
                }else{
                    self.path=[NSString stringWithFormat:@"%@/%@/chat_send_nor.png",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject],[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]];
                }
                

                UIImage*image=[UIImage imageWithContentsOfFile:self.path];
                //进行拉伸
                image=[image stretchableImageWithLeftCapWidth:40 topCapHeight:22];
                return image;
            
            }
            
        }

}
#pragma mark 结合XMPP使用的,单独使用请删掉
//测试数据
-(void)configWithXMPP_Model:(XMPPMessageArchiving_Message_CoreDataObject *)object leftImage:(UIImage *)leftImage rightImage:(UIImage *)right
{
    if (object.timestamp) {
        timeLabel.hidden=NO;
        //判断时间
        timeLabel.text=[self format:object.timestamp];
    }else{
        timeLabel.hidden=YES;
    }

    
    if (leftImage==nil) {
        leftImage=[UIImage imageNamed:@"logo_2"];
    }
    if (right==nil) {
        right=[UIImage imageNamed:@"logo_2"];
    }
    leftImageView.image=leftImage;
    rightImageView.image=right;
    if (object.message.body.length<3) {
        //需要做异常处理
        _str=object.message.body;
        return;
    }
    rightBubbleImageView.image=[self imageNameToImageLeftOrRight:NO];
    leftBubbleImageView.image=[self imageNameToImageLeftOrRight:YES];
    //获取内容
    self.str=[object.message.body substringFromIndex:3];
    //获取类型
    NSString*type=[object.message.body substringToIndex:3];
    
    //需要判断是否是自己
    if (object.isOutgoing) {
        //自己
        leftImageView.hidden=YES;
        leftBubbleImageView.hidden=YES;
        rightImageView.hidden=NO;
        rightBubbleImageView.hidden=NO;
        //判断类型
        if ([type isEqualToString:MESSAGE_STR]) {
            rightTextView.hidden=NO;
            rightPhotoButton.hidden=YES;
            rightVoiceImageView.hidden=YES;
            rightBigImageView.hidden=YES;
            rightLocationButton.hidden=YES;
            
            rightTextView.mmText=_str;
           CGSize size= [rightTextView sizeThatFits:CGSizeMake(200, 1000)];
            rightBubbleImageView.frame=CGRectMake(WIDTH-80-size.width, 15, size.width+40, size.height+20);
            rightTextView.frame=CGRectMake(20, 10, size.width, size.height+20);
        
        }else{
            if ([type isEqualToString:MESSAGE_VOICE]) {
                rightTextView.hidden=YES;
                rightPhotoButton.hidden=YES;
                rightVoiceImageView.hidden=NO;
                rightBigImageView.hidden=YES;
                rightLocationButton.hidden=YES;

                
                //语音
                rightBubbleImageView.frame=CGRectMake(WIDTH-40-70, 15, 50, 40);
                
                
            }else{
                if ([type isEqualToString:MESSAGE_IMAGESTR]) {
                    //文字转换为图片
                    rightTextView.hidden=YES;
                    rightPhotoButton.hidden=NO;
                    rightVoiceImageView.hidden=YES;
                    rightBigImageView.hidden=YES;
                    rightLocationButton.hidden=YES;

                    UIImage*image=[Photo string2Image:self.str];
                    //?: 三目表达式
                    CGFloat w=[self imageToSize:image].width;
                    CGFloat h=[self imageToSize:image].height;
                    rightBubbleImageView.frame=CGRectMake(WIDTH-40-w-40, 15, w+40, h+40);
                    rightPhotoButton.frame=CGRectMake(20, 20, w, h);
                    
                    [rightPhotoButton setImage:image forState:UIControlStateNormal];

                   
                    
                }else{
                    if ([type isEqualToString:MESSAGE_BIGIMAGESTR]) {
                        rightTextView.hidden=YES;
                        rightPhotoButton.hidden=YES;
                        rightVoiceImageView.hidden=YES;
                        rightBigImageView.hidden=NO;
                        rightLocationButton.hidden=YES;
                        rightBubbleImageView.frame=CGRectMake(WIDTH-40-110, 15, 100, 100);
                        rightBigImageView.image=nil;
                        rightBubbleImageView.image=nil;
                        [[MMEmotionCentre defaultCentre]fetchEmojisByType:MMFetchTypeBig codes:@[self.str] completionHandler:^(NSArray *emojis, NSError *error) {
                            
                            NSLog(@"%@",emojis);
                            if (emojis.count>0) {
                                MMEmoji*x=[emojis firstObject];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                rightBigImageView.image=x.emojiImage;     
                                });
                               
                            }

                        }];
           
                    }else{
                        if ([type isEqualToString:MESSAGE_LOCATION]) {
                            rightTextView.hidden=YES;
                            rightPhotoButton.hidden=YES;
                            rightVoiceImageView.hidden=YES;
                            rightBigImageView.hidden=YES;
                            rightLocationButton.hidden=NO;
                            rightBubbleImageView.frame=CGRectMake(WIDTH-40-110, 15, 100, 100);
                            
                        }else{
                            rightTextView.hidden=NO;
                            rightPhotoButton.hidden=YES;
                            rightVoiceImageView.hidden=YES;
                            rightBigImageView.hidden=YES;
                            rightLocationButton.hidden=YES;
                            
                            rightTextView.mmText=_str;
                            CGSize size= [rightTextView sizeThatFits:CGSizeMake(200, 1000)];
                            rightBubbleImageView.frame=CGRectMake(WIDTH-80-size.width, 15, size.width+40, size.height+20);
                            rightTextView.frame=CGRectMake(20, 10, size.width, size.height+20);

                        }
                    }
                
                
                }
                
                
            }
        
        }
        
        
        
        
    }else{
        //对方
        leftImageView.hidden=NO;
        leftBubbleImageView.hidden=NO;
        rightImageView.hidden=YES;
        rightBubbleImageView.hidden=YES;
        
        if ([type isEqualToString:MESSAGE_STR]) {
            leftTextView.hidden=NO;
            leftPhotoButton.hidden=YES;
            leftVoiceImageView.hidden=YES;
            leftBigImageView.hidden=YES;
            leftLocationButton.hidden=YES;
            leftTextView.mmText=_str;
            CGSize size=[leftTextView sizeThatFits:CGSizeMake(200, 1000)];
            leftBubbleImageView.frame=CGRectMake(40, 15, size.width+40, size.height+20);
            leftTextView.frame=CGRectMake(10, 10, size.width+20, size.height+20);
            
        }else{
            if ([type isEqualToString:MESSAGE_VOICE]) {
                leftTextView.hidden=YES;
                leftPhotoButton.hidden=YES;
                leftVoiceImageView.hidden=NO;
                leftBigImageView.hidden=YES;
                leftLocationButton.hidden=YES;
                leftBubbleImageView.frame=CGRectMake(40, 15, 50, 40);
            }else{
                if ([type isEqualToString:MESSAGE_IMAGESTR]) {
                    leftTextView.hidden=YES;
                    leftPhotoButton.hidden=NO;
                    leftVoiceImageView.hidden=YES;
                    leftBigImageView.hidden=YES;
                    leftLocationButton.hidden=YES;
                    
                    UIImage*image=[Photo string2Image:self.str];
                    CGFloat w=[self imageToSize:image].width;
                    CGFloat h=[self imageToSize:image].height;
                    leftBubbleImageView.frame=CGRectMake(40, 15, w+40, h+40);
                    leftPhotoButton.frame=CGRectMake(20, 20, w, h);
                    [leftPhotoButton setBackgroundImage:image forState:UIControlStateNormal];
                    
                }else{
                    if ([type isEqualToString:MESSAGE_BIGIMAGESTR]) {
                        leftTextView.hidden=YES;
                        leftPhotoButton.hidden=YES;
                        leftVoiceImageView.hidden=YES;
                        leftBigImageView.hidden=NO;
                        leftLocationButton.hidden=YES;
                        leftBubbleImageView.frame=CGRectMake(40, 15, 100, 100);
                        leftBubbleImageView.image=nil;
                        leftBigImageView.image=nil;
                        [[MMEmotionCentre defaultCentre]fetchEmojisByType:MMFetchTypeBig codes:@[self.str] completionHandler:^(NSArray *emojis, NSError *error) {
                            
                            if (emojis.count>0) {
                                MMEmoji*x=[emojis firstObject];
                                leftBigImageView.image=x.emojiImage;
                            }
                            
                        }];
                        
                    }else{
                        if ([type isEqualToString:MESSAGE_LOCATION]) {
                            leftTextView.hidden=YES;
                            leftPhotoButton.hidden=YES;
                            leftVoiceImageView.hidden=YES;
                            leftBigImageView.hidden=YES;
                            leftLocationButton.hidden=NO;
                            leftBubbleImageView.frame=CGRectMake(40, 15, 100, 100);

                        }else{
                            leftTextView.hidden=NO;
                            leftPhotoButton.hidden=YES;
                            leftVoiceImageView.hidden=YES;
                            leftBigImageView.hidden=YES;
                            leftLocationButton.hidden=YES;
                            leftTextView.mmText=_str;
                            CGSize size=[leftTextView sizeThatFits:CGSizeMake(200, 1000)];
                            leftBubbleImageView.frame=CGRectMake(40, 15, size.width+40, size.height+20);
                            leftTextView.frame=CGRectMake(10, 10, size.width+20, size.height+20);
                        
                        }
                        
                    }
                    
                }
                
            
            }
        
        }
        
        
        
        
    }
    


}

-(void)configWithCustomModel:(MessageModel *)object leftImage:(UIImage *)leftImage rightImage:(UIImage *)right
{
    if (object.timestamp) {
        timeLabel.hidden=NO;
        //判断时间
        timeLabel.text=[self format:object.timestamp];
    }else{
        timeLabel.hidden=YES;
    }
    
    
    if (leftImage==nil) {
        leftImage=[UIImage imageNamed:@"logo_2"];
    }
    if (right==nil) {
        right=[UIImage imageNamed:@"logo_2"];
    }
    leftImageView.image=leftImage;
    rightImageView.image=right;
    if (object.body.length<3) {
        //需要做异常处理
        _str=object.body;
        return;
    }
    rightBubbleImageView.image=[self imageNameToImageLeftOrRight:NO];
    leftBubbleImageView.image=[self imageNameToImageLeftOrRight:YES];
    //获取内容
    self.str=[object.body substringFromIndex:3];
    //获取类型
    NSString*type=[object.body substringToIndex:3];
    
    //需要判断是否是自己
    if (object.isOutgoing) {
        //自己
        leftImageView.hidden=YES;
        leftBubbleImageView.hidden=YES;
        rightImageView.hidden=NO;
        rightBubbleImageView.hidden=NO;
        //判断类型
        if ([type isEqualToString:MESSAGE_STR]) {
            rightTextView.hidden=NO;
            rightPhotoButton.hidden=YES;
            rightVoiceImageView.hidden=YES;
            rightBigImageView.hidden=YES;
            rightLocationButton.hidden=YES;
            
            rightTextView.mmText=_str;
            CGSize size= [rightTextView sizeThatFits:CGSizeMake(200, 1000)];
            rightBubbleImageView.frame=CGRectMake(WIDTH-80-size.width, 15, size.width+40, size.height+20);
            rightTextView.frame=CGRectMake(20, 10, size.width, size.height+20);
            
        }else{
            if ([type isEqualToString:MESSAGE_VOICE]) {
                rightTextView.hidden=YES;
                rightPhotoButton.hidden=YES;
                rightVoiceImageView.hidden=NO;
                rightBigImageView.hidden=YES;
                rightLocationButton.hidden=YES;
                
                
                //语音
                rightBubbleImageView.frame=CGRectMake(WIDTH-40-70, 15, 50, 40);
                
                
            }else{
                if ([type isEqualToString:MESSAGE_IMAGESTR]) {
                    //文字转换为图片
                    rightTextView.hidden=YES;
                    rightPhotoButton.hidden=NO;
                    rightVoiceImageView.hidden=YES;
                    rightBigImageView.hidden=YES;
                    rightLocationButton.hidden=YES;
                    
                    UIImage*image=[Photo string2Image:self.str];
                    //?: 三目表达式
                    CGFloat w=[self imageToSize:image].width;
                    CGFloat h=[self imageToSize:image].height;
                    rightBubbleImageView.frame=CGRectMake(WIDTH-40-w-40, 15, w+40, h+40);
                    rightPhotoButton.frame=CGRectMake(20, 20, w, h);
                    
                    [rightPhotoButton setImage:image forState:UIControlStateNormal];
                    
                    
                    
                }else{
                    if ([type isEqualToString:MESSAGE_BIGIMAGESTR]) {
                        rightTextView.hidden=YES;
                        rightPhotoButton.hidden=YES;
                        rightVoiceImageView.hidden=YES;
                        rightBigImageView.hidden=NO;
                        rightLocationButton.hidden=YES;
                        rightBubbleImageView.frame=CGRectMake(WIDTH-40-110, 15, 100, 100);
                        rightBigImageView.image=nil;
                        rightBubbleImageView.image=nil;
                        [[MMEmotionCentre defaultCentre]fetchEmojisByType:MMFetchTypeBig codes:@[self.str] completionHandler:^(NSArray *emojis, NSError *error) {
                            
                            NSLog(@"%@",emojis);
                            if (emojis.count>0) {
                                MMEmoji*x=[emojis firstObject];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    rightBigImageView.image=x.emojiImage;
                                });
                                
                            }
                            
                        }];
                        
                    }else{
                        if ([type isEqualToString:MESSAGE_LOCATION]) {
                            rightTextView.hidden=YES;
                            rightPhotoButton.hidden=YES;
                            rightVoiceImageView.hidden=YES;
                            rightBigImageView.hidden=YES;
                            rightLocationButton.hidden=NO;
                            rightBubbleImageView.frame=CGRectMake(WIDTH-40-110, 15, 100, 100);
                            
                        }else{
                            rightTextView.hidden=NO;
                            rightPhotoButton.hidden=YES;
                            rightVoiceImageView.hidden=YES;
                            rightBigImageView.hidden=YES;
                            rightLocationButton.hidden=YES;
                            
                            rightTextView.mmText=_str;
                            CGSize size= [rightTextView sizeThatFits:CGSizeMake(200, 1000)];
                            rightBubbleImageView.frame=CGRectMake(WIDTH-80-size.width, 15, size.width+40, size.height+20);
                            rightTextView.frame=CGRectMake(20, 10, size.width, size.height+20);
                            
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                
            }
            
        }
        
        
        
        
    }else{
        //对方
        leftImageView.hidden=NO;
        leftBubbleImageView.hidden=NO;
        rightImageView.hidden=YES;
        rightBubbleImageView.hidden=YES;
        
        if ([type isEqualToString:MESSAGE_STR]) {
            leftTextView.hidden=NO;
            leftPhotoButton.hidden=YES;
            leftVoiceImageView.hidden=YES;
            leftBigImageView.hidden=YES;
            leftLocationButton.hidden=YES;
            leftTextView.mmText=_str;
            CGSize size=[leftTextView sizeThatFits:CGSizeMake(200, 1000)];
            leftBubbleImageView.frame=CGRectMake(40, 15, size.width+40, size.height+20);
            leftTextView.frame=CGRectMake(10, 10, size.width+20, size.height+20);
            
        }else{
            if ([type isEqualToString:MESSAGE_VOICE]) {
                leftTextView.hidden=YES;
                leftPhotoButton.hidden=YES;
                leftVoiceImageView.hidden=NO;
                leftBigImageView.hidden=YES;
                leftLocationButton.hidden=YES;
                leftBubbleImageView.frame=CGRectMake(40, 15, 50, 40);
            }else{
                if ([type isEqualToString:MESSAGE_IMAGESTR]) {
                    leftTextView.hidden=YES;
                    leftPhotoButton.hidden=NO;
                    leftVoiceImageView.hidden=YES;
                    leftBigImageView.hidden=YES;
                    leftLocationButton.hidden=YES;
                    
                    UIImage*image=[Photo string2Image:self.str];
                    CGFloat w=[self imageToSize:image].width;
                    CGFloat h=[self imageToSize:image].height;
                    leftBubbleImageView.frame=CGRectMake(40, 15, w+40, h+40);
                    leftPhotoButton.frame=CGRectMake(20, 20, w, h);
                    [leftPhotoButton setBackgroundImage:image forState:UIControlStateNormal];
                    
                }else{
                    if ([type isEqualToString:MESSAGE_BIGIMAGESTR]) {
                        leftTextView.hidden=YES;
                        leftPhotoButton.hidden=YES;
                        leftVoiceImageView.hidden=YES;
                        leftBigImageView.hidden=NO;
                        leftLocationButton.hidden=YES;
                        leftBubbleImageView.frame=CGRectMake(40, 15, 100, 100);
                        leftBubbleImageView.image=nil;
                        leftBigImageView.image=nil;
                        [[MMEmotionCentre defaultCentre]fetchEmojisByType:MMFetchTypeBig codes:@[self.str] completionHandler:^(NSArray *emojis, NSError *error) {
                            
                            if (emojis.count>0) {
                                MMEmoji*x=[emojis firstObject];
                                leftBigImageView.image=x.emojiImage;
                            }
                            
                        }];
                        
                    }else{
                        if ([type isEqualToString:MESSAGE_LOCATION]) {
                            leftTextView.hidden=YES;
                            leftPhotoButton.hidden=YES;
                            leftVoiceImageView.hidden=YES;
                            leftBigImageView.hidden=YES;
                            leftLocationButton.hidden=NO;
                            leftBubbleImageView.frame=CGRectMake(40, 15, 100, 100);
                            
                        }else{
                            leftTextView.hidden=NO;
                            leftPhotoButton.hidden=YES;
                            leftVoiceImageView.hidden=YES;
                            leftBigImageView.hidden=YES;
                            leftLocationButton.hidden=YES;
                            leftTextView.mmText=_str;
                            CGSize size=[leftTextView sizeThatFits:CGSizeMake(200, 1000)];
                            leftBubbleImageView.frame=CGRectMake(40, 15, size.width+40, size.height+20);
                            leftTextView.frame=CGRectMake(10, 10, size.width+20, size.height+20);
                            
                        }
                        
                    }
                    
                }
                
                
            }
            
        }
        
        
        
        
    }
    
    
    
}


-(CGSize)imageToSize:(UIImage*)image{

    CGSize size=image.size;
    
 //宽度限定在200以内
    if (size.width>200) {
        size.width=200;
        //计算高度
        size.height=size.width/image.size.width*size.height;
        if (size.height>200) {
            size.height=200;
            //压缩宽度
            size.width=size.height/image.size.height*image.size.width;
        }
        
    }else{
        size.height=size.width/image.size.width*size.height;
        if (size.height>200) {
            size.height=200;
            //压缩宽度
            size.width=size.width/image.size.height*image.size.width;
        }
        
    }
   
    
    return size;


}
//放大和缩小图片
-(void)buttonScaleClick:(UIButton*)button{
    //放大,在当前页面上面进行放大和缩小
    
    
    if (oldRect.origin.x==0) {
        //移动到顶层VC上
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *topVC = appRootVC;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        button.layer.cornerRadius=0;
        oldRect=button.frame;
        view=button.superview;
         button.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [topVC.view addSubview:button];

      
      
        
    }else{
        button.layer.cornerRadius=15;
        [UIView animateWithDuration:0.3 animations:^{
            button.frame=oldRect;
            oldRect=CGRectZero;
            [view addSubview:button];
            view=nil;
        
        }];
      
    }
    

}

+(CGFloat)contentStrToHeight:(NSString*)str;

{
    if (str.length<3) {
        //需要做异常处理
        return 0;
    }
   //获取类型
    NSString*type=[str substringToIndex:3];
    //获取内容
    NSString*content=[str substringFromIndex:3];

    if ([type isEqualToString:MESSAGE_STR]) {
       MMTextView*tempTextView= [[MMTextView alloc]initWithFrame:CGRectZero];
        
        tempTextView.mmText=content;
        CGSize size=[tempTextView sizeThatFits:CGSizeMake(200, 1000)];
        return  size.height+45;
    
    }else{
        if ([type isEqualToString:MESSAGE_VOICE]) {
        
            return 45;
        }else{
            if ([type isEqualToString:MESSAGE_IMAGESTR]) {
              
                UIImage*image=[Photo string2Image:content];
                CGSize size=image.size;
                
                //宽度限定在200以内
                if (size.width>200) {
                    size.width=200;
                }
                if (size.height>200) {
                    size.height=size.width/image.size.width*size.height;
                }
                if (size.height>200) {
                    size.height=200;
                    //压缩宽度
                    size.width=size.height/image.size.height*size.width;
                }
                //宽高+40;
                return size.height+60;
                
            }else{
                if ([type isEqualToString:MESSAGE_BIGIMAGESTR]) {

                    return 115;
                }else{
                
                    if ([type isEqualToString:MESSAGE_LOCATION]) {
                        return 115;
                    }else{
                        MMTextView*tempTextView= [[MMTextView alloc]initWithFrame:CGRectZero];
                        
                        tempTextView.mmText=content;
                        CGSize size=[tempTextView sizeThatFits:CGSizeMake(200, 1000)];
                        return  size.height+45;
                    }
                }
                    
                
                
            }
        }
    }

    

}

#pragma mark 日期的转换
-(NSString *)format:(NSDate *)date{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
//    NSDate*inputDate = [inputFormatter dateFromString:string];
    //NSLog(@"startDate= %@", inputDate);
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    NSString *str= [outputFormatter stringFromDate:date];
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:str];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
    //NSLog(@"endDate:%@",endDate);
    NSString *lastTime = [self compareDate:endDate];
    NSLog(@"lastTime = %@",lastTime);
    return lastTime;
}

-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
}
+(UIFont*)customFont
{

    return [UIFont systemFontOfSize:10];

//   NSString*fileName= [[NSUserDefaults standardUserDefaults]objectForKey:@"fontnum"];
//    if (fileName) {
//        NSURL *fontUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/%@.ttf",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject],fileName,fileName]];
//        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
//        CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
//        CGDataProviderRelease(fontDataProvider);
//        CTFontManagerRegisterGraphicsFont(fontRef, NULL);
//        NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
//        UIFont *font = [UIFont fontWithName:fontName size:10];
//        CGFontRelease(fontRef);
//        return font;
//    }else{
//        return [UIFont systemFontOfSize:10];
//    
//    }
    
   
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
