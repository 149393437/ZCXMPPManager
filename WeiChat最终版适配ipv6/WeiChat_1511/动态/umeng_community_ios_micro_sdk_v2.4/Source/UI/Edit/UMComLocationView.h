//
//  UMComLocationView.h
//  UMCommunity
//
//  Created by umeng on 15/11/20.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedLocationViewBlock)();
@interface UMComLocationView : UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *indicatorView;

@property(nonatomic,strong) UIColor* locationbackgroudColor;//背景色


@property(nonatomic,readwrite,copy)SelectedLocationViewBlock locationBlock;

/**
 *  重新布局子控件,
 *  1.如果location为空或者空字符串就显示提示控件
 *  2.反之就隐藏提示控件，显示位置控件
 */
-(void) relayoutChildControlsWithLocation:(NSString*)location;

@end
