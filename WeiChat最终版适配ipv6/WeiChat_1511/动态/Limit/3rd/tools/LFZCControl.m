//
//  ZCControl.m
//  Day16_LoginDemo
//
//  Created by zhangcheng on 16/1/12.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "LFZCControl.h"

@implementation LFZCControl
//创建View
+(UIView*)createViewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    
    return view;
}

//创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Text:(NSString*)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    
    //设置字体大小
    label.font=[UIFont systemFontOfSize:font];
    
    //设置文字
    label.text=text;
    
    //设置对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    
    //设置折行
    label.numberOfLines=0;
    
    return label;

}

//创建ImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    
    //交互属性默认是关闭
    imageView.userInteractionEnabled=YES;
    
    return imageView;
}

//创建Button
+(UIButton*)createButtonWithFrame:(CGRect)frame Target:(id)target Method:(SEL)method Title:(NSString*)title ImageName:(NSString*)imageName BgImageName:(NSString*)bgImageName
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    button.frame=frame;
    return button;
}

//创建TextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString*)placeholder Text:(NSString*)text LeftView:(UIImageView*)leftView RightView:(UIImageView*)rightView BgImageName:(NSString*)bgImageName{

    UITextField*textFiled=[[UITextField alloc]initWithFrame:frame];
    
    if (placeholder) {
        textFiled.placeholder=placeholder;
    }
    if (text) {
        textFiled.text=text;
    }
    if (leftView) {
        textFiled.leftView=leftView;
        textFiled.leftViewMode=UITextFieldViewModeAlways;
    }
    if (rightView) {
        textFiled.rightView=rightView;
        textFiled.rightViewMode=UITextFieldViewModeAlways;
    }
    if (bgImageName) {
        [textFiled setBackground:[UIImage imageNamed:bgImageName]];
    }
    textFiled.clearButtonMode=UITextFieldViewModeAlways;
    
    return textFiled;
}
@end





