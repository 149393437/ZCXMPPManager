//
//  UMComUserCenterViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 9/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComViewController.h"

@protocol UMComUserOperationFinishDelegate;

@class UMComUser;

@interface UMComUserCenterViewController :UMComViewController

@property (nonatomic, weak) id<UMComUserOperationFinishDelegate> userOperationFinishDelegate;

- (instancetype)initWithUser:(UMComUser *)user;

@end
