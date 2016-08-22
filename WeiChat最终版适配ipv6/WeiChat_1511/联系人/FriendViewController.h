//
//  FriendViewController.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RootViewController.h"

@interface FriendViewController : RootViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*tableView;

@end
