//
//  UMComMicLikeUserTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 16/2/17.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComMicLikeUserTableViewCell.h"
#import "UMComImageView.h"
#import "UMComTools.h"
#import "UMComClickActionDelegate.h"

@implementation UMComMicLikeUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat imageOriginX = 13;
        CGFloat imageWidth = size.height - imageOriginX*2;
        self.portrait = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(imageOriginX, imageOriginX, imageWidth, imageWidth)];
        [self.contentView addSubview:self.portrait];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageOriginX+imageWidth+10, imageOriginX, size.width-imageWidth-2*imageOriginX-10, imageWidth)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = UMComColorWithColorValueString(@"#666666");
        self.nameLabel.font = UMComFontNotoSansLightWithSafeSize(15);
        [self.contentView addSubview:self.nameLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnUser)];
        [self addGestureRecognizer:tap];
        
        self.customLeftEdge = 10;
    }
    return self;
}

- (void)tapOnUser
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:self.user];
    }
}

//- (void)drawRect:(CGRect)rect
//{
//    UIColor *color = UMComColorWithColorValueString(UMCom_Feed_BgColor);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGFloat height = 2;
//    CGRect drawFrame = CGRectMake(15, rect.size.height - height, rect.size.width-15, height);
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, drawFrame);
//}


@end
