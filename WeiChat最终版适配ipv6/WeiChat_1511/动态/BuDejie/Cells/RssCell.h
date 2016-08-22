//
//  RssCell.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/1.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RssModel.h"
@interface RssCell : UITableViewCell
{
    //头像
    UIImageView*headerImageView;
    
    //标题
    UILabel*titleLabel;
    
    //订阅数量
    UILabel*subNumLabel;
    
    //订阅button
    UIButton*subButton;
    

}
-(void)config:(RssModel*)model;
@end
