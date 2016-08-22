//
//  UMComMedalImageView.h
//  UMCommunity
//
//  Created by 张军华 on 16/2/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComImageView.h"


/**
 *  勋章图片类
 */
@interface UMComMedalImageView : UMComImageView

/**
 *  勋章的默认高度
 *
 *  @return 默认高度
 */
+(CGFloat)defaultHeight;
/**
 *  勋章的默认宽度
 *
 *  @return 默认宽度
 */
+(CGFloat)defaultWidth;

/**
 *  勋章最大的数量(默认五个)
 *
 *  @return 勋章最大的数量
 */
+(NSInteger)maxMedalCount;

/**
 *  勋章的间隔
 *
 *  @return 勋章的间隔(默认为5)
 */
+(CGFloat)spaceBetweenMedalViews;

@end
