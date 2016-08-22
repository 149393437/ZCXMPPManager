//
//  UMComActionDeleteView.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/16.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComActionDeleteView.h"

@implementation UMComActionDeleteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
//        self.userInteractionEnabled = YES;
    }
    return self;
}


- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(24.0, 24.0);
}

-(void)doDrawCircle:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillEllipseInRect(context, self.bounds);
    
    // Body
    CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
    CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
    
    // Checkmark
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 1.2);
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextMoveToPoint(context, center.x- self.bounds.size.width/4,center.y);
    CGContextAddLineToPoint(context, center.x + self.bounds.size.width/4,center.y);
    
    CGContextStrokePath(context);
}

-(void) doDrawRectangle:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置背景填充
    CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 0.8);
    CGContextFillRect(context, rect);
    
    //画线
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.9);
    CGContextSetLineWidth(context, 0.5);
    
    //设置对称的坐标点
    int offsetx = rect.size.width/4;
    int offsety=  rect.size.height/4;
    CGContextMoveToPoint(context, offsetx, offsety);
    CGContextAddLineToPoint(context, offsetx*3, offsety*3);
    
    CGContextMoveToPoint(context, offsetx*3, offsety*1);
    CGContextAddLineToPoint(context, offsetx*1, offsety*3);
    
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    switch (self.deleteViewType) {
        case UMComActionDeleteViewType_Circle:
            [self doDrawCircle:rect];
            break;
        case UMComActionDeleteViewType_Rectangle:
            [self doDrawRectangle:rect];
            break;
        default:
            [self doDrawCircle:rect];
            break;
    }
}


@end
