//
//  UMBaseNetwork.h
//  UMCommunity
//
//  Created by luyiyuan on 14/8/27.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UMComHttpMethodType)
{
    UMComHttpMethodTypeGet,
    UMComHttpMethodTypePut,
    UMComHttpMethodTypePost,
    UMComHttpMethodTypeMultipartPost,
    UMComHttpMethodTypeMultipartPut,
    UMComHttpMethodTypeDelete
};

@interface UMBaseNetwork : NSObject

//make request
+ (NSMutableURLRequest *)makeRequestWithMethod:(UMComHttpMethodType)method
                                          path:(NSString *)path
                                pathParameters:(NSDictionary *)pathParameters
                                bodyParameters:(NSDictionary *)bodyParameters
                                       headers:(NSDictionary *)headers;
@end
