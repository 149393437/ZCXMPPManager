
//
//  CommentCell.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/2.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self makeUI];
    }
    
    return self;
}
-(void)makeUI{
    headerImageView=[ZCControl createImageViewWithFrame:CGRectMake(5, 5, 30, 30) ImageName:@"defaultUserIcon.png"];
    headerImageView.layer.cornerRadius=15;
    headerImageView.layer.masksToBounds=YES;
    
    [self.contentView addSubview:headerImageView];
    
    sexImageView=[ZCControl createImageViewWithFrame:CGRectMake(35, 5, 10, 10) ImageName:nil];
    [self.contentView addSubview:sexImageView];
    
    userNameLabel=[ZCControl createLabelWithFrame:CGRectMake(45, 5, 200, 15) Font:12 Text:nil];
    [self.contentView addSubview:userNameLabel];
    
    connectLabel=[ZCControl createLabelWithFrame:CGRectMake(45, 20, 200, 10) Font:10 Text:nil];
    [self.contentView addSubview:connectLabel];
    
    //右边的赞
    zanImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-30, 5, 10, 10) ImageName:@"mainCellDing.png"];
    [self.contentView addSubview:zanImageView];
    
    zanLabel=[ZCControl createLabelWithFrame:CGRectMake(WIDTH-30,20, 10, 10) Font:10 Text:nil];
    [self.contentView addSubview:zanLabel];
    
    
    
}
-(void)config:(CommentModel *)model
{
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.user[@"profile_image"]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon.png"]];
    
    if ([model.user[@"sex"] isEqualToString:@"m"]) {
        //男
        sexImageView.image=[UIImage imageNamed:@"Profile_manIcon.png"];
    }else{
        sexImageView.image=[UIImage imageNamed:@"Profile_womanIcon.png"];

    }
    
    userNameLabel.text=model.user[@"username"];
    
    connectLabel.text=model.content;
    
    zanLabel.text=model.like_count;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
