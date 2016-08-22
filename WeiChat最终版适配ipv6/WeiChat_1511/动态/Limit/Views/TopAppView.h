//
//  TopAppView.h
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "AppModel.h"
@class TopViewController;
@interface TopAppView : UIView
{
    UIImageView*appNameImageView;
    UILabel*appLabel;
    UILabel*commentLabel;
    UILabel*downLabel;
    UIImageView*commentImageView;
    UIImageView*downImageView;
    StarView*starView;
}
@property(assign,nonatomic)TopViewController*vc;
//记录一个appid
@property(nonatomic,copy)NSString*appid;
-(void)configModel:(AppModel*)model;
@end





