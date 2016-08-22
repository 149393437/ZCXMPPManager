//
//  UMComEditTopicsViewController.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/22.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComRequestTableViewController.h"


@class UMComTopic;

@interface UMComEditTopicsViewController : UMComRequestTableViewController


-(id)initWithTopicSelectedComplectionBlock:(void(^)(UMComTopic *topic))block;

@end
