//
//  UMComActionDeleteView.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/16.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UMComActionDeleteViewType)
{
    UMComActionDeleteViewType_Circle,//圆形
    UMComActionDeleteViewType_Rectangle,//矩形

};

@interface UMComActionDeleteView : UIView

@property(nonatomic,assign)UMComActionDeleteViewType deleteViewType;

@end
