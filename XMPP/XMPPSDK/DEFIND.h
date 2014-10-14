#import "ZCXMPPManager.h"
//账号规则
#define  DTAETIME (long)[[NSDate date]timeIntervalSince1970]-1404218190

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

//区别单聊和群聊的表示
#define SOLECHAT @"[1]"
#define GROUPCHAT @"[2]"

//服务器设置
#define DOMAIN @"1000phone.net"
#define IP @"1000phone.net"

//群聊需要设置以下节点名称
//默认
//#define GROUND @"conference"
#define GROUND @"room11"
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

//iOS7版本的适配
#define iOS7 [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0

//判断是否登陆
#define isLogin @"isLogin"

//FMDB
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

#define DATABASE_PATH [NSString stringWithFormat:@"%@/weChat.db",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]]


