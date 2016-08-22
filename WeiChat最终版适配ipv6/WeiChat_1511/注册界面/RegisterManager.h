//
//  RegisterManager.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
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

//本注册类,用于多个界面之间的传值操作
#import <Foundation/Foundation.h>

@interface RegisterManager : NSObject
//用户名
@property(nonatomic,copy)NSString*userName;
//昵称
@property(nonatomic,copy)NSString*nickName;
//头像
@property(nonatomic)UIImage*headerImage;
//生日
@property(nonatomic,copy)NSString*birthday;
//性别
@property(nonatomic,copy)NSString*sex;
//手机号
@property(nonatomic,copy)NSString*phoneNum;
//密码
@property(nonatomic,copy)NSString*passWord;
//签名
@property(nonatomic,copy)NSString*qmd;
//地址
@property(nonatomic,copy)NSString*address;

+(instancetype)shareManager;

@end













