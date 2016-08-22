//
//  UMComGridTableViewCell.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/16.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComGridTableViewCellOne;

@interface UMComGridTableViewCell : UITableViewCell

//tools
+ (NSUInteger)getGridTableLineNumber:(NSUInteger)allCount countOfOneLine:(NSUInteger)countOfOneLine;
+ (NSRange)getGridTableRangeForIndex:(NSUInteger)index allCount:(NSUInteger)allCount countOfOneLine:(NSUInteger)countOfOneLine;


//@required
+ (CGFloat)staticHeight;
//@end

+ (NSUInteger)countOfOneLine;

- (void)registerCellClasser:(Class)cellClasser CellOneViewClasser:(Class)cellOneClasser;
- (void)reloadWithDataArray:(NSArray *)dataArray;
- (void)handleTap:(id)dataOne;
@end
