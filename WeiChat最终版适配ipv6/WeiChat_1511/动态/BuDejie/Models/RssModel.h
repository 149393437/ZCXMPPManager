//
//  RssModel.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/1.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssModel : NSObject
@property(nonatomic,copy)NSString*image_list;
@property(nonatomic)NSNumber*is_default;
@property(nonatomic)NSNumber*is_sub;
@property(nonatomic,copy)NSString*sub_number;
@property(nonatomic,copy)NSString*theme_id;
@property(nonatomic,copy)NSString*theme_name;

@end
