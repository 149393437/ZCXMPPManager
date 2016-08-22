//
//  UMComHotFeedMenuViewController.h
//  UMCommunity
//
//  Created by umeng on 16/1/20.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComTopic;
@interface UMComHotFeedMenuViewController : UIViewController

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UMComTopic *topic;


- (instancetype)initWithTopic:(UMComTopic *)topic;

- (void)setPage:(NSInteger)page;

@end
