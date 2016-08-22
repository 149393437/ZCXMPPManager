//
//  HttpDownLoad.m
//  Day27_HttpDemo
//
//  Created by zhangcheng on 16/1/27.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "HttpDownLoad.h"
#import "NSFileManager+Method.h"
#import "MyMD5.h"

@implementation HttpDownLoad

-(instancetype)initWithURLStr:(NSString *)str Post:(BOOL)isPost DataDic:(NSDictionary *)dic Block:(void (^)(HttpDownLoad *, BOOL))a
{
    _myBlock=a;
    //请求方式
    _isPost=isPost;
    if (self=[self initWithURLStr:str DataDic:dic]) {
        
    }
    return self;

}
-(instancetype)initWithURLStr:(NSString *)str Post:(BOOL)isPost DataDic:(NSDictionary *)dic Delegate:(id<HttpDownLoadDelegate>)target
{
    _delegate=target;
    //请求方式
    _isPost=isPost;
    
    if (self=[self initWithURLStr:str DataDic:dic]) {

    }
    return self;
}


-(instancetype)initWithURLStr:(NSString*)str DataDic:(NSDictionary*)dic{
    if (self=[super init]) {
        if (str==nil) {
            return self;
        }
        _mySession=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

///******我们在学习POST后还需要进行修改******************/

///***********************************************/

        //对中文进行处理
        str=[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        //对请求地址进行拼接MD5加密,首先把字典转换为字符串,在与请求地址进行拼接
        NSString*dataDicStr=nil;
        if (dic) {
             dataDicStr=[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            dataDicStr =[NSString stringWithFormat:@"%@%@",str,dataDicStr];
        }else{
            dataDicStr=str;
        }
       
        
        
        
        //加密出地址  不止用于校验文件使用,当下载完成后写入文件,也需要使用这个地址
       _cacheFileName=[MyMD5 md5:dataDicStr];
        
        //判断文件缓存是否有效
        NSFileManager*manager=[NSFileManager defaultManager];
        if ([manager fileWithPath:_cacheFileName TimeOut:60*60]) {
            //文件可用
            //读取文件
            NSString*path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),_cacheFileName];
            
            NSData*cacheData=[NSData dataWithContentsOfFile:path];
            //进行解析
            [self jsonValue:cacheData];
            //进行数据回调
            if ([_delegate respondsToSelector:@selector(httpDownLoadFinishOrFail:target:)]) {
                [_delegate httpDownLoadFinishOrFail:YES target:self];
            }
            
            //进行block回调
            if (_myBlock) {
                self.myBlock(self,YES);
            }
            
        }else{
            //文件不可用,需要进行网络请求
        //菊花转
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        //开始进行请求
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            
         /****POST请求需要添加的********/
            if (_isPost) {
                //POST
                //请求方式
                [request setHTTPMethod:@"POST"];
                
                //请求的body
                [request setHTTPBody:[dataDicStr dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                //GET
//对数据参数进行拼接
                    if (dic) {
                            //取allkeys
                            NSArray*allKeys=[dic allKeys];
                
                            //拼接参数的规则 第一个参数是? 后面链接是&
                            NSMutableString*tempStr=[NSMutableString stringWithString:@"?"];
                            for (NSString*key in allKeys) {
                                //读取value
                                NSString*value=dic[key];
                                //拼接参数
                                [tempStr appendFormat:@"%@=%@&",key,value];
                            }
                            //?key=value&key1=value1&key2=value2&
                            //最后对字符串进行处理
                            NSString*newStr=[tempStr substringToIndex:tempStr.length-1];
                            
                            str=[NSString stringWithFormat:@"%@%@",str,newStr];
                            
                            
                            
                    }
                
                //对request进行重新指向
                request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:str] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                
            }
           
        NSURLSessionDataTask*task=[_mySession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //回归主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
            
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            //处理解析失败
            if (error) {
                //解析失败
                //respondsToSelector是判断这个方法有没有在那个类中实现
                if ([_delegate respondsToSelector:@selector(httpDownLoadFinishOrFail:target:)]) {
                    [_delegate httpDownLoadFinishOrFail:NO target:self];
                }
                //进行block回调
                if (_myBlock) {
                    self.myBlock(self,NO);
                }
                
                
            }else{
                //进行数据解析
                [self jsonValue:data];
                
                //保存数据
                NSString*path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),_cacheFileName];
                
                [data writeToFile:path atomically:YES];
            
                if ([_delegate respondsToSelector:@selector(httpDownLoadFinishOrFail:target:)]) {
                    [_delegate httpDownLoadFinishOrFail:YES target:self];
                }
                //block数据回调
                if (_myBlock) {
                    self.myBlock(self,YES);
                }
                
            }
                
            });
  
        }];
        
        //开始请求
        [task resume];
        
         }
        
        
        
        
    }
    return self;
}

-(void)jsonValue:(NSData*)data{
    self.data=data;
    //解析data
    id result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        self.dataDic=[NSDictionary dictionaryWithDictionary:result];
    }else{
        if ([result isKindOfClass:[NSArray class]]) {
            self.dataArray=[NSArray arrayWithArray:result];
        }else{
            //不是字典,也不是数组,就是图片
            self.dataImage=[UIImage imageWithData:data];
            
        }
        
    }


//    NSLog(@"%ld",[self.dataDic[@"tngou"] count]);


}





@end
