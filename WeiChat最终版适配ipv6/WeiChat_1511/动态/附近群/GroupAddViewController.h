//
//  GroupAddViewController.h
//  weiChat
//
//  Created by ZhangCheng on 14/7/3.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "RootViewController.h"

@interface GroupAddViewController : RootViewController<UISearchBarDelegate>
{
    UIImageView*errorImageView;
    //背景图
    UIImageView*succeedImageView;
    //主题
    UILabel*subjectLabel;
    //描述
    UILabel*desLabel;
    //当前人数
    UILabel*numLabel;
    //创建日期
    UILabel*timeLabel;
    //进入
    UIButton*createButton;
    
    NSString*searchStr;
 
    
    
    
}
@property(nonatomic,copy)NSString*resultStr;
@end
