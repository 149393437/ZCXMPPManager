//
//  MMTextView.h
//  StampMeSDK
//
//  Created by ceo on 11/9/15.
//  Copyright © 2015 siyanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTextView : UITextView

@property (nonatomic,strong) UIFont *mmFont;
@property (nonatomic,strong) UIColor *mmTextColor;

- (void)setPlaceholderTextWithData:(NSArray*)extData;
- (void)setMmTextData:(NSArray *)extData;
- (void)setMmTextData:(NSArray*)extData completionHandler:(void(^)(void))completionHandler;

@end
