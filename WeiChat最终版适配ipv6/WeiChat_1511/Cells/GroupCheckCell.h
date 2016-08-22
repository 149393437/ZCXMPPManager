//
//  GroupCheckCell.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;

@property (weak, nonatomic) IBOutlet UIImageView *groupHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property(nonatomic,strong)NSDictionary*dicData;
-(void)config:(NSDictionary*)dic;

@end
