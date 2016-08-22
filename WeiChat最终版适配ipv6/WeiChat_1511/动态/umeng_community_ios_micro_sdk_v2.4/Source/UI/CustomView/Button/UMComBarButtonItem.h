//
//  UMComBarButtonItem.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComButton.h"

@interface UMComBarButtonItem : UIBarButtonItem

@property (nonatomic, assign) CGRect itemFrame;
@property (nonatomic, strong) UMComButton *customButtonView;
- (id)initWithNormalImageNameWithBackItem:(NSString *)imageName target:(id)target action:(SEL)action;
- (id)initWithNormalImageName:(NSString *)imageName target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithCustomView:(UIView*)customView;
@end
