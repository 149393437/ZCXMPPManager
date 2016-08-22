//
//  UMComShowToast.h
//  UMCommunity
//
//  Created by Gavin Ye on 1/21/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComLoginManager.h"
#import "UMComErrorCode.h"

@interface UMComShowToast : NSObject


+ (void)showFetchResultTipWithError:(NSError *)error;

+ (void)createFeedSuccess;

+ (void)showNotInstall;

+ (void)showNoMore;

+ (void)spamSuccess:(NSError *)error;

+ (void)spamComment:(NSError *)error;

+ (void)spamUser:(NSError *)error;

+ (void)commentMoreWord;

+ (void)fetchFailWithNoticeMessage:(NSString *)message;

+ (void)notSupportPlatform;

+ (void)saveIamgeResultNotice:(NSError *)error;

+ (void)favouriteFeedFail:(NSError *)error isFavourite:(BOOL)isFavourite;

+ (void)focuseUserSuccess:(NSError *)error focused:(BOOL)focused;

+ (void)focusTopicFail:(NSError *)error focused:(BOOL)focused;



//+ (void)loginFail:(NSError *)error;

//+ (void)createCommentFail:(NSError *)error;

//+ (void)createFeedFail:(NSError *)error;

//+ (void)fetchFeedFail:(NSError *)error;

//+ (void)createLikeFail:(NSError *)error;

//+ (void)deleteLikeFail:(NSError *)error;

//+ (void)fetchMoreFeedFail:(NSError *)error;



//+ (void)fetchTopcsFail:(NSError *)error;

//+ (void)fetchLocationsFail:(NSError *)error;

//+ (void)fetchFriendsFail:(NSError *)error;


//+ (void)focusUserFail:(NSError *)error;

//+ (void)fetchRecommendUserFail:(NSError *)error;

//+ (void)fetchUserFail:(NSError *)error;

//+ (void)deletedFail:(NSError *)error;




@end
