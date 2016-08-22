//
//  UMAssetsCollectionController.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


typedef void (^UMAssetsCollectionFinishHandle)(NSArray *assets);

@class UMImagePickerController;

@interface UMAssetsCollectionController : UITableViewController
//@property (nonatomic,weak) UMImagePickerController *imagePickerController;
@property (nonatomic,strong) ALAssetsGroup *assetsGroup;
@property (nonatomic,copy) UMAssetsCollectionFinishHandle finishHandle;

@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@end
