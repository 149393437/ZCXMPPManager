//
//  UMComEditViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 9/2/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComViewController.h"

@protocol UMComFeedOperationFinishDelegate;

@class UMComImageView, UMComAddedImageView, UMComLocationView, UMComEditTextView,UMComEditForwardView;
@class UMComFeedEntity, UMComFeed, UMComTopic;

@interface UMComEditViewController : UMComViewController

@property (nonatomic, strong) UMComFeedEntity *editFeedEntity;

@property (nonatomic, weak) id <UMComFeedOperationFinishDelegate> feedOperationFinishDelegate;

- (id)initWithForwardFeed:(UMComFeed *)forwardFeed;

- (id)initWithTopic:(UMComTopic *)topic;

- (void)postContent;

@end


