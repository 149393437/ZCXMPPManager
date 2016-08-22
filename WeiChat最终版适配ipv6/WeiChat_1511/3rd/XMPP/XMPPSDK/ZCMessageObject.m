//
//  ZCMessageObject.m
//  XMPPEncapsulation
//
//  Created by ZhangCheng on 14-4-10.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCMessageObject.h"
#import "FMDatabase.h"
@implementation ZCMessageObject
//增

+(BOOL)save:(ZCMessageObject*)aMessage
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    
    NSString *createStr=@"create table zcMessage (messageFrom,messageTo,messageContent,messageDate,messageType)";
    
    BOOL worked = [db executeUpdate:createStr];
    
    NSString * insertStr=@"insert into zcMessage values (?,?,?,?,?)";
    NSString*upDateStr=@"update zcMessage set messageContent=?, messageDate=? where messageTo=? and messageFrom=?";

    FMResultSet*call=[db executeQuery:@"select * from zcMessage where messageFrom=? and messageTo=?",aMessage.messageFrom,aMessage.messageTo];
    BOOL isData=NO;
    while ([call next]) {
        isData=YES;
    }
    if (!isData) {
        
        call=[db executeQuery:@"select * from zcMessage where messageFrom=? and messageTo=?",aMessage.messageTo,aMessage.messageFrom];//反查一次
        while ([call next]) {
            isData=YES;
        }
    }
    
    
    if (!isData) {
        //如果表内没有数据，就插入数据
      isData=  [db executeUpdate:insertStr,aMessage.messageFrom,aMessage.messageTo,aMessage.messageContent,aMessage.messageDate,aMessage.messageType];
    }else{
        //如果表内有数据，就更新数据
      isData=  [db executeUpdate:upDateStr,aMessage.messageContent,aMessage.messageDate,aMessage.messageTo,aMessage.messageFrom];//更新数据
        [db executeUpdate:upDateStr,aMessage.messageContent,aMessage.messageDate,aMessage.messageFrom,aMessage.messageTo];
    }
    
    [db close];
    return isData;
}
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex
{
    
    NSLog(@"%@",DATABASE_PATH);
    
    NSMutableArray *messageList=[NSMutableArray arrayWithCapacity:0];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }

    NSString *queryString=@"select *from zcMessage where messageFrom=? or messageTo=? order by messageDate desc limit ?";
    NSString*MYJID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    FMResultSet *rs=[db executeQuery:queryString,MYJID,MYJID,[NSString stringWithFormat:@"%d",pageIndex]];
    while ([rs next]) {
        NSMutableArray *messageSQL=[NSMutableArray arrayWithCapacity:0];
        if (messageSQL) {
            [messageSQL addObject:[rs stringForColumn:@"messageContent"]];
            [messageSQL addObject:[rs dateForColumn:@"messageDate"]];
            if (![MYJID isEqualToString:[rs stringForColumn:@"messageFrom"]]) {
                [messageSQL addObject:[rs stringForColumn:@"messageFrom"]];
            }else{
                [messageSQL addObject:[rs stringForColumn:@"messageTo"]];
            }
            [messageSQL addObject:[rs stringForColumn:@"messageType"]];
            
            [messageList addObject:messageSQL];
        }
        
    }
    return  messageList;
    

}
//更新类型，追加群主题
+(void)upDateType:(NSDictionary*)dic{

// NSDictionary*dic=@{@"des":str,@"num":str2,@"time":str3,@"from":str4};
    //des
  
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
       
    };
    
    NSString*upDateStr=@"update zcMessage set messageType=? where messageTo=? or messageFrom=?";
    NSString*user=[[dic[@"from"] componentsSeparatedByString:@"@"]firstObject];
    
    [db executeUpdate:upDateStr,[NSString stringWithFormat:@"%@%@",GROUPCHAT,dic[@"des"]],user,user];
    [db close];

    
}



@end
