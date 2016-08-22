//
//  AllModel.h
//  BaiSi_1511
//
//  Created by zhangcheng on 16/1/29.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllModel : NSObject
@property(nonatomic)NSNumber*id;
@property(nonatomic)NSNumber*type;
@property(nonatomic,copy)NSString*text;
@property(nonatomic,copy)NSString*user_id;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*screen_name;
@property(nonatomic,copy)NSString*profile_image;
@property(nonatomic,copy)NSString*create_at;
@property(nonatomic,copy)NSString*create_time;
@property(nonatomic,copy)NSString*passtime;
@property(nonatomic,copy)NSString*love;
@property(nonatomic,copy)NSString*hate;
@property(nonatomic,copy)NSString*comment;
@property(nonatomic,copy)NSString*repost;
@property(nonatomic,copy)NSString*bookmark;
@property(nonatomic,copy)NSString*bimageurl;
@property(nonatomic,copy)NSString*voiceuri;
@property(nonatomic,copy)NSString*theme_id;
@property(nonatomic,copy)NSString*voicelength;
@property(nonatomic,copy)NSString*status;
@property(nonatomic,copy)NSString*theme_name;
@property(nonatomic,copy)NSString*theme_type;
@property(nonatomic,copy)NSString*videouri;
@property(nonatomic,copy)NSString*videotime;
@property(nonatomic,copy)NSString*original_pid;
@property(nonatomic,copy)NSString*cache_version;
@property(nonatomic,copy)NSString*cai;
@property(nonatomic,copy)NSString*top_cmt;
@property(nonatomic,copy)NSString*weixin_url;
@property(nonatomic,copy)NSString*themes;
@property(nonatomic,copy)NSString*is_gif;
@property(nonatomic,copy)NSString*width;
@property(nonatomic,copy)NSString*height;
@property(nonatomic,copy)NSString*tag;
@property(nonatomic,copy)NSString*t;
@property(nonatomic,copy)NSString*ding;
@property(nonatomic,copy)NSString*favourite;
@property(nonatomic,copy)NSString*cdn_image;
@property(nonatomic,copy)NSString*image0;
@property(nonatomic,copy)NSString*image1;
@property(nonatomic,copy)NSString*palycount;
@property(nonatomic,copy)NSString*image_small;
@property(nonatomic,copy)NSString*gifFistFrame;
@property(nonatomic,copy)NSNumber*jie_v;
//我们使用的时候看看这个字段的问题
@property(nonatomic,copy)NSString*sina_v;


//记录所占行高
@property(nonatomic)NSInteger rowHeight;


@end
