//
//  NSFileManager+Method.h
//  Day27_HttpDemo
//
//  Created by zhangcheng on 16/1/28.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Method)
//传递一个路径和一个时间,返回文件是否超时
-(BOOL)fileWithPath:(NSString*)path TimeOut:(NSTimeInterval)time;
@end
