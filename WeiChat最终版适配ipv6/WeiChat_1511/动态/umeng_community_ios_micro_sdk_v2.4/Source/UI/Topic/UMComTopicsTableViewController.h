//
//  UMComTopicsTableViewController.h
//  UMCommunity
//
//  Created by umeng on 15/7/15.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComRequestTableViewController.h"

@class UMComPullRequest, UMComTopic;

@interface UMComTopicsTableViewController : UMComRequestTableViewController

@property (nonatomic, copy) void (^completion)(UIViewController *viewController);

@property (nonatomic, assign) BOOL isShowNextButton;

- (instancetype)initWithCompletion:(void (^)(UIViewController *viewController))completion;

- (void)insertTopicToTableView:(UMComTopic *)topic;

- (void)deleteTopicFromTableView:(UMComTopic *)topic;

@end
