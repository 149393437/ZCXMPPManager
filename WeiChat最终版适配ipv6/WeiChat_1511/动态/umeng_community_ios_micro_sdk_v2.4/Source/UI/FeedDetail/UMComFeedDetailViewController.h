//
//  UMComFeedDetailViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/13/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

typedef enum {
    UMComShowFromClickDefault = 0,
    UMComShowFromClickRemoteNotice = 1,
    UMComShowFromClickFeedText = 2,
    UMComShowFromClickComment = 3,
}UMComFeedDetailShowType;

#import "UMComFeedTableViewController.h"

@protocol UMComFeedOperationFinishDelegate;

@class UMComFeed;

@interface UMComFeedDetailViewController : UMComFeedTableViewController

@property (nonatomic, assign) UMComFeedDetailShowType showType;

@property (nonatomic, assign) id <UMComFeedOperationFinishDelegate> feedOperationFinishDelegate;

- (id)initWithFeed:(UMComFeed *)feed;

- (id)initWithFeed:(NSString *)feedId
         viewExtra:(NSDictionary *)viewExtra;

- (id)initWithFeed:(UMComFeed *)feed showFeedDetailShowType:(UMComFeedDetailShowType)type;

@end


