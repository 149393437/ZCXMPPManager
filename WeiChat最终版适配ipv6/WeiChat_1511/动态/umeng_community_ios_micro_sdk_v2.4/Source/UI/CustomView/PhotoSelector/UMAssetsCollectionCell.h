//
//  UMAssetsCollectionCell.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMAssetsCollectionGrid.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface UMAssetsCollectionCell : UITableViewCell
@property (nonatomic,strong) NSArray *assets;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

- (void)setAssets:(NSArray *)assets
        rowNumber:(NSUInteger)index
           height:(NSUInteger)height
        selection:(NSMutableDictionary *)selection
            range:(NSRange)range;

- (void)setAssets:(NSArray *)assets
        rowNumber:(NSUInteger)index
           height:(NSUInteger)height
        selection:(NSMutableDictionary *)selection
            range:(NSRange)range selectionArray:(NSMutableArray *)selactionArray;
@end
