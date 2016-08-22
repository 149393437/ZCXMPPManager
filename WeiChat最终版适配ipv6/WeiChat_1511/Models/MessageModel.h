//
//  MessageModel.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/16.
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

/*
 模型说明
 属性         是否必须    备注
 timestamp,   否        有就会在cell中显示
 body         是        前面标记类型 [1]是文字 [2]是语音 [3]图片 [4]大表情 [5]定位
 isOutgoing   是        判断是否是自己  YES为自己
 
 */

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
//时间
@property(nonatomic)NSDate*timestamp;
//内容
@property(nonatomic,copy)NSString*body;
@property(nonatomic)BOOL isOutgoing;


@end
