//
//  SMTextAttachment.h
//  StampMeSDK
//
//  Created by ceo on 11/9/15.
//  Copyright © 2015 siyanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMEmoji;

@interface SMTextAttachment : NSTextAttachment

/**
 *  表情对象
 */
@property (nonatomic, strong) MMEmoji *emoji;

/**
 *  gif表情图片第一帧，大小为100px*100px，可用于编辑富文本消息时的gif表情显示
 *
 *  @return 图片
 */
- (UIImage *)placeHolderImage;

@end
