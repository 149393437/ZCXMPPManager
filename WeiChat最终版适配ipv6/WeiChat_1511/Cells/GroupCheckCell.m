//
//  GroupCheckCell.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "GroupCheckCell.h"
#import "ZCXMPPManager.h"
#import "ThemeManager.h"
@implementation GroupCheckCell

- (void)awakeFromNib {
    self.groupHeaderImageView.layer.cornerRadius=15;
    self.groupHeaderImageView.layer.masksToBounds=YES;
    self.groupDesLabel.hidden=YES;
    // Initialization code
}
#pragma mark 同意
- (IBAction)agreeGroupCheck:(id)sender {
    /*
     同意 把该房间加入到房间列表中
     修改plist文件中的type值为2
     理由修改为请在群组中查看
     调用获取列表的block,刷新tableView
     */
    [[ZCXMPPManager sharedInstance]agreeRoom:self.dicData];
}
#pragma mark 拒绝
- (IBAction)rejectGroupCheck:(id)sender {
    [[ZCXMPPManager sharedInstance]rejectRoom:self.dicData];
    /*
     拒绝 修改plist文件中的type值为3
     调用获取列表的block,刷新tableView
     */
    
}
-(void)config:(NSDictionary*)dic
{
    self.dicData=[NSDictionary dictionaryWithDictionary:dic];
//    NSDictionary*dic=@{@"from":from,@"to":to,@"reason":reason,@"type":type,@"date":[NSDate date]};
    _groupLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    [_agreeButton setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
    [_rejectButton setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
//判断类型
    /*type
     0 别人拒绝
     1 别人邀请
     2 已经加入
     3 已经拒绝
     */
   NSString*str= [[self.dicData[@"reason"]stringByReplacingOccurrencesOfString:@"{" withString:@""]stringByReplacingOccurrencesOfString:@"}" withString:@""];
    _groupLabel.text=str;

    switch ([self.dicData[@"type"]intValue]) {
        case 1:
        {
            //被邀请 等待同意或者拒绝
            _agreeButton.hidden=NO;
            _rejectButton.hidden=NO;
            _agreeLabel.hidden=YES;

            
        }
            break;
        case 0:
        {
            //别人拒绝了我的邀请
            _agreeButton.hidden=YES;
            _rejectButton.hidden=YES;
            _agreeLabel.hidden=YES;
        }
            break;
        case 2:
        {
            //已经加入
            _agreeButton.hidden=YES;
            _rejectButton.hidden=YES;
            _agreeLabel.hidden=NO;
            _agreeLabel.text=@"同意";
        }
            break;
        case 3:
        {
            //已经拒绝对方的邀请
            _agreeButton.hidden=YES;
            _rejectButton.hidden=YES;
            _agreeLabel.hidden=NO;
            _agreeLabel.text=@"拒绝";
        }
            break;
            
        default:
            break;
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
