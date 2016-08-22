//
//  UMComSegmentedControl.m
//  UMCommunity
//
//  Created by umeng on 16/3/8.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComSegmentedControl.h"

@implementation UMComSegmentedControl

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        self.selectedSegmentIndex = 0;
        self.selectedTitleColor = [UIColor whiteColor];
        self.nomalTitleColor = [UIColor blueColor];
        self.titleFont = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setfont:(UIFont *)font titleColor:(UIColor *)textColor selectedColor:(UIColor *)selectedColor;

{
    _titleFont = font;
    _nomalTitleColor = textColor;
    _selectedTitleColor = selectedColor;
    NSDictionary *seletedDic = [NSDictionary dictionaryWithObjectsAndKeys:_selectedTitleColor,UITextAttributeTextColor,  font,UITextAttributeFont ,nil];
    [self setTitleTextAttributes:seletedDic forState:UIControlStateSelected];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_nomalTitleColor,UITextAttributeTextColor,  font,UITextAttributeFont ,nil];
    [self setTitleTextAttributes:dic forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
