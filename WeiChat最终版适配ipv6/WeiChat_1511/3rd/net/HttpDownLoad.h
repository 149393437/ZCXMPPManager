//
//  HttpDownLoad.h
//  Day27_HttpDemo
//
//  Created by zhangcheng on 16/1/27.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//
/*
 下载类设计的需求
 
 第一阶段
 1.满足get请求   post请求,我们后续修改
 2.要求可以上传多个键值对
 3.进行自动解析 解析出数组 字典 data
 4.尽量简化调用方法
 
 第二阶段
 5.本类使用代理反向传值,把数据进行回调传出 后续修改为block
 
 第三阶段
 6.满足缓存需求
   以请求的地址使用MD5加密后作为文件名称,下载data作为保存内容,数据保存在沙盒目录中,之后当在请求数据时候,查看这个文件名是否存在,如果存在就进行读取,不在进行网络请求,但是需要判断这个文件的创建时间是否超时
   图片由于我们使用的是SDwebImage  SDwebImage中自带图片缓存,默认是7day
   使用类别对NSFileManager添加一个方法 传入路径和超时时间,判断文件是否存在
 
 关于加密 MD5也叫做非对称性加密方式,用于校验比较方便,宣称不可逆向破解  其他加密算法  sha-1  sha-256  sha-4 RC4  RSA  有些地址后面加了签名 签名就是把所有参数进行异或 在进行MD5加密 MD5以后加上一个时间戳,在进行MD5加密,在进行RC4加密 ,最终得出一个字符串,这样就防止破解了
 

 第四阶段
 满足POST请求
 
 第五阶段
 使用block进行回调
 
 
 
 */



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HttpDownLoad;
@protocol HttpDownLoadDelegate <NSObject>

-(void)httpDownLoadFinishOrFail:(BOOL)isSuccess target:(HttpDownLoad*)http;

@end

@interface HttpDownLoad : NSObject

@property(nonatomic,strong)NSURLSession*mySession;
//缓存的名称
@property(nonatomic,copy)NSString*cacheFileName;

//请求方式
@property(nonatomic)BOOL isPost;


//解析数据类型
@property(nonatomic,strong)NSData*data;
@property(nonatomic,strong)UIImage*dataImage;
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSDictionary*dataDic;

//代理的接受对象
@property(nonatomic,assign)id<HttpDownLoadDelegate>delegate;

//block的接受对象 myBlock相当于函数名称
@property(nonatomic,copy)void(^myBlock)(HttpDownLoad*,BOOL);


//第一个参数是地址 第二个参数是对应的键值对,也就是这个地址相应的参数
-(instancetype)initWithURLStr:(NSString*)str DataDic:(NSDictionary*)dic;

//适配器的概念 在原有函数基础上进行相应的扩展
-(instancetype)initWithURLStr:(NSString *)str Post:(BOOL)isPost DataDic:(NSDictionary *)dic Delegate:(id <HttpDownLoadDelegate>)target;


//block方法  void(^)(HttpDownLoad*,BOOL)看做是一个类型,相当于NSString*
-(instancetype)initWithURLStr:(NSString *)str Post:(BOOL)isPost DataDic:(NSDictionary *)dic Block:(void(^)(HttpDownLoad*,BOOL))a;







@end








