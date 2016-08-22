//
//  GroupChatViewController.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/17.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RootViewController.h"

@interface GroupChatViewController : RootViewController
{
    //作为房间标记使用的
    XMPPRoom*room;
    UIButton*rightNavButton;
}
@property(nonatomic,copy)NSString*roomJid;
@property(nonatomic,strong)NSDictionary*roomConifgDic;
@end
