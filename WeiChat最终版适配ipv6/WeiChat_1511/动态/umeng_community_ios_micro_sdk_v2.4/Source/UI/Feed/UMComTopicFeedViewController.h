//
//  UMComOneFeedViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 9/12/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComViewController.h"

@class UMComTopic;
@interface UMComTopicFeedViewController :UMComViewController

@property (nonatomic, strong) UMComTopic *topic;

-(id)initWithTopic:(UMComTopic *)topic;

@end
