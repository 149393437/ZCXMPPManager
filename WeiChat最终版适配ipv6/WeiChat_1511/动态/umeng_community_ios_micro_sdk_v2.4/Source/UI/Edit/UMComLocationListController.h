//
//  UMComViewController.h
//  UMCommunity
//
//  Created by umeng on 15/8/7.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UMComRequestTableViewController.h"

@class UMComLocationModel;

@interface UMComLocationListController : UMComRequestTableViewController

-(id)initWithLocationSelectedComplectionBlock:(void (^)(UMComLocationModel *locationModel))block;

@end
