//
//  CommentModel.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/2.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property(nonatomic,copy)NSString*data_id;
@property(nonatomic,copy)NSString*status;
@property(nonatomic,copy)NSString*id;
@property(nonatomic,copy)NSString*content;
@property(nonatomic,copy)NSString*ctime;
@property(nonatomic,copy)NSString*precid;
@property(nonatomic,copy)NSString*like_count;
@property(nonatomic,copy)NSString*voiceuri;
@property(nonatomic,copy)NSString*voicetime;


@property(nonatomic,strong)NSDictionary*user;
@property(nonatomic,strong)NSArray*precmt;

@end
