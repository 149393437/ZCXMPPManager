//
//  StarView.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "StarView.h"

@implementation StarView

//如果想要代码创建,在此方法中进行创建
-(void)awakeFromNib
{
    bgImageView=[LFZCControl createImageViewWithFrame:CGRectMake(0, 0, 65, 23) ImageName:@"StarsBackground"];
    
    [self addSubview:bgImageView];
    
    starImageView=[LFZCControl createImageViewWithFrame:CGRectMake(0, 0, 65, 23) ImageName:@"StarsForeground"];
    //停靠模式
    starImageView.contentMode=UIViewContentModeLeft;
    //多余部分裁剪
    starImageView.layer.masksToBounds=YES;
    [self addSubview:starImageView];

}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame]) {
        bgImageView=[LFZCControl createImageViewWithFrame:CGRectMake(0, 0, 65, 23) ImageName:@"StarsBackground"];
        
        [self addSubview:bgImageView];
        
        starImageView=[LFZCControl createImageViewWithFrame:CGRectMake(0, 0, 65, 23) ImageName:@"StarsForeground"];
        //停靠模式
        starImageView.contentMode=UIViewContentModeLeft;
        //多余部分裁剪
        starImageView.layer.masksToBounds=YES;
        [self addSubview:starImageView];
        
    }
    return self;

}
-(void)configStarNum:(float)num
{
    starImageView.frame=CGRectMake(0, 0, 65/5*num, 23);

}

@end
