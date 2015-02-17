//
//  ZCXMPPManager.h
//  XMPPEncapsulation
//
//  Created by ZhangCheng on 14-4-9.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//
#pragma mark 集成说明
/*
 版本说明 iOS研究院 305044955
 XMPP封装2.4版本
 修改libn库在真机打包的时候的错误
 XMPP封装2.3版本
 废除了直接获取好友方法，修改为使用block方式
 修复了好友列表乱序的问题
 修复个人信息回调重复回调的问题
 修复获取Vcard回调没有携带账户名的问题
 待定bug：获取个人信息有几率获取不到
 XMPP封装2.2版本
 修改了ZCXMPPManager支持为ARC版本
 增加了一些宏定义
 修改一些拼写错误
 修复少量bug
 XMPP封装2.1版本
 修复断开连接清空请求信息、好友验证混乱
 修复多用户聊天信息混乱
 修复其他好友给我发送消息，当前聊天信息偏移
 修复少量内存泄露
 XMPP封装2.0版本
 修复好友列表卡死、对方发送消息在最近联系人列表中不显示的问题
 修复最近联系人刷新不及时的问题，添加了一个广播kXMPPNewMsgNotifaction
 新增接口
   获取好友名片，扩展方法为block，不会在获取不到了
   扩展创建聊天室接口
   离开房间接口
   修改房间名称
   查找特定房间配置
 XMPP封装1.0版本
 完成注册、登录、好友列表、判断是否是好友、好友资料、验证消息、收到请求验证消息、发送消息、聊天记录、个人中心、最近联系人、获取所有聊天室、发送群聊天信息、加入聊天室、创建聊天室、拒绝加入聊天室、发送邀请群
*/
 
 
/*
 需要添加的库
 在xcode5.0需要加入systemConfiguration库和coreLocation，5.1版本则不需要
 libXml2  在header Search Paths中设置$(SDKROOT)/usr/include/libxml2
 libresolv
 CFNetWork
 Security
 libidn.a(加入xmppFrameWork就有)
 QuartzCore(不是必须添加，这个是小诚需要使用的)
 libsqlite3(不是必须添加，这个是小诚记录最近联系人使用的)
 libz(不是必须添加，这个是小诚解压缩使用)
 FMDB
 宏定义在DEFIND.h中，加入工程后需要添加头文件在.pch中

 设置完请编译一下无错后，在进行下一步
*/

#pragma mark 获取最近聊天记录
/*
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:kXMPPNewMsgNotifaction object:nil];
 -(void)loadData{
 //读取数据
 self.dataArray=  [ZCMessageObject fetchRecentChatByPage:20];
 
 [_tableView reloadData];
 }
 
 //需要区分单聊和群聊，群聊会在类型的后面追加群主题，用来进行显示
 */

#pragma mark 登录接口
//XMPP连接服务器必须要使用账户密码才能够进行连接，否则无法进行连接，密码验证是否成功靠block进行回调获得
/*
 [[NSUserDefaults standardUserDefaults]setObject:@"qianfeng567" forKey:kXMPPmyJID ];
 
 [[NSUserDefaults standardUserDefaults] setObject:@"123456" forKey:kXMPPmyPassword];
 [[NSUserDefaults standardUserDefaults]synchronize];

 ZCXMPPManager*manager=[ZCXMPPManager sharedInstance];
 BOOL connect= [manager connectLogoin:^(BOOL isSucceed) {
 if (isSucceed) {
 NSLog(@"登录成功");
 }else{
 NSLog(@"请检查哪里出错");
 }
 
 }];
 if (!connect) {
 NSLog(@"服务器连接失败");
 }
*/
 
#pragma mark 注册接口
/*
 [[NSUserDefaults standardUserDefaults]setObject:@"qianfeng567" forKey:kXMPPmyJID ];
 
 [[NSUserDefaults standardUserDefaults] setObject:@"123456" forKey:kXMPPmyPassword];
 [[NSUserDefaults standardUserDefaults]synchronize];
 ZCXMPPManager*manager=[ZCXMPPManager sharedInstance];
 [manager registerMothod:^(BOOL isSucceed) {
 if (isSucceed) {
 NSLog(@"~~~~~注册成功");
 }else{
 NSLog(@"注册失败");
 }
 }];
 */

//获得好友列表
//    好友列表是一个数组，每个元素是数组,依次存放的是好友~关注~被关注~我关注对方，对方没同意
//    @dynamic subscription;//关注状态
//    from 你关注我
//    to   我关注对方 同意
//    none 我关注对方 没同意
//    both 双方都关注了
#pragma mark 好友列表
 /*
 //verifyLabel.text代表是验证消息的数量  
 //self.dataArray最终数据源是XMPPUserCoreDataStorageObject类
 -(void)loadData{
 NSArray*array=[[ZCXMPPManager sharedInstance] friendsList:^(BOOL isRefresh) {
 
 [self loadData];
 
 }];
 self.dataArray=[NSMutableArray arrayWithArray:array];
 verifyLabel.text=[NSString stringWithFormat:@"%d",[ZCXMPPManager sharedInstance].subscribeArray.count];
 [_tableView reloadData];
 }
*/
#pragma mark 判断是否是好友
//-(BOOL)isFriend:(NSString*)Str;
#pragma mark 获取好友个人资料
/*
 [[presence from] user]为账号名称，不带主机名
 [[ZCXMPPManager sharedInstance] friendsVcard:[NSString stringWithFormat:@"%d",tag] Block:^(BOOL isSucceed, XMPPvCardTemp *vcard) {
 获得好友名片
 
 }

 */
#pragma mark 验证消息
/*
  NSArray*array=[ZCXMPPManager sharedInstance].subscribeArray;
 
 XMPPPresence*presence=[self.dataArray objectAtIndex:indexPath.row];
 //[presence from].user获得账号，但是并没有进行拼接的账号
 XMPPvCardTemp*temp1=[[ZCXMPPManager sharedInstance] friendsVcard:[[presence from] user]];
 */

#pragma mark 好友请求验证消息
/*
 [[ZCXMPPManager sharedInstance] addSomeBody:text.text Newmessage:@"xxx想添加你为好友"];
//处理好友消息 array每个元素是XMPPPresence
 NSArray*array=[ZCXMPPManager sharedInstance].subscribeArray;
 self.dataArray=[NSMutableArray arrayWithArray:array];
 //转换成好友名片
  XMPPvCardTemp*temp1=[[ZCXMPPManager sharedInstance] friendsVcard:[[presence from] user]];
//同意好友请求
 [manager agreeRequest:presence.from.user];
//拒绝好友请求
  [manager reject:presence.from.user];
//无论同意还是拒绝，请一定要再次刷新数据
*/
#pragma mark 发送消息 聊天记录
/* 发送消息界面
 //当退出时候，要把chatPerson=@"none" chatPerson的格式为xxx@1000phone.net
 
 //以下接口为获取聊天接口的
 [[ZCXMPPManager sharedInstance] valuationChatPersonName:[NSString stringWithFormat:@"%@@1000phone.net",self.myjid] IsPush:YES MessageBlock:^(ZCMessageObject *a) {
 //最新聊天内容（和当前人的）
 NSLog(@"~~~%@",a.messageContent);
 [self loadData];
 
 }];
 
 //获取当前用户聊天联系人
 NSArray*array= [manager messageRecord];
 self.dataArray=[NSMutableArray arrayWithArray:array];
 [_tableView reloadData];
 if (self.dataArray.count==0) {
 return;
 }
 
 array的每个元素XMPPMessageArchiving_Message_CoreDataObject类
 -(void)loadData{
 //聊天记录
 NSArray*array= [[ZCXMPPManager sharedInstance] messageRecord];
 self.dataArray=[NSMutableArray arrayWithArray:array];
 [_tableView reloadData];
 if (self.dataArray.count==0) {
 return;
 }
 [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
 
 }
 
//发送消息
  [[ZCXMPPManager sharedInstance]sendMessageWithJID:[NSString stringWithFormat:@"%@@1000phone.net",self.myjid] Message:@"测试数据，你看不错吧" Type:@"[1]"];
*/

#pragma mark 个人中心
/*
 //获得自己的名片信息
 [[ZCXMPPManager sharedInstance] getMyVcardBlock:^(BOOL isSucceed, XMPPvCardTemp *myVcard) {
 self.myVcard=myVcard;
 [_tableView reloadData];
 UIImageView*imageView=(UIImageView*)[self.view viewWithTag:3456];
 imageView.image=[UIImage imageWithData:self.myVcard.photo];
 }];

 //自定义节点名称
 [manager customVcardXML:@"11" name:@"NICKNAME" myVcard:myVcard];
 //更新vcard
 [manager upData:myVcard];
 */
#pragma mark 最近联系人
/*
 //从FMDB数据库中读取数据  每个元素是数组  0是内容 1时间 2是来自谁 顺序按照时间的逆序顺序 第一条是最近的
 self.dataArray= [ZCMessageObject fetchRecentChatByPage:20];
 XMPPvCardTemp*friendVcard=  [[ZCXMPPManager sharedInstance]friendsVcard:[[self.dataArray objectAtIndex:indexPath.row] objectAtIndex:2]];
*/
#pragma mark 获得所有聊天室
/*
 [[ZCXMPPManager sharedInstance]searchXmppRoomBlock:^(NSMutableDictionary *rooms) {
 
 NSLog(@"roomName%@",rooms);
 }];
 */
#pragma mark 发送群聊天信息
/*
 //room2为房间名称
 [[ZCXMPPManager sharedInstance]sendGroupMessage:@"哈哈哈" roomName:@"room2"];
 */
#pragma mark 加入聊天室
/*
 room=[[ZCXMPPManager sharedInstance]xmppRoomCreateRoomName:self.roomJid nickName:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]MessageBlock:^(NSDictionary *message) {
 [self.dataArray addObject:message];
 [_tableView reloadData];
 //产生位移
 if (self.dataArray.count) {
 [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
 }
 
 } presentBlock:^(NSDictionary *present) {
 [self rightNav];
 //进入成功，获取房间配置信息
 [[ZCXMPPManager sharedInstance]fetchRoomName:self.roomJid Block:^(NSDictionary *dic) {
 self.title=[dic objectForKey:@"des"];
 
 self.roomConifgDic=[NSDictionary dictionaryWithDictionary:dic];
 }];
 
 
 }];
 */
#pragma mark 拒绝加入聊天室
/*
    [[ZCXMPPManager sharedInstance]rejectRoom:@"room2@conference.admin-88ixf99az"];
 */
#pragma mark 发送邀请群
/*
 [[ZCXMPPManager sharedInstance]inviteRoom:room userName:@"123"];
 */
#pragma mark 离开房间
/*
 [[ZCXMPPManager sharedInstance]XmppOutRoom:room];
 */

#pragma mark 修改房间名称 必须是主持人才可以
/*
 NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithDictionary:self.roomConfigDic];
 [dic setObject:textField.text forKey:@"desName"];
 NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
 [user setObject:dic forKey:GROUNDNAME];
 [user synchronize];
 [[ZCXMPPManager sharedInstance]configRoom:self.room config:nil];
 desLabel.text=[NSString stringWithFormat:@"描述：%@",textField.text];
 
 */
#pragma mark 查找特定房间的配置
/*
 [[ZCXMPPManager sharedInstance]fetchRoomName:searchBar.text Block:^(NSDictionary *dic) {
 [self createSearchResult:dic];
 }]
 
 */
#pragma mark 群验证信息
/*
 //群验证消息
 //设计需求 当收到验证消息时候，保存到数组内，更新plist文件
 [ZCXMPPManager sharedInstance].GroupCheck=^(NSDictionary*dic){
 BOOL isSucceed=NO;
 for (NSDictionary*dic1 in self.groupCheckPlist) {
 isSucceed=[dic1 isEqualToDictionary:dic];
 
 }
 if (!isSucceed) {
 [self.groupCheckPlist addObject:dic];
 //更新本地文件
 NSString*path1=[NSString stringWithFormat:@"%@groupCheckPlist.plist",LIBPATH];
 //数据重新写入
 [self.groupCheckPlist writeToFile:path1 atomically:YES];
 [groupButton setTitle:[NSString stringWithFormat:@"您有%d条群验证消息",self.groupCheckPlist.count] forState:UIControlStateNormal];
 }
 
 
 };
 
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "XMPPFramework.h"
@class XMPPMessage,XMPPRoster,XMPPRosterCoreDataStorage,XMPPvCardAvatarModule,XMPPvCardTempModule,XMPPvCardAvatarCoreDataStorageObject,ZCMessageObject;
@interface ZCXMPPManager : NSObject
{
    XMPPStream *xmppStream;//最主要的xmpp流
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPMessageArchivingCoreDataStorage*xmppMessageArchivingCoreDataStorage;//信息列表
    XMPPMessageArchiving *xmppMessageArchivingModule;
    XMPPvCardAvatarModule*xmppvCardAvatarModule;
    XMPPvCardTempModule*xmppvCardTempModule;
    XMPPvCardCoreDataStorage*xmppvCardStorage;
   	NSString *password;
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isXmppConnected;
    BOOL logoinorSignin;
    NSUserDefaults*userDefaults;
}

@property (nonatomic,retain)NSMutableArray*subscribeArray;
@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain,nonatomic)NSMutableDictionary*yanzhengxiaoxi;
//用于记录出席列表
@property(nonatomic,retain)NSMutableDictionary*presentDic;

/******************系统初始化***************************/
//获得单例
+(ZCXMPPManager*)sharedInstance;
//登录
- (BOOL)connectLogin:(void(^)(BOOL))a;
//注册
-(void)registerMothod:(void(^)(BOOL))b;
//退出登录
- (void)disconnect;
//获得好友列表 如有新状态，通过block回调
-(NSArray*)friendsList:(void(^)(BOOL))c;
//获得头像（需要与好友列表共同使用）
- (UIImage *)avatarForUser:(XMPPUserCoreDataStorageObject *) user;
/****************消息类处理******************************/
//发送消息
-(void)sendMessageWithJID:(NSString*)jidStr Message:(NSString*)message Type:(NSString*)type;


//记录当前聊天人是谁
@property (copy,nonatomic)NSString*chatPerson;
//徽标属性,设置未读消息使用
@property(nonatomic,assign)UITabBarItem*badgeValue;

//进入聊天界面和退出聊天界面必须调用此函数 a为接收到的消息
-(void)valuationChatPersonName:(NSString*)name IsPush:(BOOL)isPush MessageBlock:(void(^)(ZCMessageObject*))a;
//获取聊天记录 数组里每个元素是XMPPMessageArchiving_Message_CoreDataObject
/*
body 内容 需要先对比类型
isOutgoing 是否是发送方
timestamp  发送的时间
 
 */
//聊天记录
-(NSArray*)messageRecord;
/****************好友类的处理********************/
//添加好友 可以带一个消息
-(void)addSomeBody:(NSString *)userId Newmessage:(NSString*)message;
//删除好友
-(void)removeBuddy:(NSString *)name;

//处理请求
//同意
-(void)agreeRequest:(NSString*)name;
//拒绝
-(void)reject:(NSString*)name;
//扩展方法
-(void)friendsVcard:(NSString *)useId Block:(void(^)(BOOL,XMPPvCardTemp*))a;

/*********************个人中心********************************/

//个人中心
//接口   1、获得myVcard 2、设置自定义节点  3、更新myVcard
-(void)getMyVcardBlock:(void(^)(BOOL,XMPPvCardTemp*))c;
-(void)customVcardXML:(NSString*)Value name:(NSString*)Name myVcard:(XMPPvCardTemp*)myVcard;
-(void)upData:(XMPPvCardTemp*)vCard;


//判断好友 需要根据实际需求进行修改
-(BOOL)isFriend:(NSString*)Str;
#pragma mark 群聊


//获得所有聊天室
-(void)searchXmppRoomBlock:(void(^)(NSMutableArray*))roomsDic;

//发送聊天室信息
-(void)sendGroupMessage:(NSString*)messageStr roomName:(NSString*)roomName;
//邀请他人进入聊天室
-(void)inviteRoom:(XMPPRoom*)room userName:(NSString*)userName;
//拒绝加入聊天室
-(void)rejectRoom:(NSString*)roomJid;
//创建聊天室 b为成功加入聊天室以后
-(XMPPRoom*)xmppRoomCreateRoomName:(NSString *)roomName nickName:(NSString *)nickName MessageBlock:(void(^)(NSDictionary*))a presentBlock:(void(^)(NSDictionary*))b;
// 离开房间
-(void)XmppOutRoom:(XMPPRoom*)room;
//修改房间名称 注！必须是主持人才有此权限
-(void)configRoom:(XMPPRoom*)room config:(NSXMLElement*)config;
//查找特定房间配置
-(void)fetchRoomName:(NSString*)roomName Block:(void(^)(NSDictionary*))b;

//文件传输
#pragma mark 文件传输
-(void)test;
//视频对讲



/*block指针*/
//登录函数指针
@property(nonatomic,copy)void(^logoin)(BOOL);
//注册指针
@property(nonatomic,copy)void(^signin)(BOOL);
//接收到当前聊天人的消息指针
@property(nonatomic,copy)void(^accept)(ZCMessageObject*);

//接收个人中心Vcard回调
@property(nonatomic,copy)void(^myVcardBlock)(BOOL,XMPPvCardTemp*);
//接收好友的Vcard回调的字典，字典中key是好友的用户名，value是数组，数组中保存的是block指针，相当于是做成了一个通知
@property(nonatomic,strong)NSMutableDictionary*friendVcardDic;


@property(nonatomic,copy)void(^friendType)(BOOL);
//接收按照搜索条件返回的房间jid和房间名称
@property(nonatomic,copy)void(^roomsName)(NSMutableArray*);
//接收群聊消息
@property(nonatomic,copy)void(^GroupMessage)(NSDictionary*);
//外部在退出当前界面时候需要修改该nowRoomjid为空
@property(nonatomic,copy)NSString*nowRoomJid;
//群验证消息回调
@property(nonatomic,copy)void(^GroupCheck)(NSDictionary*);
//用于返回出席列表，谁进入谁退出
@property(nonatomic,copy)void(^GroupPresent)(NSDictionary*);
//返回查找的房间信息
@property(nonatomic,copy)void(^fetchRoom)(NSDictionary*);
//-(void)xx;
/**********/
@end
