//
//  RegisterManager.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RegisterManager.h"
static RegisterManager*manager=nil;
@implementation RegisterManager

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[RegisterManager alloc]init];
    });
    return manager;
}
@end




