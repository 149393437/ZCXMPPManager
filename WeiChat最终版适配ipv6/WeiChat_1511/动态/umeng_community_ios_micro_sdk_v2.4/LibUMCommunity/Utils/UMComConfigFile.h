//
//  UMComConfigFile.h
//  UMCommunity
//
//  Created by umeng on 15/11/13.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UMComConfigFile : NSObject

//enum
typedef enum {//用户名格式配置策略枚举类型
    userNameDefault = 0,                //默认格式
    userNameNoBlank = 1,                //不包含空格
    userNameNoRestrict = 2              //没有字符限制
}UMComUserNameType;

typedef enum {//用户名长度配置策略枚举类型
    userNameLengthDefault = 0,          //默认长度 2~20
    userNameLengthNoRestrict = 1        //1~50个字数
}UMComUserNameLength;

//2.3版本UI feed界面的颜色属性

//feed列表下Item下面的元素的颜色属性----begin

#define FontColorForFeedLike        @"#a5a5a5"
#define FontColorForFeedComment     @"#a5a5a5"
#define FontColorForFeedLocation    @"#a5a5a5"
#define FontColorForFeedNickName    @"#a5a5a5"

//feed列表下Item下面的元素的颜色属性---end
 
//常用颜色值
#define FontColorGray @"#666666"
#define FontColorBlue @"#4A90E2"
#define FontColorLightGray @"#8E8E93"
#define TableViewSeparatorColor @"#C8C7CC"
#define FeedTypeLabelBgColor @"#DDCFD5"
#define LocationTextColor  @"#9B9B9B"
#define ViewGreenBgColor @"#B8E986"
#define ViewGrayColor    @"#D8D8D8"
#define LightGrayColor  @"#ececec"

#define UMCom_Feed_BgColor @"#F5F6FA"

#define UMCom_ForumUI_Title_Color  @"#666666"
#define UMCom_ForumUI_Title_Font  20

#define TableViewCellSpace  0.3
#define BottomLineHeight    0.3

#define TopicRulerString @"(#([^#]+)#)"
#define UserRulerString @"(@[\\u4e00-\\u9fa5_a-zA-Z0-9]+)"
#define UrlRelerSring   @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\,\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\,\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

#define TopicString     @"#%@#"
#define UserNameString  @"@%@"

extern NSInteger const kFeedContentLength;//feed列表字符限制
extern NSInteger const kCommentLenght; //feed的评论字数限制
extern CGFloat const kUMComRefreshOffsetHeight;//下拉刷新控件显示的高度
extern CGFloat const kUMComLoadMoreOffsetHeight;//上拉加载控件显示的高度


@end
