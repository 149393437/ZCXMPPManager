//
//  UMComUserOperationFinishDelegate.h
//  UMCommunity
//
//  Created by umeng on 16/1/14.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UMComUserOperationFinishDelegate <NSObject>

- (void)reloadDataWhenUserOperationFinish:(UMComUser *)user;

- (void)focusedUserOperationFinish:(UMComUser *)user;


@end