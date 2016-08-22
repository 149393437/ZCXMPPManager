//
//  CustomView.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/15.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
//block指针
@property(nonatomic,copy)void(^myBlock)(int);
//扩展函数
-(instancetype)initWithFrame:(CGRect)frame Block:(void(^)(int))a;
@end
