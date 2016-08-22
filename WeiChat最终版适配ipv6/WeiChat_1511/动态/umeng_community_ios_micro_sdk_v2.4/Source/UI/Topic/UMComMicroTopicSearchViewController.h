//
//  UMComMicroTopicSearchViewController.h
//  UMCommunity
//
//  Created by umeng on 16/2/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTopicsTableViewController.h"

@interface UMComMicroTopicSearchViewController : UMComTopicsTableViewController

@property (nonatomic, copy) void (^dismissBlock)();

@end
