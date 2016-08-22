//
//  UMComSearchViewController.h
//  UMCommunity
//
//  Created by umeng on 15-4-22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComFeedTableViewController.h"

@interface UMComSearchViewController : UMComFeedTableViewController

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, copy) void (^dismissBlock)();

@end
