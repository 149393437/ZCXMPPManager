//
//  UMComTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15-3-31.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComTableViewCell.h"
#import "UMComTools.h"

@implementation UMComTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.customLeftEdge = 0;
    self.customSpace = 1;
    self.customSpaceColor = UMComTableViewSeparatorColor;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.customLeftEdge = 0;
        self.customSpace = 1;
        self.customSpaceColor = UMComTableViewSeparatorColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)drawRect:(CGRect)rect
{
    UIColor *color = self.customSpaceColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect line = CGRectMake(self.customLeftEdge, rect.size.height - self.customSpace, rect.size.width-self.customLeftEdge, self.customSpace);
    CGContextFillRect(context, line);
}

//- (void)drawRect:(CGRect)rect
//{
//    UIColor *color = self.customSpaceColor;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetStrokeColorWithColor(context, color.CGColor);
//    CGContextStrokeRect(context, CGRectMake(self.customLeftEdge, rect.size.height - self.customSpace, rect.size.width-self.customLeftEdge, self.customSpace));
//}
@end
