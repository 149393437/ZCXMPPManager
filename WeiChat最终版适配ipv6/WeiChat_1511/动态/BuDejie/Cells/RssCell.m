//
//  RssCell.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/1.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RssCell.h"

@implementation RssCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    headerImageView=[LFZCControl createImageViewWithFrame:CGRectMake(10, 10, 60, 60) ImageName:@""];
    headerImageView.layer.cornerRadius=5;
    headerImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:headerImageView];
    
    titleLabel=[LFZCControl createLabelWithFrame:CGRectMake(80, 10, 200, 20) Font:20 Text:nil];
    titleLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:titleLabel];
    
    subNumLabel=[LFZCControl createLabelWithFrame:CGRectMake(80, 50, 200, 15) Font:15 Text:nil];
    subNumLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:subNumLabel];
    
    subButton=[LFZCControl createButtonWithFrame:CGRectMake(WIDTH-80, 20, 60, 30) Target:self Method:@selector(subButtonClick) Title:@"+订阅" ImageName:nil BgImageName:nil];
    [subButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.contentView addSubview:subButton];


}
-(void)subButtonClick{


}
-(void)config:(RssModel *)model
{
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.image_list] placeholderImage:[UIImage imageNamed:@"imageBackground.png"]];
    
    NSString*numStr=model.sub_number;
    CGFloat num=[numStr integerValue]/10000.0;
    
    subNumLabel.text=[NSString stringWithFormat:@"%.02lf万人订阅",num];
    
    titleLabel.text=model.theme_name;

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
