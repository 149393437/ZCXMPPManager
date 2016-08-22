//
//  NSFileManager+Method.m
//  Day27_HttpDemo
//
//  Created by zhangcheng on 16/1/28.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "NSFileManager+Method.h"

@implementation NSFileManager (Method)
-(BOOL)fileWithPath:(NSString*)path TimeOut:(NSTimeInterval)time
{
    //首先这个路径是网络请求地址经过加密后的字符串,我们根据这个字符串来进行查找该文件是否存在
    
    NSFileManager*manager=[NSFileManager defaultManager];
    
    //创建文件路径
    NSString*newPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    
    if ([manager fileExistsAtPath:newPath]) {
        //文件存在,读取文件的创建时间
        NSDictionary*dic=[manager attributesOfItemAtPath:newPath error:nil];
        
        NSDate*date=[dic objectForKey:NSFileCreationDate];
        
        //NSFileSize计算文件大小
        
        
        //现在的时间
        NSDate*nowDate=[NSDate date];
        
        //二个时间的差值
        NSTimeInterval time1=[nowDate timeIntervalSinceDate:date];
        
        if (time>=time1) {
            return YES;
        }else{
            return NO;
        }
        
    }else{
        return NO;
    }


}
#pragma mark 清空缓存
-(void)clearCache{
    //需要知道我指定文件夹下的文件名称
    NSFileManager*manager=[NSFileManager defaultManager];
    
    NSString*path=[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
    //获取该文件夹下的文件名称
    NSArray*fileNameArray=[manager contentsOfDirectoryAtPath:path error:nil];
    
    //遍历数组方法 3种
    
    
    for (NSString*fileName in fileNameArray) {
        
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),fileName] error:nil];
    
    }
    
    
//    for (int i=0; i<fileNameArray.count; i++) {
//        NSString*fileName=fileNameArray[i];
//    }
//    
//    [fileNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
    
  
    
    
    



}



@end
