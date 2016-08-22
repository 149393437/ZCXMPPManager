//
//  UMComProgressView.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/3.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import "UMComProgressView.h"

@interface UMComProgressView ()
@property (nonatomic,strong) UIColor *schemeColor;
@property (nonatomic,strong) UIColor *progressColor;
@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,strong) UIColor *textColor;

@end

@implementation UMComProgressView

- (id)initWithColor:(UIColor *)color
{
    self = [self initWithFrame:CGRectMake(0, 0, 37, 37)];
    
    if(self)
    {
        
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
        
        self.schemeColor = color;
        CGColorRef progressCGColor = CGColorCreateCopyWithAlpha(color.CGColor, 1);
        CGColorRef backgroundCGColor = CGColorCreateCopyWithAlpha(color.CGColor, 0.1);
        CGColorRef textCGColor = CGColorCreateCopyWithAlpha(color.CGColor, 1);
        
        _progressColor = [UIColor colorWithCGColor:progressCGColor];
        _backgroundColor = [UIColor colorWithCGColor:backgroundCGColor];
        _textColor = [UIColor colorWithCGColor:textCGColor];
        CGColorRelease(progressCGColor);
        CGColorRelease(backgroundCGColor);
        CGColorRelease(textCGColor);
    }
    
    return  self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat lineWidth = 5.f;
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2);
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [self.backgroundColor set];
    [processBackgroundPath stroke];
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapRound;
    processPath.lineWidth = lineWidth;
    endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [self.progressColor set];
    [processPath stroke];

    [self drawTextInContext:context];
}

- (void)drawTextInContext:(CGContextRef)context
{
    UIFont *font = [UIFont systemFontOfSize:10];
    CGRect allRect = self.bounds;
    
    NSString *text = [NSString stringWithFormat:@"%i%%", (int)(_progress * 100.0f)];
    
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(30000, 13)];
    
    float x = floorf(allRect.size.width / 2) + 3 + 0;
    float y = floorf(allRect.size.height / 2) - 6 + 0;
    
    CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    [text drawAtPoint:CGPointMake(x - textSize.width / 2.0, y) withFont:font];
}


@end
