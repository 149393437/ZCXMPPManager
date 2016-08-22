    //
//  ZCXMPPManager.m
//  XMPPEncapsulation
//
//  Created by ZhangCheng on 14-4-9.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCXMPPManager.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
//断点续传
#import "XMPPReconnect.h"
#import "XMPPCapabilities.h"
//打印信息
#import "DDLog.h"
#import "DDTTYLogger.h"
//花名册
#import "XMPPRoster.h"
//信息
#import "XMPPMessage.h"
//发送文件使用
#import "TURNSocket.h"
//名片模型
#import "XMPPvCardTempModule.h"
#import "XMPPvCardTempCoreDataStorageObject.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPRoom.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
//定义的路径，documents 和caches路径
#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define CACHES_PATH NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

@implementation ZCXMPPManager
#pragma mark 开启单例
static ZCXMPPManager *sharedManager;
@synthesize subscribeArray,yanzhengxiaoxi;
+(ZCXMPPManager*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[ZCXMPPManager alloc]init];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [sharedManager setupStream];
        sharedManager.chatPerson=NONE;
    });
    return sharedManager;
}

#pragma mark 查找特定房间
-(void)fetchRoomName:(NSString*)roomName Block:(void(^)(NSDictionary*))b{
/*查询特定房间
 <iq type="get" to="zc12@room11.feiqueit.com" id="disco"><query xmlns="http://jabber.org/protocol/disco#info"/></iq>

 */
    self.fetchRoom=b;
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    //conference 原生的
    XMPPJID* proxyCandidateJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@.%@",[[roomName componentsSeparatedByString:@"@"] firstObject],GROUND,XMPP_DOMAIN]];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:proxyCandidateJID  elementID:@"disco1" child:query];

    [xmppStream sendElement:iq];

}
#pragma mark 是否是好友
-(BOOL)isFriend:(NSString*)Str{
    /*********/
 // BOOL isFriend=  [xmppRosterStorage userExistsWithJID:[XMPPJID jidWithString:Str] xmppStream:xmppStream];
    /*******/
    
    
    NSManagedObjectContext*context=[xmppRosterStorage mainThreadManagedObjectContext];
    NSEntityDescription*entity=[NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSString*currentJid=[NSString stringWithFormat:@"%@@%@",[userDefaults objectForKey:kXMPPmyJID],XMPP_DOMAIN];
    //currentJid   feique001@feiqueit.com
    //谓词搜索条件为streamBareJidStr关键词
    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"streamBareJidStr==%@",currentJid];
    NSFetchRequest*request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];//筛选条件
    NSError*error;
    NSArray*friends=[context executeFetchRequest:request error:&error];//从数据库中取出数据
    //friends每个元素是 XMPPUserCoreDataStorageObject
    BOOL isSucceed=NO;
    for (XMPPUserCoreDataStorageObject*object in friends) {
        
      //  object.jid.user  只有账号，没有后面的@1000phone.net
      //object.jidStr 是完整的一个账号，带@1000phone.net
        
        if ([object.jidStr isEqualToString:Str]) {
            isSucceed=YES;
        }
    }
    
    return isSucceed;
}
#pragma mark 发现聊天室
//获得全部房间列表
-(void)searchXmppRoomBlock:(void(^)(NSMutableArray*))roomsDic
{
    
    /*
     <iq type="get" to="conference.1000phone.net" id="disco2"><query xmlns="http://jabber.org/protocol/disco#items"></query></iq>
     */
    

    self.roomsName=roomsDic;
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    //conference 原生的
   XMPPJID* proxyCandidateJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@.%@",GROUND,XMPP_DOMAIN]];
   
  

    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:proxyCandidateJID  elementID:@"disco" child:query];
    [xmppStream sendElement:iq];

}

//可以拦截到搜索群聊消息 当房间比较多的时候，应该有变化，并且需要增加指定的某一类的群
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    
    /*
     <iq xmlns="jabber:client" type="result" id="disco2" from="conference.admin-88ixf99az" to="admin@admin-88ixf99az/IOS">
     <query xmlns="http://jabber.org/protocol/disco#items">
     <item jid="room2@conference.admin-88ixf99az" name="&#x7279;"></item>
     <item jid="room3@conference.admin-88ixf99az" name="room3"></item>
     <item jid="room4@conference.admin-88ixf99az" name="room4"></item>
     </query>
     </iq>
     */
    //获得id名字
  DDXMLNode*idXML=  [iq attributeForName:@"id"];
    //转换为字符串
  NSString*str=  [idXML stringValue];
    
    if ([str isEqualToString:@"disco"]) {

        NSXMLElement*xx= [iq elementForName:@"query"];
        NSArray*array=[xx elementsForName:@"item"];
     
        NSMutableArray*roomArray=[NSMutableArray arrayWithCapacity:0];
        for (NSXMLElement*item in array) {
            NSMutableDictionary*room=[NSMutableDictionary dictionaryWithCapacity:0];
            
         DDXMLNode*jid=   [item attributeForName:@"jid"];
        DDXMLNode*name= [item attributeForName:@"name"];
            [room setValue:[jid stringValue] forKey:@"roomJid"];
            [room setValue:[name stringValue] forKey:@"roomName"];
            
            [roomArray addObject:room];
        }
        if (self.roomsName) {
            self.roomsName(roomArray);
        }
    }
    if ([str isEqualToString:@"disco1"]) {
        
        NSArray*array= [iq elementsForName:@"query"];
        NSXMLElement *query=[array firstObject];
        
        //获取命名空间
        DDXMLNode *nameSpace=  [[query namespaces]firstObject];
        //获取房间信息
        if ([[nameSpace stringValue] isEqualToString:@"http://jabber.org/protocol/disco#info"]) {
            
            DDXMLNode*typeXML=  [iq attributeForName:@"type"];
            NSString*error=  [typeXML stringValue];
            if ([error isEqualToString:@"error"]) {
                self.fetchRoom(nil);
                return YES;
            }
            
            //读取query下的identity标签
         NSString*name=   [[[query elementForName:@"identity"]attributeForName:@"name"]stringValue];
            
            
            NSArray*field=  [[[query elementsForName:@"x"]firstObject]elementsForName:@"field"];
            NSString*str=[[[[field objectAtIndex:1]elementsForName:@"value"]firstObject]stringValue];
            if (str.length==0) {
                str=@"没有描述";
            }
            //            NSString*str1=[[[[field objectAtIndex:2]elementsForName:@"value"]firstObject]stringValue];
            //            if (str1.length==0) {
            //                str1=@"没有主题";
            //            }
            //人数限制
            NSString*str2=[[[[field objectAtIndex:3]elementsForName:@"value"]firstObject]stringValue];
            if (str2.length==0) {
                str2=@"0";
            }
            //创建日期
            NSString*str3=[[[[field objectAtIndex:4]elementsForName:@"value"]firstObject]stringValue];
            //@"subject":str1,
            DDXMLNode*idXML1=  [iq attributeForName:@"from"];
            //转换为字符串
            NSString*str4=  [idXML1 stringValue];
            
            NSDictionary*dic=@{@"des":str,@"num":str2,@"time":str3,@"from":[[str4 componentsSeparatedByString:@"@"] firstObject],@"name":name};
            //对数据库进行更新 310065
            [ZCMessageObject upDateType:dic];
            //记录群配置信息
            self.groupConfigDic=[NSMutableDictionary dictionaryWithDictionary:dic];
            
            
            if (_fetchRoom) {
                self.fetchRoom(dic);
            }
            
            //内容需要改变为储存字典
            
            if (_myRoomList) {
                //对比是否存在
                BOOL is=NO;
                for (NSDictionary*dic1 in _roomListArray) {
                    NSString*from=dic1[@"from"];
                    if ([[[str4 componentsSeparatedByString:@"@"] firstObject] isEqualToString:from]) {
                        is=YES;
                    }
                }
                
                if (is==NO) {
                    [_roomListArray addObject:dic];
                    
                    //持久化保存
                    [_roomListArray writeToFile:[NSString stringWithFormat:@"%@%@roomList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]] atomically:YES];
                    _myRoomList(_roomListArray);
                }
            }
            
            return YES;
        }
    }
   
   DDXMLElement*query= [iq elementForName:@"query"];
   DDXMLElement*item= [query elementForName:@"item"];

    if (item) {
      DDXMLNode*subscription=[item attributeForName:@"subscription"];
        
      NSString*str1=  [subscription stringValue];
        
        if ([str1 isEqualToString:@"both"]) {
            //删除对应的验证消息
            DDXMLNode*jid=[item attributeForName:@"jid"];
           NSString*xx= [[[jid stringValue]componentsSeparatedByString:@"@"]firstObject];
            XMPPPresence  *presence;
            for (XMPPPresence*cc in self.subscribeArray) {
                if ([cc.from.user isEqualToString:xx]) {
                    presence=cc;
                }
            }
            if (presence) {
                [self.subscribeArray removeObject:presence];
            }
            [self performSelector:@selector(reloadFriend) withObject:nil afterDelay:1];
           
        }
    }
    
    
    return YES;
}
-(void)reloadFriend{
    if (self.friendType) {
        self.friendType(YES);
    }
}
#pragma mark 发送邀请他人进入聊天室

-(void)inviteRoom:(XMPPRoom*)room userName:(NSString*)userName{
    
    NSString*nickName=UNCODE( [xmppvCardTempModule myvCardTemp]
.nickname);
    
    if (nickName==nil) {
        nickName=userName;
    }
    
    NSString*newUserName=[[userName componentsSeparatedByString:@"@"]firstObject];
    
    [room inviteUser:[XMPPJID jidWithUser:newUserName domain:XMPP_DOMAIN resource:ZIYUANMING]  withMessage:[NSString stringWithFormat:@"%@邀请你加入{%@}的聊天室",nickName,_groupConfigDic[@"name"]]];
    //回调在通过新人进入聊天室获得
    
    
}
#pragma mark 拒绝进入聊天室
-(void)rejectRoom:(NSDictionary*)dic{
    /*
     <message
     from='hecate@shakespeare.lit/broom'
     to='darkcave@chat.shakespeare.lit'>
     <x xmlns='http://jabber.org/protocol/muc#user'>
        <decline to='crone1@shakespeare.lit'>
            <reason>
                Sorry, I'm too busy right now.
            </reason>
        </decline>
     </x>
     </message>
     */
    XMPPvCardTemp*temp=[xmppvCardTempModule myvCardTemp];

    XMPPMessage*message=[[XMPPMessage alloc]init];
    [message addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@/%@",[userDefaults objectForKey:kXMPPmyJID],XMPP_DOMAIN,ZIYUANMING]];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@.%@",dic[@"from"],GROUND,XMPP_DOMAIN]];
    
    NSXMLElement*element=[NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    NSXMLElement *decline = [NSXMLElement elementWithName:@"decline"];
    [decline addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@/%@",dic[@"to"],XMPP_DOMAIN,ZIYUANMING]];
    
    if ([dic[@"reason"] length] > 0)
    {
        NSString*reason;
        
        NSString*temp1=dic[@"reason"];
        
        //判断{}的位置然后进行截取出聊天室名字
        NSRange range=[temp1 rangeOfString:@"{"];
        NSRange range1=[temp1 rangeOfString:@"}"];
        //进行截取
        NSString*roomName=[temp1 substringWithRange:NSMakeRange(range.location+1,temp1.length-range1.location)];
        
        if (temp.nickname) {
            reason=[NSString stringWithFormat:@"%@拒绝加入%@聊天室",UNCODE(temp.nickname),roomName];
        }else{
            reason=[NSString stringWithFormat:@"%@拒绝加入%@聊天室",[userDefaults objectForKey:kXMPPmyJID],roomName];
        }
        
        [decline addChild:[NSXMLElement elementWithName:@"reason" stringValue:reason]];
    }
    
    [element addChild:decline];
    
    [message addChild:element];
    
    
    [xmppStream sendElement:message];
    
    //读取plist列表 type修改为3
   NSUInteger x= [self.groupCheckListArray indexOfObject:dic];
    NSMutableDictionary*newDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    
    [newDic setValue:@"3" forKey:@"type"];

    [self.groupCheckListArray replaceObjectAtIndex:x withObject:newDic];
    //进行持久化保存
    [self.groupCheckListArray writeToFile:[NSString stringWithFormat:@"%@%@groupCheckList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]] atomically:YES];
    //调用block
    if (_GroupCheck) {
        self.GroupCheck(self.groupCheckListArray);
    }
}


-(void)agreeRoom:(NSDictionary*)dic{
    //读取plist列表 type修改为2 理由写上请在群组中查看
    NSUInteger x= [self.groupCheckListArray indexOfObject:dic];
    NSMutableDictionary*newDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    
    [newDic setValue:@"2" forKey:@"type"];
    [self.groupCheckListArray replaceObjectAtIndex:x withObject:newDic];
    //进行持久化保存
    [self.groupCheckListArray writeToFile:[NSString stringWithFormat:@"%@%@groupCheckList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]] atomically:YES];
    //调用block
    if (_GroupCheck) {
        self.GroupCheck(self.groupCheckListArray);
    }

    if (_myRoomList) {
        //对比是否存在
        BOOL is=NO;
        for (NSDictionary*dic1 in _roomListArray) {
            NSString*from=dic1[@"from"];
            if ([dic[@"from"] isEqualToString:from]) {
                is=YES;
            }
        }
        
        if (is==NO) {
            [_roomListArray addObject:dic];
            
            //持久化保存
            [_roomListArray writeToFile:[NSString stringWithFormat:@"%@%@roomList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]] atomically:YES];
            _myRoomList(_roomListArray);
        }
    }

    
}
#pragma mark 获得自己的群组列表
-(void)myGroupListBlock:(void(^)(NSMutableArray*))myRoomList
{
    self.myRoomList=myRoomList;
    if (_myRoomList) {
        _myRoomList(_roomListArray);
    }
    
}
#pragma mark 处理接收到群邀请和群被拒绝
-(void)aboutMucRoom:(XMPPMessage*)message
{
    
    /*发送邀请 别人拒绝
     <message xmlns="jabber:client" from="room2@conference.admin-88ixf99az" to="admin@admin-88ixf99az"><x xmlns="http://jabber.org/protocol/muc#user"><decline from="123@admin-88ixf99az"><reason>No thank you</reason></decline></x></message>
     */
    /*
     别人发送邀请
     <message xmlns="jabber:client" from="123_3dk@conference.admin-88ixf99az" to="admin@admin-88ixf99az"><x xmlns="http://jabber.org/protocol/muc#user"><invite from="123@admin-88ixf99az"><reason>请把我加入会议中。</reason></invite></x><x xmlns="jabber:x:conference" jid="123_3dk@conference.admin-88ixf99az"/></message>
     */
    NSString*type1=[[message attributeForName:@"type"] stringValue];
    if ([type1 isEqualToString:@"error"]) {
        return;
    }
    
    NSArray*xArray= [message elementsForName:@"x"];
    //房间账号
    NSString*from= [[message attributeForName:@"from"]stringValue];
   DDXMLElement*element= [xArray objectAtIndex:0];
    //邀请人
     NSString*to=[[[[element elementsForName:@"invite"] firstObject]attributeForName:@"from"] stringValue];
    //是否拒绝
    NSArray*declineArray=[element elementsForName:@"decline"];
    NSString*reason;
    NSString*type;
    
    if (declineArray.count) {
    //别人拒绝你
        DDXMLElement*elementItem=[declineArray objectAtIndex:0];
       to= [[elementItem attributeForName:@"from"]stringValue];
        
       reason=[[elementItem elementForName:@"reason"]stringValue];
        if (reason==nil) {
            reason=@" ";
        }
        type=@"0";
    
    }else{
     //别人邀请你

        reason=[[[element elementForName:@"invite"]elementForName:@"reason"]stringValue];
        if (reason==nil) {
            reason=@" ";
        }
        type=@"1";
    
    }

    
    /*type
     0 别人拒绝
     1 别人邀请
     2 已经加入
     3 已经拒绝
     */
    BOOL is=NO;
    for (NSDictionary*dic in self.groupCheckListArray) {
        NSString*from1=dic[@"from"];
        if ([from1 isEqualToString:[[from componentsSeparatedByString:@"@"] firstObject]]) {
            is=YES;
        }
        
    }
    
    
    if (!is) {
        [self.groupCheckListArray insertObject:@{@"from":[[from componentsSeparatedByString:@"@"] firstObject],@"to":[[to componentsSeparatedByString:@"@"] firstObject],@"reason":reason,@"type":type,@"date":[NSDate date]} atIndex:0];
        //进行持久化保存
        [self.groupCheckListArray writeToFile:[NSString stringWithFormat:@"%@%@groupCheckList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]] atomically:YES];
        //调用block
        if (_GroupCheck) {
            self.GroupCheck(self.groupCheckListArray);
        }
    }
    
   
 
}

#pragma mark 加入聊天室（没有就创建）
-(XMPPRoom*)xmppRoomCreateRoomName:(NSString *)roomName nickName:(NSString *)nickName MessageBlock:(void(^)(NSDictionary*))a configBlock:(void(^)(NSDictionary*))b{
 //记录block指针，以及相应的房间jid，为消息接口准备
    self.GroupMessage=a;
    self.GroupConfig=b;
//对出席列表字典初始化
    self.presentDic=[NSMutableDictionary dictionaryWithCapacity:0];
    NSString*str=[[roomName componentsSeparatedByString:@"@"]firstObject];
    self.nowRoomJid=str;
    //@"room2@conference.127.0.0.1"
    //指定的房间号 如果没有就创建
    XMPPRoom* room = [[XMPPRoom alloc] initWithRoomStorage:[XMPPRoomCoreDataStorage sharedInstance] jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@.%@",str,GROUND,XMPP_DOMAIN]] dispatchQueue:dispatch_get_main_queue()];
    //激活
     [room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [room activate:xmppStream];
    [userDefaults removeObjectForKey:GROUNDROOMCONFIG];
    //使用的昵称 进入房间的函数
    [room joinRoomUsingNickname:nickName history:nil];
    [room configureRoomUsingOptions:nil];
    //获取房间配置信息
    [self fetchRoomName:roomName Block:_GroupConfig];
   
    
    
    return room;
  
}
#pragma mark 房间创建成功
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    //在获得聊天室信息里面调用了
  //  [sender fetchConfigurationForm];
}
#pragma mark xmpp房间配置
-(void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm {

    [self configRoom:sender config:configForm];

}

#pragma mark 获得聊天室信息
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{

    //发送房间配置请求
    [sender fetchConfigurationForm];
//    //发送禁止名单请求
//	[sender fetchBanList];
//    //发送好友名单请求
//	[sender fetchMembersList];
//    //发送主持人请求
	[sender fetchModeratorsList];
}
#pragma mark 验证信息
-(void)groupCheckWithBlock:(void(^)(NSArray*))a
{
    self.GroupCheck=a;
    //数据保存顺序为倒叙
    
    //读取对应用户的相应plist文件
    //读取plist文件
    sharedManager.groupCheckListArray=[NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@%@groupCheckList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]]];
    sharedManager.roomListArray=[NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@%@roomList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]]];
    if (sharedManager.groupCheckListArray==nil) {
        sharedManager.groupCheckListArray=[NSMutableArray array];
    }
    if (sharedManager.roomListArray==nil) {
        sharedManager.roomListArray=[NSMutableArray array];
    }
    if (_groupCheckListArray.count) {
        self.GroupCheck(_groupCheckListArray);
    }
    

}
-(void)XmppOutRoom:(XMPPRoom*)room{
    _nowRoomJid=nil;
    [room deactivate];
    //退出房间删除该房间的配置信息
    [userDefaults removeObjectForKey:GROUNDROOMCONFIG];
    [userDefaults synchronize];
}

#pragma mark 重新配置聊天室
-(void)configRoom:(XMPPRoom*)room config:(NSXMLElement*)config{
    
    NSDictionary*dic=[userDefaults objectForKey:GROUNDNAME];
//如果没有设置就不改变
    if (dic==nil) {
        //保存配置信息
        [userDefaults setObject:[config XMLString] forKey:GROUNDROOMCONFIG];
        [userDefaults synchronize];
        NSArray*fields=[config elementsForName:@"field"];
        NSMutableDictionary*dic=[NSMutableDictionary dictionary];
        for (NSXMLElement *field in fields) {
            //房间名称
            NSString *var = [field attributeStringValueForName:@"var"];
            if ([var isEqualToString:@"muc#roomconfig_roomname"]) {
                [dic setObject:[[[field elementsForName:@"value"]firstObject] stringValue] forKey:@"name"];
                
                
            }
            //描述
            if ([var isEqualToString:@"muc#roomconfig_roomdesc"]) {
                [dic setObject:[[[field elementsForName:@"value"]firstObject] stringValue] forKey:@"name"];
            }

        }
        

        return;
    }
    
    NSXMLElement*newConfig=nil;
    if (config) {
        newConfig=[config copy];
    }else{
        NSString*str= [userDefaults objectForKey:GROUNDROOMCONFIG];
        if (str==nil) {
            return;
        }
       newConfig=[[NSXMLElement alloc]initWithXMLString:str error:nil];
    }
    NSArray*fields=[newConfig elementsForName:@"field"];
    
    /*
NSDictionary*dic=@{@"name":nikeName.text,@"desName":[NSString stringWithFormat:@"%@",desName.text],@"isOpen":[NSString stringWithFormat:@"%d",isOpen],@"num":[NSString stringWithFormat:@"%d",num]};
     */
  
    

	for (NSXMLElement *field in fields) {
        
        NSString *var = [field attributeStringValueForName:@"var"];
        //房间名称
        if ([var isEqualToString:@"muc#roomconfig_roomname"]&&[dic objectForKey:@"name"]) {
                    [field removeChildAtIndex:0];
                    [field addChild:[NSXMLElement elementWithName:@"value" stringValue:[dic objectForKey:@"name"]]];
                }
        //房间描述
        if ([var isEqualToString:@"muc#roomconfig_roomdesc"]&&[dic objectForKey:@"desName"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:[dic objectForKey:@"desName"]]];
        }
        //房间永久化
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]&&[dic objectForKey:@"isOpen"]) {
            if ([[dic objectForKey:@"isOpen"]isEqualToString:@"1"]) {
                [field removeChildAtIndex:0];
                [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
            }
            
        }
        //设置人数
        if ([var isEqualToString:@"muc#roomconfig_maxusers"]&&[dic objectForKey:@"num"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:[dic objectForKey:@"num"]]];
            
        }
        
        if ([var isEqualToString:@"muc#roomconfig_changesubject"]||[var isEqualToString:@"muc#roomconfig_allowinvites"]) {
            
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
    }
    
    [userDefaults setObject:[newConfig XMLString] forKey:GROUNDROOMCONFIG];
    //删除掉配置信息
    [userDefaults removeObjectForKey:GROUNDNAME];
    [userDefaults synchronize];
    
    if (_fetchRoom) {
        //时间现在
        //来自哪里
        NSDate*date=[NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        NSDictionary*dic1=@{@"des":dic[@"desName"],@"num":@"0",@"time":destDateString,@"from":room.roomJID.user,@"name":dic[@"name"]};
        self.groupConfigDic=[NSMutableDictionary dictionaryWithDictionary:dic];

        self.fetchRoom(dic1);

    }
    
    [room configureRoomUsingOptions:newConfig];
}

#pragma mark room相关代理
//房间存在
//收到禁止名单列表
-(void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items{

};
//收到群成员名单列表
-(void)xmppRoom:(XMPPRoom*)sender didFetchMembersList:(NSArray*)items
{
    
  NSLog(@"%@",items);
}
//收到主持人名单列表
-(void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items{
    // "<item role=\"moderator\" jid=\"admin@admin-88ixf99az/IOS\" nick=\"zhangcheng\" affiliation=\"owner\"></item>"
//    self.GroupPresent(nil);
}
//房间不存在
//没有禁止名单列表
-(void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError{

}
//没有群成员名单列表
-(void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError{

}
//没有主持人名单列表
-(void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError{
//    self.GroupPresent(nil);

}
//房客的进入和离开
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
}
//房客离开
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
}
//房客更新
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
}



#pragma mark  离开房间[room deactivate:xmppStream];
-(void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    
	DDLogVerbose(@"%@:%@",THIS_FILE,THIS_METHOD);
}
#pragma mark 新人加入群聊
-(void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
    
	DDLogVerbose(@"%@: %@",THIS_FILE,THIS_METHOD);
}
//有人退出群聊
-(void)xmppRoom:(XMPPRoom*)sender occupantDidLeave:(XMPPJID *)occupantJID
{
	DDLogVerbose(@"%@:%@",THIS_FILE,THIS_METHOD);
}
#pragma mark 群内发言可以在进入聊天室以后获得
//有人在群里发言
-(void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    
 
    
    
    if ([sender.roomJID.user hasPrefix:self.nowRoomJid]) {
        //occupantJID.user房间的jid
        NSMutableDictionary*dic=[NSMutableDictionary dictionary];
        [dic setObject: message.body forKey:@"body"];
        NSArray*array=[[message elementForName:@"delay"]attributes];
        if (array.count) {
            //第一个是时间 第二个是来自谁
            NSString*timeStr= [[array firstObject]stringValue];
            NSString*jidStr=[[[[array lastObject]stringValue]componentsSeparatedByString:@"@"] firstObject];
            //时间处理
            NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //字符串处理
            timeStr=[[[timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "]stringByReplacingOccurrencesOfString:@"Z" withString:@""]substringToIndex:18];
            
            
            NSDate*gg= [formatter dateFromString:timeStr];
            
            if (jidStr==nil) {
                //证明是自己 YES是自己
                [dic setObject:[NSNumber numberWithBool:YES] forKey:@"isOutgoing"];
                [dic setObject:[NSDate date] forKey:@"timestamp"];
            }else{
                [dic setObject:[NSNumber numberWithBool:[jidStr isEqualToString:[userDefaults objectForKey:kXMPPmyJID]]] forKey:@"isOutgoing"];
                [dic setObject:gg forKey:@"timestamp"];
                
            }
            
        }else{
            [dic setObject:[NSDate date] forKey:@"timestamp"];
            NSArray*array1= [message attributes];
            [dic setObject:[NSNumber numberWithBool:[[array1[2] stringValue] isEqualToString:[userDefaults objectForKey:kXMPPmyJID]]] forKey:@"isOutgoing"];
        }
        
        
        
        
        
        self.GroupMessage(dic);
    }
    [self receiveMessage:message];
	DDLogVerbose(@"%@: %@",THIS_FILE,THIS_METHOD);
}
#pragma mark 发送群聊消息
-(void)sendGroupMessage:(NSString*)messageStr roomName:(NSString*)roomName{
    //按照@进行切割
    NSString*newRoomName=[[roomName componentsSeparatedByString:@"@"]firstObject];
    
    //生成房间jid
    NSString* roomJid = [NSString stringWithFormat:@"%@@%@.%@",newRoomName,GROUND,XMPP_DOMAIN];
   
    XMPPMessage*aMessage=[XMPPMessage messageWithType:@"groupchat" to:[XMPPJID jidWithString:roomJid] elementID:[userDefaults objectForKey:kXMPPmyJID]];

    //设置发送的内容
     [aMessage addChild:[DDXMLNode elementWithName:@"body" stringValue:messageStr]];
    //发送
    [xmppStream sendElement:aMessage];
    
    ZCMessageObject*model=[[ZCMessageObject alloc]init];
    model.messageFrom=[userDefaults objectForKey:kXMPPmyJID];
    model.messageDate=[NSDate date];
    model.messageTo=newRoomName;
    model.messageType=GROUPCHAT;
    model.messageContent=messageStr;
    //保存最近聊天记录
    BOOL isSucceed=[ZCMessageObject save:model];
    if (isSucceed) {
//        NSLog(@"最近聊天保存成功");
    }
    
    
    

}



#pragma mark *******************************
#pragma mark 文件传输
-(void)test{
    [TURNSocket initialize];
    [TURNSocket setProxyCandidates:[NSArray arrayWithObjects:XMPP_DOMAIN,nil]];
    TURNSocket *objTURNSocket = [[TURNSocket alloc] initWithStream:xmppStream toJID:  [XMPPJID jidWithUser:@"123" domain:XMPP_DOMAIN resource:@"IOS"] ];
                                                                                        
    [objTURNSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue() ];
    
    
}

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    
}

- (void)turnSocketDidFail:(TURNSocket *)sender{

}
#pragma mark 个人中心
-(void)getMyVcardBlock:(void(^)(BOOL,XMPPvCardTemp*))c{
    self.myVcardBlock=c;

 XMPPvCardTemp*temp=[xmppvCardTempModule myvCardTemp];
    //记录自己的名片信息
    self.myVcard=temp;
    if (temp) {
        if (self.myVcardBlock) {
            self.myVcardBlock(YES,temp);
            self.myVcardBlock=nil;
 
        }
    }
}
//观察myVcardTemp获取的状态
//收到xmppMyVcard的指针值
- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    
    if ([jid.user isEqualToString:[userDefaults objectForKey:kXMPPmyJID]]) {
        
        
        if (self.myVcardBlock) {
            
            self.myVcardBlock(YES,vCardTemp);
            self.myVcardBlock=nil;

        }
    }else{
    
      NSArray*array=  [self.friendVcardDic objectForKey:jid.user];
        if (array) {
            //遍历群发
            vCardTemp.jid=jid;
            for (void(^vcard)(BOOL,XMPPvCardTemp*) in array) {
                if (vcard) {
                    vcard(YES,vCardTemp);

                }
            }
            
            //群发后删除该value
            [self.friendVcardDic removeObjectForKey:jid.user];
        }
        

    }
    
    
   
    
}


-(void)customVcardXML:(NSString*)Value name:(NSString*)Name myVcard:(XMPPvCardTemp*)myVcard
{
    NSXMLElement *elem = [myVcard elementForName:(Name)];
    
    if (elem == nil) {
        elem = [NSXMLElement elementWithName:(Name)];
        [myVcard addChild:elem];
    }
    [elem setStringValue:(Value)];
}
-(void)upData:(XMPPvCardTemp*)vCard
{
    //获取自己的最新的vcard
    self.myVcard=vCard;

    [xmppvCardTempModule updateMyvCardTemp:vCard];
}

#pragma mark 同意好友请求
//同意
-(void)agreeRequest:(NSString*)name
{
    NSString*newName=[[name componentsSeparatedByString:@"@"]firstObject];
    
    XMPPJID *jid = [XMPPJID jidWithUser:newName domain:XMPP_DOMAIN resource:ZIYUANMING];
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    XMPPPresence*temp=nil;
        for (XMPPPresence*pre in subscribeArray)
        {
            if ([[[pre.from.user componentsSeparatedByString:@"@"]firstObject] isEqualToString:newName])
            {
                temp=pre;
            }
        }

    if (temp) {
        [self.subscribeArray removeObject:temp];

    }
   }
#pragma mark 拒绝好友请求
//拒绝
-(void)reject:(NSString*)name{
    NSString*newName=[[name componentsSeparatedByString:@"@"]firstObject];
    
    XMPPJID *jid = [XMPPJID jidWithUser:newName domain:XMPP_DOMAIN resource:ZIYUANMING];
   [xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
    XMPPPresence*temp=nil;
    for (XMPPPresence*pre in subscribeArray)
    {
        if ([[[pre.from.user componentsSeparatedByString:@"@"]firstObject] isEqualToString:name])
        {
            temp=pre;
        }
    }
    
    if (temp) {
        [self.subscribeArray removeObject:temp];
        
    }
    
}
#pragma mark 获得好友的资料Vcard
-(void)friendsVcard:(NSString *)useId Block:(void(^)(BOOL,XMPPvCardTemp*))a{
    //判断是否携带@feiqueit.com
    NSString*newUserId=[[useId componentsSeparatedByString:@"@"]firstObject];
    
    XMPPvCardTemp*tempvCard=   [xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithUser:newUserId domain:XMPP_DOMAIN resource:ZIYUANMING] shouldFetch:YES];
    
    tempvCard.jid=[XMPPJID jidWithUser:newUserId domain:XMPP_DOMAIN resource:ZIYUANMING];
    
    
    if (tempvCard) {
       
        a(YES,tempvCard);
    }else{
        NSMutableArray*array=self.friendVcardDic[newUserId];
        if (!array) {
            array=[NSMutableArray arrayWithCapacity:0];
        }
        [array addObject:[a copy]];
        [self.friendVcardDic setObject:array forKey:newUserId];
    
    }
    
    
}


#pragma mark 别人是否同意好友请求以及上线下线更新
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{  //
//    
//    NSManagedObjectContext *context = [xmppRosterStorage mainThreadManagedObjectContext];
//  
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    [request setEntity:entity];
//    NSError *error ;
//    NSArray *friends = [context executeFetchRequest:request error:&error];
//    
//  
//
//    //更新好友状态
//    for (XMPPUserCoreDataStorageObject *object in friends) {
//        if ([object.jidStr isEqualToString:presence.fromStr] || [object.jidStr isEqualToString:presence.from.bare]) {
//            [[[[object primaryResource] presence] childAtIndex:0] setStringValue:presence.status];
//          //  [[NSNotificationCenter defaultCenter]postNotificationName:FRIENDS_TYPE object:nil];
//        }
//        
//    }
    
    NSString *presenceType = [presence type];
    
    NSLog(@"好友状态更新   user--%@   type---%@  status--%@ ",[[presence from] user],presenceType,[presence status]);
    XMPPJID *jid = [XMPPJID jidWithUser:[presence from].user domain:XMPP_DOMAIN resource:ZIYUANMING];
    if ([presenceType isEqualToString:@"subscribe"]) {
        if (subscribeArray.count==0) {
            [self.subscribeArray addObject:presence];
        }else{
            BOOL isExist=NO;
            for (XMPPPresence*pre in subscribeArray)
            {
                if ([pre.from.user isEqualToString:presence.from.user])
                {
                    isExist=YES;
                }
            }
            if (!isExist) {
                [self.subscribeArray addObject:presence];
            }
        }
#pragma mark 保存验证消息，在这里需要注释，有错误
        //保存验证消息 判断是否已经有验证消息，如果有验证消息，则取出其中的值，进行保存
//        NSUserDefaults*userDefault=[NSUserDefaults standardUserDefaults];
//        NSString*myjid=  [userDefault objectForKey:kXMPPmyJID];
//        NSString*numStr=[yanzhengxiaoxi objectForKey:[presence from].user];
//        if (!numStr) {
//            [yanzhengxiaoxi setObject:@"1" forKey:[presence from].user];
//            
//           
//        }else{
//            int num=[numStr intValue];
//            [yanzhengxiaoxi setObject:[NSString stringWithFormat:@"%d",num++] forKey:[presence from].user];
//        
//        }
//        [userDefault setObject:yanzhengxiaoxi forKey:myjid];
//        [userDefault synchronize];
        
    }
    if ([presenceType isEqualToString:@"unsubscribed"]) {
        //拒绝
       //[xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
        
    }
    if ([presenceType isEqualToString:@"unsubscribe"]) {
       // [xmppRoster unsubscribePresenceFromUser:jid];//遇到对方拒绝我的请求，我也拒绝他，然后从列表中删除这个人
    }
    if ([presenceType isEqualToString:@"subscribed"]) {
        //取得状态 subscribed同意后   subscribe 同意前
        //别人添加你，状态为subscribe为同意前，然后发送同意给对方 ，对方收到后为subscribed
        //你添加别人，状态为subscribed为同意前，然后发送状态，刷新列表
        //双向关注后为好友
        [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];//同意
    }
    if (self.friendType) {
        self.friendType(YES);
    }
    
    
//	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

#pragma mark 添加好友 可以带一个消息
-(void)addSomeBody:(NSString *)userId Newmessage:(NSString*)message
{//添加好友
    if (message) {
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:userId domain:XMPP_DOMAIN resource:ZIYUANMING]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:message]];
        [xmppStream sendElement:mes];
    }
    
    [xmppRoster subscribePresenceToUser:[XMPPJID jidWithUser:userId domain:XMPP_DOMAIN resource:ZIYUANMING]];
}
#pragma mark 删除好友
-(void)removeBuddy:(NSString *)name
{//删除好友
    XMPPJID *jid = [XMPPJID jidWithUser:name domain:XMPP_DOMAIN resource:ZIYUANMING];
    
    [ xmppRoster removeUser:jid];
}
#pragma mark 发送消息
-(void)sendMessageWithJID:(NSString*)jidStr Message:(NSString*)message Type:(NSString*)type{
    //jidStr  xxx@ddd.net 需要截取@之前的
   
   NSArray*array= [jidStr componentsSeparatedByString:@"@"];
    
    XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:array[0] domain:XMPP_DOMAIN resource:ZIYUANMING]];
    [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:[NSString stringWithFormat:@"%@%@",type,message]]];
    
    //执行发送消息
    [xmppStream sendElement:mes];
    
//一
    //发送消息处理一下进行记录,只记录和这个人关联的最后一条信息
    //1、date(时间)  from（自己） to array[0]  type类型(群聊单聊) message 消息
    //主要记录最近聊天人，正查反查 只保留最后一条
    //messageFrom,messageTo,messageContent,messageDate,messageType
    ZCMessageObject*model=[[ZCMessageObject alloc]init];
    model.messageFrom=[userDefaults objectForKey:kXMPPmyJID];
    model.messageDate=[NSDate date];
    model.messageTo=array[0];
    model.messageType=SOLECHAT;
    model.messageContent=[NSString stringWithFormat:@"%@%@",type,message];
//保存最近聊天记录
    BOOL isSucceed=[ZCMessageObject save:model];
    if (isSucceed) {
//        NSLog(@"最近聊天保存成功");
    }


//二
    //赋值属性chatPerson默认为NONE(创建单例时候赋值了)
    //建立一个方法，记录聊天人是谁，聊天人为本类的属性chatPerson
    //建立一个方法，当点击返回时候，需要清除掉chatPerson不调用block
    //以上2个方法使用valuationChatPersonName通过BOOL进行判断
    //依靠本类属性来判断是否调用block
    //在聊天页面接收Block回调
    //受到影响的有发送界面以及最近联系人
#pragma mark  发送消息没有完成的地方
//三
    
    //判断发送消息是否成功

    
//进行广播
    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:nil];
    
//    if (sendMessageNum) {
//        self.accept(model);
//    }else{
//       }
//    
//    sendMessageNum=1;
    //延迟0.1秒调用回调
    [self performSelector:@selector(loadMessageClick:) withObject:model afterDelay:0.1];

    
}
-(void)loadMessageClick:(ZCMessageObject*)message{
    self.accept(message);
}
/****************************/
#pragma mark 消息发送完成 有待测试
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
}
#pragma mark 消息发送失败 有待测试
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
}
#pragma mark 处理接收到的单聊群聊消息（内部调用）
-(void)receiveMessage:(XMPPMessage*)message{
    /*
     消息函数处理3种信息  1、是否是当前聊天人，如果是，则调用block进行回调，如果不是，记录为未读消息
     */
    
    //一、当聊天人存在的时候，创建对象，使用block进行回调，刷新那个界面
    NSString*fromName=[[[[message from]bare]componentsSeparatedByString:@"@"]objectAtIndex:0];
    NSString*type=[[[[message from]bare]componentsSeparatedByString:@"@"]objectAtIndex:1];
    
    NSString*body=[[message elementForName:@"body"] stringValue];
    ZCMessageObject*object=[[ZCMessageObject alloc]init];
    object.messageDate=[NSDate date];
    object.messageType=[type hasPrefix:XMPP_DOMAIN]?SOLECHAT:GROUPCHAT;
    object.messageFrom=fromName;
    object.messageContent=body;
    object.messageTo=[userDefaults objectForKey:kXMPPmyJID];
    
    
    [ZCMessageObject save:object];
    
     NSString*friendjid=[NSString stringWithFormat:@"%@@%@",fromName,XMPP_DOMAIN];
    if (![self.chatPerson isEqualToString:NONE]&&[self.chatPerson isEqualToString:friendjid]) {
      
        self.accept(object);
    }else{
        //二、记录当前每一个人有多少条未读 ，当获得聊天记录时候，把当前未读消息清0
        /*
         未读消息是一个字典，用于保存未读的条数
         */
        //信息发送人不是当前聊天人，记录为未读信息,保存未读消息
        
        NSString*numStr=  [self saveWeiduMessage:fromName];
        //三、得到一个徽标属性（已有），每次有新消息时候，判断是否是当前聊天联系人，如果不是，则未读消息+1，把徽标值进行改变，并且进行提示有新消息
        if (self.badgeValue) {
            self.badgeValue.badgeValue=numStr;
        }
        //四、验证消息
        if ([yanzhengxiaoxi objectForKey:fromName]) {
            [yanzhengxiaoxi setObject:body forKey:fromName];//判断是否是验证信息的消息
            
        }
    }
     [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:nil];
}
/****************************/
#pragma mark 接收消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
//一、单聊消息
    if ([[message elementForName:@"body"] stringValue]) {
        [self receiveMessage:message];
    }
//二、聊天室接受到邀请和邀请被拒绝的消息
  NSXMLElement*mucElement=  [message elementForName:@"x"];
   NSArray*spaceArray= [mucElement namespaces];
    
   [spaceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if ([[obj stringValue] isEqualToString:@"http://jabber.org/protocol/muc#user"]) {
           [self aboutMucRoom:message];
           
       }
   }];
}

#pragma mark 好友列表
-(NSArray*)friendsList:(void(^)(BOOL))c{
    self.friendType=c;
    NSManagedObjectContext*context=[xmppRosterStorage mainThreadManagedObjectContext];
    NSEntityDescription*entity=[NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSString*currentJid=[NSString stringWithFormat:@"%@@%@",[userDefaults objectForKey:kXMPPmyJID],XMPP_DOMAIN];
    //currentJid   qianfeng567@qianfeng.net
    //谓词搜索条件为streamBareJidStr关键词
     NSPredicate*predicate=[NSPredicate predicateWithFormat:@"streamBareJidStr==%@",currentJid];
    NSFetchRequest*request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    [request setPredicate:predicate];//筛选条件
    NSError*error;
    NSArray*friends=[context executeFetchRequest:request error:&error];//从数据库中取出数据
    NSMutableArray*guanzhu=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*beiguanzhu=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*duifang=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray*haoyou=[NSMutableArray arrayWithCapacity:0];
    
    for (XMPPUserCoreDataStorageObject*object in friends) {
//获得数据是空
//     XMPPvCardTemp*fr= [xmppvCardTempModule vCardTempForJID:object.jid shouldFetch:YES];
//        
//        NSLog(@"%@",fr.jid);
        
//对Vcard进行扩展
//        if ([[model elementForName:@"SIGNATYRE"] stringValue]) {
//
//        }
        
        if ([object.subscription isEqualToString:@"to"]) {
            [guanzhu addObject:object];
            
        }else{
            if ([object.subscription isEqualToString:@"from"]) {
                [beiguanzhu addObject:object];
            }else{
                if ([object.subscription isEqualToString:@"none"]) {
                    [duifang addObject:object];
                }else{
                    if ([object.subscription isEqualToString:@"both"]) {
                        [haoyou addObject:object];
                                           }
                }}}}

        

        


    self.listArray=@[haoyou,guanzhu,beiguanzhu,duifang];
 
    /*
     @dynamic nickname;//昵称
     @dynamic displayName, primitiveDisplayName;//
     @dynamic subscription;//关注状态  from 你关注我  to  我关注对方 同意   none 我关注对方 没同意
     @dynamic ask;//发个请求
     @dynamic unreadMessages;//未读消息
     @dynamic photo;
     */

    return _listArray;

}
//获得头像
- (UIImage *)avatarForUser:(XMPPUserCoreDataStorageObject *) user
{
    UIImage* photo;
    if (user.photo)
    {
        photo = user.photo;
    }
    else
    {
        NSData *photoData =  [xmppvCardAvatarModule photoDataForJID:user.jid];;
        XMPPvCardTemp*myVcard1 =  [xmppvCardTempModule vCardTempForJID: user.jid shouldFetch:YES];
        
        if (photoData != nil) {
            
           
            
            photo = [UIImage imageWithData:[myVcard1 photo]];
        } else {
            
            photo=[UIImage imageNamed:@"logo_2@2x.png"];
        }
    }
    
    return photo;
    
}

#pragma mark 注册
-(void)registerMothod:(void(^)(BOOL))b
{
    logoinorSignin=YES;
    sharedManager.signin=b;
    //进行连接，连接失败 在进行注册操作
    [sharedManager connectLogin:^(BOOL isSucceed) {
        //登录必定是失败，然后进行注册步骤
       
        if ([xmppStream supportsInBandRegistration]) {
            
            NSError *error ;
            [xmppStream setMyJID:[XMPPJID jidWithUser:[userDefaults objectForKey:kXMPPmyJID] domain:XMPP_DOMAIN resource:@"IOS"]];
            
            //domain 是找服务器要这个名字就是服务器主机名字，在安装时候的名字
            //resource 这个是一个标示，具体参照QQ来自于土豪金
            if (![xmppStream registerWithPassword:[userDefaults objectForKey:kXMPPmyPassword]error:&error]) {
                
                sharedManager.signin(NO);
            }
        }

    }];

    

}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    //重复注册了用户名
    [xmppStream disconnect];
   sharedManager.signin(NO);
    logoinorSignin=NO;
    NSLog(@"注册名已存在");
    //  [MMProgressHUD dismissWithSuccess:@"注册名已存在!"];
}
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{//注册成功
   
    [xmppStream disconnect];
     sharedManager.signin(YES);
    logoinorSignin=NO;
    NSLog(@"注册成功");
     // [MMProgressHUD dismissWithSuccess:@"注册成功!"]
}

#pragma mark Connect/disconnect  登录

- (BOOL)connectLogin:(void(^)(BOOL))a
{
    sharedManager.logoin=a;
	if (![xmppStream isDisconnected]) {
		return YES;
	}

	NSString *myJID = [userDefaults stringForKey:kXMPPmyJID];
	NSString *myPassword = [userDefaults stringForKey:kXMPPmyPassword];
    
    NSLog(@"%@",myJID);
//    
//	// myJID = @"qianfeng567";
//	// myPassword = @"";
	
	if (myJID.length==0 || myPassword.length == 0) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"警告" message:@"检查是否输入了用户名密码" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
		return NO;
	}

    [xmppStream setMyJID:[XMPPJID jidWithUser:myJID domain:XMPP_DOMAIN resource:ZIYUANMING]];
    password=myPassword;
	NSError *error = nil;
//进行连接
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"连接错误");
        
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"服务器连接失败" message:@"ps:本服务器非24小时开启，若急需请QQ 149393437" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [al show];
        
        
        return NO;
    }
    
    
	return YES;
    
}
#pragma mark 注销
- (void)disconnect
{
    sendMessageNum=0;
    [userDefaults removeObjectForKey:kXMPPmyJID];
    [userDefaults removeObjectForKey:kXMPPmyPassword];
    
    [userDefaults removeObjectForKey:isLogin1];
    [userDefaults synchronize];
    [self.subscribeArray removeAllObjects];
    //销毁所有好友回调
    [self.friendVcardDic removeAllObjects];
    //发送离线消息
	[self goOffline];
    self.badgeValue=nil;
    self.myVcard=nil;
	[xmppStream disconnect];

}
- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[xmppStream sendElement:presence];
    
    
}

#pragma mark XMPPStream Delegate
- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    
    //将要开始连接
    NSLog(@"将要开始连接");
    //    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    //    [MMProgressHUD showWithTitle:@"正在连接中" status:@"疯狂加载中"];
}
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSLog(@"连接成功%@",password);
	
	isXmppConnected = YES;
	NSError *error = nil;
	
	if (![xmppStream authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	NSLog(@"完成认证，发送在线状态");
    [self goOnline];
    [xmppRoster fetchRoster];
    sharedManager.logoin(YES);
    
    //读取对应用户的相应plist文件
    //读取plist文件
    sharedManager.groupCheckListArray=[NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@%@groupCheckList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]]];
    sharedManager.roomListArray=[NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@%@roomList.plist",LIBPATH,[userDefaults objectForKey:kXMPPmyJID]]];
    if (sharedManager.groupCheckListArray==nil) {
        sharedManager.groupCheckListArray=[NSMutableArray array];
    }
    if (sharedManager.roomListArray==nil) {
        sharedManager.roomListArray=[NSMutableArray array];
    }
    
    
    
    
    
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"认证错误");
    if (!logoinorSignin) {
      [xmppStream disconnect];
    }
    
    sharedManager.logoin(NO);
    //  [MMProgressHUD dismissWithSuccess:@"认证错误!"];
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	//DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    //	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
 
}


- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    // type="available" is implicit
    [xmppStream sendElement:presence];
    NSLog(@"发送完在线状态");
//    if ([self connect]) {
//        XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
//        [xmppStream sendElement:presence];
//        NSLog(@"连接成功");
//    }else{
//        NSLog(@"连接失败");
//        
//    }
	
}
#pragma mark 设置当前聊天人是谁
-(void)valuationChatPersonName:(NSString*)name IsPush:(BOOL)isPush MessageBlock:(void(^)(ZCMessageObject*))a
{
    self.accept=a;
    if (isPush&&name.length>0) {
        //切割
        NSString*newName=[[name componentsSeparatedByString:@"@"]firstObject];
        //剩下数字账号,拼接主机地址
        //332131@feiqueit.com
        NSString*newName1=[NSString stringWithFormat:@"%@@%@",newName,XMPP_DOMAIN];
        
        self.chatPerson=newName1;
        
        
    }else{
        self.chatPerson=NONE;
    }
}
#pragma mark 保存未读消息
-(NSString*)saveWeiduMessage:(NSString*)fromName
{
   
    NSMutableDictionary*weiduMessage=[NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:weiduMESSAGE]];
    if (weiduMessage==nil) {
        weiduMessage=[NSMutableDictionary dictionaryWithCapacity:0];
    }
    int pageNum;
    
    if (![weiduMessage objectForKey:fromName]) {
        pageNum=1;
    }else{
        pageNum=[[weiduMessage objectForKey:fromName] intValue];
        pageNum++;
    }
    [weiduMessage setObject:[NSString stringWithFormat:@"%d",pageNum] forKey:fromName];
    
    NSArray*numArray=[weiduMessage allValues];
    int num=0;
    for (NSString*str in numArray) {
        num=+[str intValue];
    }
    
    [userDefaults setObject:weiduMessage forKey:weiduMESSAGE];
    [userDefaults synchronize];
    
    return [NSString stringWithFormat:@"%d",num];
}
-(NSArray*)messageRecord{
    if (sendMessageNum==0) {
        
    }
    NSManagedObjectContext *context = [xmppMessageArchivingCoreDataStorage  mainThreadManagedObjectContext ];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    
    //判断是否有联系人
    if ([self.chatPerson isEqualToString:NONE]) {
        return nil;
    }
     NSString*myjid=[NSString stringWithFormat:@"%@@%@",[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID],XMPP_DOMAIN];
    //谓词搜索当前联系人的信息
    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"bareJidStr==%@&&streamBareJidStr==%@",self.chatPerson,myjid];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
#pragma  mark 按照时间进行筛选
    //    NSDate *endDate = [NSDate date];
    //    NSTimeInterval timeInterval= [endDate timeIntervalSinceReferenceDate];
    //    timeInterval -=3600;
    //    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval] ;
    //    //对coredata进行筛选(假设有fetchRequest)
    //    NSPredicate *predicate_date =[NSPredicate predicateWithFormat:@"timestamp >= %@ AND timestamp <= %@", beginDate,endDate];
    //    [request setPredicate:predicate_date];//筛选时间
    
    [request setPredicate:predicate];//筛选条件
    NSError *error ;
    NSArray *messages = [context executeFetchRequest:request error:&error];
    
    
   
    return messages;


}
#pragma mark --------配置XML流---------
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    userDefaults=[NSUserDefaults standardUserDefaults];
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
        xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
    xmppReconnect = [[XMPPReconnect alloc] init];

    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    xmppvCardStorage=[XMPPvCardCoreDataStorage sharedInstance] ;
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    
	[xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    [xmppvCardTempModule   activate:xmppStream];
    [xmppvCardAvatarModule activate:xmppStream];

	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];

    
	[xmppStream setHostName:IP];
	[xmppStream setHostPort:5222];
	
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];

    
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
    self.subscribeArray=[NSMutableArray arrayWithCapacity:0];
    
    NSString*myjid=  [userDefaults objectForKey:kXMPPmyJID];
    if ([userDefaults objectForKey:myjid]) {
        self.yanzhengxiaoxi=[userDefaults objectForKey:myjid];
    }else{
        self.yanzhengxiaoxi=[NSMutableDictionary dictionaryWithCapacity:0];
    }
    self.friendVcardDic=[NSMutableDictionary dictionaryWithCapacity:0];
    //修复bug 2014.6.14
    [xmppRosterStorage mainThreadManagedObjectContext];
    
}
#pragma mark 更新花名册状态！发生在好友请求里面
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]];
    NSLog(@"花名册代理触发   user--%@   type---%@  status--%@ ",[[presence from] user],presenceType,[presence status]);
    XMPPJID *jid = [XMPPJID jidWithUser:[presence from].user domain:XMPP_DOMAIN resource:ZIYUANMING];
    
    if ([presenceType isEqualToString:@"unsubscribed"]) {
        
        [xmppRoster rejectPresenceSubscriptionRequestFrom:jid];//拒绝
    }
    
    if ([presenceType isEqualToString:@"subscribed"]) {
        
        [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];//同意
    }
    
    
}



- (void)dealloc
{
	[self teardownStream];
}
- (void)teardownStream
{
    
	[xmppStream removeDelegate:self];
    
	[xmppReconnect         deactivate];
    [xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
    [xmppvCardAvatarModule deactivate];
    
    
	[xmppStream disconnect];
	xmppStream = nil;
	xmppReconnect = nil;
    
}
@end
