//
//  TopCell.h
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopViewController;
@interface TopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *desImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (assign,nonatomic)TopViewController*vc;

//参数设置
-(void)configDic:(NSDictionary*)dic;


@end
