//
//  UMComSegmentedControl.h
//  UMCommunity
//
//  Created by umeng on 16/3/8.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMComSegmentedControl : UISegmentedControl

@property (nonatomic, strong)UIColor *selectedTitleColor;

@property (nonatomic, strong)UIColor *nomalTitleColor;

@property (nonatomic, strong)UIFont *titleFont;


- (void)setfont:(UIFont *)font titleColor:(UIColor *)textColor selectedColor:(UIColor *)selectedColor;

@end
