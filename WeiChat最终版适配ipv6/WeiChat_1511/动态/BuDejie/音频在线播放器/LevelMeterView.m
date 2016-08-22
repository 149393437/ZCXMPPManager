//
//  LevelMeterView.m
//  iPhoneStreamingPlayer
//
//  Created by Carlos Oliva G. on 07-08-10.
//  Copyright 2010 iDev Software. All rights reserved.
//

#import "LevelMeterView.h"

#define kMeterViewFullWidth 275.0


@implementation LevelMeterView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	[[UIColor whiteColor] set];
	[@"L" drawInRect:CGRectMake(0.0, 10.0, 15.0, 15.0) withFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	[@"R" drawInRect:CGRectMake(0.0, 35.0, 15.0, 15.0) withFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
	CGContextFillRect(context, CGRectMake(15.0, 10.0, kMeterViewFullWidth * leftValue, 15.0));
	CGContextFillRect(context, CGRectMake(15.0, 35.0, kMeterViewFullWidth * rightValue, 15.0));
	CGContextFlush(context);
}


- (void)updateMeterWithLeftValue:(CGFloat)left rightValue:(CGFloat)right {
	leftValue = left;
	rightValue = right;
	[self setNeedsDisplay];
}

- (void)dealloc {
    [super dealloc];
}


@end
