//
//  MyVcardViewController.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/10.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RootViewController.h"

@interface MyVcardViewController : RootViewController

@property(nonatomic,copy)NSString*friendJid;
//反向传递
@property(nonatomic,copy)void(^myBlock)();

-(instancetype)initWithBlock:(void(^)())a;

@end
