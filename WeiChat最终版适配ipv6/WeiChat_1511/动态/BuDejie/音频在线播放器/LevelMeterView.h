//
//  LevelMeterView.h
//  iPhoneStreamingPlayer
//
//  Created by Carlos Oliva G. on 07-08-10.
//  Copyright 2010 iDev Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LevelMeterView : UIView {
	CGFloat leftValue;
	CGFloat rightValue;
}

- (void)updateMeterWithLeftValue:(CGFloat)left rightValue:(CGFloat)right;


@end
