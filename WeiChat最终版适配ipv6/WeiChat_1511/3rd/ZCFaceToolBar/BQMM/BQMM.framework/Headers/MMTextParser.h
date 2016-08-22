//
//  MMTextParser.h
//  BQMM SDK
//
//  Created by ceo on 12/28/15.
//  Copyright © 2015 siyanhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMTextParser : NSObject

/**
*   从text中解析所有MMEmoji，本地没有的emoji code会从服务器实时获取。completionHandler是表情消息解析完成后的回调，参数textImgArray类型可
*   能是MMEmoji或字符串。
*  @param text             mmtext
*  @param completionHandler 完成的回调，包含MMEmoji,text对象的集合或者error对象
*/
+ (void)parseMMText:(NSString *)text
  completionHandler:(void(^)(NSArray *textImgArray, NSError *error))completionHandler;

/**
 *  从text中解析本地已下载的Emoji
 *
 *  @param text              mmtext
 *  @param completionHandler 完成的回调，包含MMEmoji, text对象的集合或者error对象
 */
+ (void)localParseMMText:(NSString *)text
       completionHandler:(void(^)(NSArray *textImgArray))completionHandler;

/**
 *  从mmText中检查出符合emojiCode格式的result数组
 *
 *  @param mmText   mmText
 *
 *  @return         符合emojiCode的格式result数组
 */
+ (NSArray<NSTextCheckingResult *> *)findEmojicodesResultFromMMText:(NSString *)mmText;

@end
