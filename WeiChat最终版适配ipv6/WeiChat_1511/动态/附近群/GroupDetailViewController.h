//
//  GrouoDetailViewController.h
//  weiChat
//
//  Created by ZhangCheng on 14/7/5.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "RootViewController.h"

@interface GroupDetailViewController : RootViewController<UIAlertViewDelegate>
{
    //背景图
    UIImageView*succeedImageView;
    //描述
    UILabel*desLabel;
    //当前人数
    UILabel*numLabel;
    //创建日期
    UILabel*timeLabel;
    //进入
    UIButton*createButton;
    //群号
    UILabel*subjectLabel;

}
@property(nonatomic,copy)NSString*groupNum;
@property(nonatomic,retain)NSDictionary*roomConfigDic;
@property(nonatomic,assign)XMPPRoom*room;
@end
