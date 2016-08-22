#import "ZCXMPPManager.h"
//账号规则
#define  DATETIME (long)[[NSDate date]timeIntervalSince1970]-1404218190

//个人中心编码解码
#define CODE(str)\
[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]\

#define UNCODE(str)\
[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]\

//用户信息
#define kXMPPmyJID @"myXmppJid"
#define kXMPPmyPassword @"myXmppPassword"
#define kXMPPNewMsgNotifaction @"xmppNewMsgNotifaction"
#define kXMPPFriendType @"FriendType"
#define weiduMESSAGE @"weiduxiaoxi"

//发送消息的标记
#define MESSAGE_STR @"[1]"
#define MESSAGE_VOICE @"[2]"
#define MESSAGE_IMAGESTR @"[3]"
#define MESSAGE_BIGIMAGESTR @"[4]"
#define MESSAGE_LOCATION @"[5]"

//区别单聊和群聊的表示
#define SOLECHAT @"[1]"
#define GROUPCHAT @"[2]"

//单聊联系人标记
#define NONE @"none"


//服务器设置
#define XMPP_DOMAIN @"feiqueit.com"
#define IP @"feiqueit.com"


//群聊需要设置以下节点名称
//默认
#define GROUND @"conference"
#define GROUNDROOMCONFIG @"roomconfig"
#define ZIYUANMING @"IOS"
#define FRIENDS_TYPE @"friends_type"

//创建群时候保存群昵称和群描述
#define GROUNDNAME @"groundname"
#define GROUNDDES  @"grounddes"

//个人名片的节点定义
#define BYD @"birthday"
#define SEX @"SEX"
#define PHONENUM @"phonenum"
#define QMD @"QMD"
#define ADDRESS @"DQ"

//资源下载路径
#define LIBPATH [NSString stringWithFormat:@"%@/",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]]
//主题设置
#define THEME @"theme"

//气泡主题
#define BUBBLE @"bubble"

//下载聊天背景
#define CHATBGNAME @"chatbgname"

//字体下载
#define FONT @"fontnum"

//iOS7版本的适配
#define iOS7 [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0

//判断是否登陆
#define isLogin1 @"isLogin"

//FMDB
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

#define DATABASE_PATH [NSString stringWithFormat:@"%@/weChat.db",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]]

//增加屏幕适配
#define WIDTH [UIScreen mainScreen].bounds.size.width

#define HEIGHT [UIScreen mainScreen].bounds.size.height

//程序是否第一次进入
#define isFirst @"isFirst"






