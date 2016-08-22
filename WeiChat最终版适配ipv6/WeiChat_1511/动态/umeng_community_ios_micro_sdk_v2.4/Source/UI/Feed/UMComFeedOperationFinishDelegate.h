//
//  UMComFeedOperationFinshDelegate.h
//  UMCommunity
//
//  Created by umeng on 16/1/13.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMComFeed, UMComComment;

@protocol UMComFeedOperationFinishDelegate <NSObject>

@optional;
- (void)reloadDataWhenFeedOperationFinish:(UMComFeed *)feed;

- (void)createFeedSucceed:(UMComFeed *)feed;

- (void)deleteFeedFinish:(UMComFeed *)feed;
//
//- (void)deleteFeedCommentFinish:(UMComComment *)comment feed:(UMComFeed *)feed;
//
//- (void)createFeedCommentSucceed:(UMComComment *)comment feed:(UMComFeed *)feed;
//
//
//- (void)likeOrDisLikeFeedFinish:(UMComFeed *)feed;
//
//- (void)favourateOrDisFavourateFeed:(UMComFeed *)feed;

@end
