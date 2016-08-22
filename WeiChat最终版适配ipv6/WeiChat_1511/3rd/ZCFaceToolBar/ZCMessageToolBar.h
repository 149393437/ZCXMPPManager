//  Created by zhangcheng on 16/3/14.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//     _                            _
// ___| |__   __ _ _ __   __ _  ___| |__   ___ _ __   __ _
//|_  / '_ \ / _` | '_ \ / _` |/ __| '_ \ / _ \ '_ \ / _` |
// / /| | | | (_| | | | | (_| | (__| | | |  __/ | | | (_| |
///___|_| |_|\__,_|_| |_|\__, |\___|_| |_|\___|_| |_|\__, |
//                       |___/                       |___/

//小张诚技术博客http://blog.sina.com.cn/u/2914098025
//github代码地址https://github.com/149393437
//欢迎加入iOS研究院 QQ群号305044955    你的关注就是我开源的动力

/*
 集成说明:
 1.增加libz库
 2.需要在info.plist中增加字段 对Http的支持,
 3.需要在info.plist中增加字段 增加定位字段NSLocationWhenInUseUsageDescription
 4.修改你对应表情MM的APPID,也可以使用我的
 
 代码:
 ZCMessageToolBar*toolBar=[[ZCMessageToolBar alloc]initWithBlock:^(NSString *sign, NSString *message) {
 NSLog(@"%@~~%@",sign,message);
 }];
 [self.view addSubview:toolBar];
 
 */


#import <UIKit/UIKit.h>

#import "XHMessageTextView.h"

#import "ZCChatBarMoreView.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kHorizontalPadding 8
#define kVerticalPadding 5
#define BQMM_APPID @"4d48577b82a54219be0515939c7521c9"
#define BQMM_SECRET @"7d125164fb4b42b6ae3da3fa5e3a933f"
#import <BQMM/BQMM.h>
#import "ZCChatAudioPlay.h"
#import "ZCControl.h"

/**
 *  类说明：
 *  1、推荐使用[initWithFrame:...]方法进行初始化
 *  2、提供默认的录音，表情，更多按钮的附加页面
 *  3、可自定义以上的附加页面
 增加plistNSLocationWhenInUseUsageDescription
 
 */

@interface ZCMessageToolBar : UIView<ZCChatBarMoreViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel*hudLabel;
    //输入框背景图
    UIImageView *imgView;
}
//进行模块化操作,使用block进行统一设置
@property(nonatomic,copy)void(^MyBlock)(NSString*,NSString*);
//2种风格设置 QQ风格和简约风格 默认简约风格
@property(nonatomic)BOOL isQQ;
//图片读取路径
@property(nonatomic,copy)NSString*path;
//语音
@property (strong, nonatomic) UIButton *recordButton;
//操作栏背景图片
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;


//背景图片
@property (strong, nonatomic) UIImage *backgroundImage;

//更多的附加页面
@property (strong, nonatomic) ZCChatBarMoreView *moreView;

//表情的附加页面
@property (strong, nonatomic) UIView *faceView;

//录音单例
@property (strong, nonatomic) ZCChatAudioPlay *audio;

//用于输入文本消息的输入框
@property (strong, nonatomic) XHMessageTextView *inputTextView;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;
-(instancetype)initWithBlock:(void(^)(NSString*sign,NSString*message))a;
-(void)hideKeyBorard;

@end


