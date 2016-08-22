//
//  GroupAddFriendViewController.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/6.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "FriendViewController.h"

@interface GroupAddFriendViewController : RootViewController
{
    UIAlertView*al;
}
@property(nonatomic,assign)XMPPRoom*room;
@property(nonatomic,copy)void(^myBlock)(NSArray*);
-(instancetype)initWithBlock:(void(^)(NSArray*))a;
@end
