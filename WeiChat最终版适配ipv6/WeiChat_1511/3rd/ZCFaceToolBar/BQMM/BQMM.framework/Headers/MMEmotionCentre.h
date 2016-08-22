//
//  SMEmotionCentre.h
//  BQMM SDK
//
//  Created by ceo on 8/22/15.
//  Copyright (c) 2015 siyanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTheme.h"
#import "MMEmoji.h"

/**
 定义表情的类型，大表情或者小表情
 */
typedef enum
{
    MMFetchTypeSmall    = 1 << 0,
    MMFetchTypeBig      = 1 << 1
} MMFetchType;

@protocol MMEmotionCentreDelegate <NSObject>

@optional

/**
 *  点击键盘中大表情的代理
 *
 *  @param emoji 代表大表情的数据模型
 */
- (void)didSelectEmoji:(MMEmoji *)emoji;

/**
 *  点击联想表情的代理
 *
 *  @param emoji 代表联想表情的数据模型
 */
- (void)didSelectTipEmoji:(MMEmoji *)emoji;

/**
 *  点击表情小表情键盘上发送按钮的代理
 *
 *  @param input 输入框， 如UITextView, UITextField...
 */
- (void)didSendWithInput:(UIResponder<UITextInput> *)input;

/**
 *  点击输入框切换表情按钮状态
 */
- (void)tapOverlay;

@end

@interface MMEmotionCentre : NSObject

/**
 *  表情中心的代理， 表情mm SDK数据的主要输出口
 */
@property (nonatomic, weak) id<MMEmotionCentreDelegate> delegate;

/**
 *  是否支持图文混排, 默认为YES
 */
@property (nonatomic) BOOL supportedMixedTextImage;

/**
 * 计数表情包
 */
@property (nonatomic) NSInteger count;

/**
 *  表情中心的单例方法
 *
 *  @return 表情中心的单例
 */
+ (instancetype)defaultCentre;

/**
 *  获得当前SDK的版本
 *
 *  @return 目前SDK的版本
 */
- (NSString *)version;

/**
 *  表情mm SDK初始化
 *  获取appId和secret的入口： http://form.mikecrm.com/f.php?t=HlmhIZ
 *  @param appId  表情mm分配给你的app的唯一标识符
 *  @param secret 表情mm分配给你的app的密匙
 */
- (void)setAppId:(NSString *)appId secret:(NSString *)secret;

/**
 *  开发者可以用setUserId方法设置App UserId，以便在后台统计时跟踪追溯单个用户的表情使用情况
 *
 *  @param userId 用户的唯一标识符
 */
- (void)setUserId:(NSString *)userId;


/**
 *  更新表情mm SDK的皮肤
 *
 *  @param theme SDK开发的Theme的对象， 提供了可更改的界面属性, 参考MMTheme.h
 */
- (void)setTheme:(MMTheme *)theme;


/**
 *  切换到普通键盘
 */
- (void)switchToDefaultKeyboard;

/**
 *  添加表情键盘
 *
 *  @param input 输入框，添加表情键盘的目标
 */
- (void)attachEmotionKeyboardToInput:(UIResponder<UITextInput> *)input;

/**
 *  添加表情联想， 当在输入框中输入字符是，SDK将寻找与之相匹配的表情， 然后显示出来
 *
 *  @param attchedView 显示的表情将在这个试图的上面
 *  @param input       输入框
 */
- (void)shouldShowShotcutPopoverAboveView:(UIView *)attchedView
                                withInput:(UIResponder<UITextInput> *)input;


/**
 *  表情的详细的界面视图
 * 
 *  @param emojiCode 表情的唯一标识
 *
 *  @return 表情的细节试图
 */
- (UIViewController *)controllerForEmotionCode:(NSString *)emojiCode;

/**
 *  通过表情的唯一标识获得，MMEmoji对象
 *
 *  @param fetchType         表情的类型： 小表情或大表情
 *  @param emojiCodes        表情标识的集合
 *  @param completionHandler 完成的回调，包含MMEmoji对象的集合或者error对象
 */
- (void)fetchEmojisByType:(MMFetchType)fetchType
                    codes:(NSArray *)emojiCodes
        completionHandler:(void (^)(NSArray *emojis, NSError *error))completionHandler;


/**
 *  清除缓存
 */
- (void)clearSession;

@end
