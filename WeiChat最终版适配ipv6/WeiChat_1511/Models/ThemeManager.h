//
//  ThemeManager.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/9.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//
//                  佛祖保佑            永无bug
//     _                            _
// ___| |__   __ _ _ __   __ _  ___| |__   ___ _ __   __ _
//|_  / '_ \ / _` | '_ \ / _` |/ __| '_ \ / _ \ '_ \ / _` |
// / /| | | | (_| | | | | (_| | (__| | | |  __/ | | | (_| |
///___|_| |_|\__,_|_| |_|\__, |\___|_| |_|\___|_| |_|\__, |
//                       |___/                       |___/

//小张诚技术博客http://blog.sina.com.cn/u/2914098025
//github代码地址https://github.com/149393437
//欢迎加入iOS研究院 QQ群号305044955    你的关注就是我开源的动力

#import <Foundation/Foundation.h>
#import "themeColorDefind.h"
@interface ThemeManager : NSObject
{
    UIAlertView*alertView;

}

//记录当前有多少种主题
@property(nonatomic,strong)NSMutableArray*themeArray;
//主题下载文件的路径,用于持久化保存使用
@property(nonatomic,copy)NSString*themePath;
//保存当前下载主题的名字
@property(nonatomic,copy)NSString*themeName;

//记录当前有多少种气泡
@property(nonatomic,strong)NSMutableArray*bubbleArray;
//气泡下载文件的路径,用于持久化保存使用
@property(nonatomic,copy)NSString*bubblePath;
//保存当前下载气泡的名字
@property(nonatomic,copy)NSString*bubbleName;

//记录当前有多少种聊天背景
@property(nonatomic,strong)NSMutableArray*chatBgNameArray;
//记录聊天背景图片路径,用于持久保存
@property(nonatomic,copy)NSString*chatBgPath;
//保存当前下载聊天背景的名字
@property(nonatomic,copy)NSString*chatBgName;

//记录当前有多少种聊天背景
@property(nonatomic,strong)NSMutableArray*fontArray;
//记录聊天背景图片路径,用于持久保存
@property(nonatomic,copy)NSString*fontPath;
//保存当前下载聊天背景的数字
@property(nonatomic,copy)NSString*fontNum;


//创建单例
+(id)shareManager;

//进行主题下载
-(void)downLoadThemeWithDic:(NSDictionary*)dic;
//进行气泡下载
-(void)downLoadBubbleWithDic:(NSDictionary *)dic;
//进行聊天背景下载
-(void)downLoadChatBgWithDic:(NSDictionary*)dic;
//进行字符下载
-(void)downLoadFontWithDic:(NSDictionary*)dic;



//主题对应文字的颜色
+(UIColor*)themeColorStrToColor:(NSString*)name;



@end
