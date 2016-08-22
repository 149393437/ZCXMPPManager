//
//  UMComMedalImageView.m
//  UMCommunity
//
//  Created by 张军华 on 16/2/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComMedalImageView.h"



const CGFloat g_UMComMedalImageView_DefaultHeight = 16.f;
const CGFloat g_UMComMedalImageView_DefaultWidth = 16.f;
const NSInteger g_UMComMedalImageView_MaxCount = 1;
const NSInteger g_UMComMedalImageView_spaceBetweenMedalViews = 5.f;

@implementation UMComMedalImageView

+(CGFloat)defaultHeight
{
    return g_UMComMedalImageView_DefaultHeight;
}

+(CGFloat)defaultWidth
{
    return g_UMComMedalImageView_DefaultWidth;
}

+(NSInteger)maxMedalCount
{
    return  g_UMComMedalImageView_MaxCount;
}

+(CGFloat)spaceBetweenMedalViews
{
    return g_UMComMedalImageView_spaceBetweenMedalViews;
}

@end
