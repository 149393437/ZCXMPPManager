//
//  UMComActionPickerAddView.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/12.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComActionPickerAddView.h"

@implementation UMComActionPickerAddView

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //rect
    if(_isDashWithBorder)
    {
        CGContextSaveGState(context);
    }
    
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 0.7);
    CGContextSetLineWidth(context, 1.2);
    
    if (_isDashWithBorder) {
        CGFloat lengths[] = {4,4};
        CGContextSetLineDash(context, 0, lengths,2);
    }
    CGContextAddRect(context, self.bounds);
    if (_isDashWithBorder) {
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }

    //+
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 0.7);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextMoveToPoint(context, center.x- self.bounds.size.width/4,center.y);
    CGContextAddLineToPoint(context, center.x + self.bounds.size.width/4,center.y);
    
    CGContextMoveToPoint(context, center.x,center.y - self.bounds.size.height/4);
    CGContextAddLineToPoint(context, center.x,center.y + self.bounds.size.height/4);
    
    
    //draw
    CGContextStrokePath(context);
}


@end
