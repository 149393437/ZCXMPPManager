//
//  UMComFriendsTableViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 9/9/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComRequestTableViewController.h"

@class UMComUser;
@interface UMComFriendTableViewController : UMComRequestTableViewController

@property (nonatomic, assign) BOOL isShowFromAtButton;

-(id)initWithUserSelectedComplectionBlock:(void (^)(UMComUser *user))block;


@end
