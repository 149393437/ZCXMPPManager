//
//  UMComGridTableViewCellOne.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/16.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComGridTableViewCellOne.h"


@interface UMComGridTableViewCellOne ()
@property (nonatomic,strong) id data;
@end
@implementation UMComGridTableViewCellOne

+ (CGSize)staticSize{
    return CGSizeZero;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setWithData:(id)data
{
    self.data = data;
}
@end
