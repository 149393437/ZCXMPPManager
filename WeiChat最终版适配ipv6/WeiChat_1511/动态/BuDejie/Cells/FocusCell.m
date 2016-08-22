//
//  FocusCell.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/1.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "FocusCell.h"

@implementation FocusCell
-(void)configFocusModel:(FocusModel*)model
{
    //修改订阅的坐标
    subButton.frame=CGRectMake(WIDTH-140, 20, 60, 30);
    
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.header] placeholderImage:[UIImage imageNamed:@"imageBackground.png"]];
    
    titleLabel.text=model.screen_name;
    
    CGFloat num=[model.fans_count integerValue]/10000.0;
    
    subNumLabel.text=[NSString stringWithFormat:@"%.02lf万人关注",num];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
