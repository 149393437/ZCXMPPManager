//
//  ZCControl.h
//  Day16_LoginDemo
//
//  Created by zhangcheng on 16/1/12.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

/*
 本类用于对控件的基本封装,使用工厂模式进行创建,简化了代码量
 2016.1.12 第一版
 初始创建
 
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LFZCControl : NSObject
//创建View
+(UIView*)createViewWithFrame:(CGRect)frame;

//创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Text:(NSString*)text;

//创建ImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;

//创建Button
+(UIButton*)createButtonWithFrame:(CGRect)frame Target:(id)target Method:(SEL)method Title:(NSString*)title ImageName:(NSString*)imageName BgImageName:(NSString*)bgImageName;

//创建TextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString*)placeholder Text:(NSString*)text LeftView:(UIImageView*)leftView RightView:(UIImageView*)rightView BgImageName:(NSString*)bgImageName;



@end








