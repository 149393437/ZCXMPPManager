//
//  AppCell.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "AppCell.h"

@implementation AppCell

- (void)awakeFromNib {
    // Initialization code
    
    _appIconImageView.layer.cornerRadius=30;
    _appIconImageView.layer.masksToBounds=YES;
}
-(void)configModel:(AppModel*)model
{
    [_appIconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"account_candou"]];
    
    _appName.text=model.name;
    
    _priceLabel.text=model.currentPrice;
    
    _shareLabel.text=[NSString stringWithFormat:@"分享:%@次  下载:%@次 收藏%@次",model.shares,model.downloads,model.favorites];
    
    _typeLabel.text=model.priceTrend;
    
    _categroyLabel.text=model.categoryName;
    
    [_starView configStarNum:[model.starCurrent floatValue]];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
