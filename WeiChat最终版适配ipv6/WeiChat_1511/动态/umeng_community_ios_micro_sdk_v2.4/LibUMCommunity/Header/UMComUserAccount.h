//
//  UMComUserAccount.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComTools.h"

/**
 @warming 这个枚举要跟Android保持一致
 */
typedef enum {
    UMComSnsTypeSina,
    UMComSnsTypeQQ,
    UMComSnsTypeWechat,
    UMComSnsTypeRenren,
    UMComSnsTypeDouban,
    UMComSnsTypeQzone,
    UMComSnsTypeTencent,
    UMComSnsTypeFacebook,
    UMComSnsTypeTwitter,
    UMComSnsTypeYixin,
    UMComSnsTypeInstagram,
    UMComSnsTypeTumblr,
    UMComSnsTypeLine,
    UMComSnsTypeKakaoTalk,
    UMComSnsTypeFlickr,
    UMComSnsTypeSelfAccount,
    UMComSnsTypeOther
}UMComSnsType;

/**
 使用第三方登录方法后得到的登录数据构造此类
 
 */
@interface UMComUserAccount : NSObject

/**
 required sns对应的平台类型，例如`UMComSnsTypeSina`对应新浪
 
 */
@property (nonatomic, assign) UMComSnsType snsType;

/**
 required sns对应的平台名称，例如`sina`对应新浪
 
 */
@property (nonatomic, copy, readonly) NSString *snsPlatformName;

/**
 required, sns平台的用户id
 
 */
@property (nonatomic, copy) NSString * usid;

/**
 required, sns平台的用户昵称
 
 */
@property (nonatomic, copy) NSString * name;

/**
 用户头像的链接地址
 
 */
@property (nonatomic, copy) NSString * icon_url;

/**
 用户头像
 
 */
@property (nonatomic, strong) UIImage  *iconImage;

/**
 用户年龄
 
 */
@property (nonatomic, strong) NSNumber * age;

/**
 用户性别,1代表男性，0代表女性
 
 */
@property (nonatomic, strong) NSNumber * gender;

/**
 用户自定义字段
 
 */
@property (nonatomic, copy) NSString * custom;

/**
 等级
 
 */
@property (nonatomic, strong) NSNumber *level;

/**
 积分
 
 */
@property (nonatomic, strong) NSNumber *score;

/**
 等级名称
 
 */
@property (nonatomic, copy) NSString *level_title;


/**SDK version 2.1.2 start**/
/**
 用户名字符类型限制
 
 */
@property (nonatomic, assign) UMComUserNameType userNameType;

/**
 用户名长度限制
 
 */
@property (nonatomic, assign) UMComUserNameLength userNameLength;
/**SDK version 2.1.2 end**/


/**
 初始化方法
 
 @param snsType 平台类型
 
 @returns 用户账号对象
 */
- (id)initWithSnsType:(UMComSnsType)snsType;

@end
