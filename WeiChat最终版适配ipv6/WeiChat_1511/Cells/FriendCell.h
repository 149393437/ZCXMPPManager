//
//  FriendCell.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/11.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTextView.h"
#import <BQMM/BQMM.h>
@interface FriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet MMTextView *qmd;
//保存cell的数据
@property(nonatomic,copy)NSString*jidStr;


//声明2个方法
//在好友列表中
-(void)configOfFriendModel:(XMPPUserCoreDataStorageObject*)object;

//最近联系中使用的
-(void)configOfRecent:(NSArray*)array;

@end
