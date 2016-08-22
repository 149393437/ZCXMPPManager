//
//  UMComSearchBar.m
//  UMCommunity
//
//  Created by umeng on 15-4-23.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComSearchBar.h"
#import "UMComTools.h"

@interface UMComSearchBar ()
@end

@implementation UMComSearchBar
{
//    CGRect ellipseRect;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        ellipseRect = CGRectMake(frame.size.height/2-10, frame.size.height/2-10, 15, 15);
        self.backgroundColor = [UIColor clearColor];
        self.backgroundImage = [[UIImage alloc]init];
//        self.bgImage = UMComImageWithImageName(@"search_frame");
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    if (self.bgImage) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextDrawImage(context, self.bounds, self.bgImage.CGImage);
        
        CGContextStrokePath(context);
    }
}

- (void)hidenKeyBoard
{
    [self resignFirstResponder];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
