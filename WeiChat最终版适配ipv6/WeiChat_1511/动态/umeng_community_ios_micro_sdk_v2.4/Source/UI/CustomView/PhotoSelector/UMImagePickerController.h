//
//  UMImagePickerController.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^UMImagePickerFinishHandle)(BOOL isCanceled,NSArray *assets);

@interface UMImagePickerController : UITableViewController
@property (nonatomic, copy) UMImagePickerFinishHandle finishHandle;

@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

+ (BOOL)isAccessible;
@end
