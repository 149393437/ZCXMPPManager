//
//  UMComFindTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15-3-31.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComFindTableViewCell.h"
#import "UMComTools.h"

@implementation UMComFindTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleNameLabel.font = UMComFontNotoSansLightWithSafeSize(17);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)drawRect:(CGRect)rect
{
    UIColor *color = UMComColorWithColorValueString(UMCom_Feed_BgColor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat height = 2;
    CGRect drawFrame = CGRectMake(15, rect.size.height - height, rect.size.width-15, height);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, drawFrame);
}

@end
