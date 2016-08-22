//
//  UMAssetsCollectionCell.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMAssetsCollectionCell.h"
#import "UMAssetsCollectionGrid.h"
#import "UMComTools.h"

#define kPaddingX 5 // 左边距
#define kPaddingY 5 // 上边距
#define kSpaceX   5 // grid之间的水平边距
#define kSpaceY   5 // grid之间的上下边距

#define kTagPad  99

#define NUMBER_FOR_INDEX(x) [NSNumber numberWithInt:x]

static inline NSInteger tagToIndex(NSRange range,NSInteger tag)
{
    return range.location + tag - kTagPad;
}


@interface UMAssetsCollectionCell()

@property (nonatomic,strong) NSMutableArray  *gridViews;
@property (nonatomic,strong) NSMutableDictionary *assetsSelection;
@property (nonatomic,strong) NSMutableArray *assetsSelectionArr;//选择的图片
@property (nonatomic) NSRange range;
@end

@implementation UMAssetsCollectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.gridViews = [[NSMutableArray alloc]init];
        
        self.assetsSelectionArr = [NSMutableArray arrayWithCapacity:1];
        
        
    }
    return self;
}

- (void)setAssets:(NSArray *)assets
        rowNumber:(NSUInteger)index
           height:(NSUInteger)height
        selection:(NSMutableDictionary *)selection
            range:(NSRange)range
{
    self.assets = assets;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
    self.assetsSelection = selection;
    self.range = range;
    
    [self addGridViewsRowNumber:index
                      rowHeight:height
                      selection:selection
                          range:range];
}


- (void)setAssets:(NSArray *)assets
        rowNumber:(NSUInteger)index
           height:(NSUInteger)height
        selection:(NSMutableDictionary *)selection
            range:(NSRange)range
   selectionArray:(NSMutableArray *)selectionArray
{
    self.assets = assets;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
    self.assetsSelection = selection;
    self.range = range;
    self.assetsSelectionArr = selectionArray;
    [self addGridViewsRowNumber:index
                      rowHeight:height
                      selection:selection
                          range:range];
}


- (void)addGridViewsRowNumber:(NSUInteger)index
              rowHeight:(NSUInteger)rowHeight
           selection:(NSMutableDictionary *)selection
               range:(NSRange)range
{
    float width     = self.bounds.size.width  - 2*kPaddingX;
    float height    = rowHeight - kSpaceY;
    float fitWidth  = (width - kSpaceX*(4-1))/4;
    float fitHeight = (index == 0 ? height - kSpaceY : height);
    
    float y = (index == 0 ? kSpaceY : 0);
    
    @autoreleasepool{
        
        for(int i=0;i<[self.assets count];i++)
        {
            UMAssetsCollectionGrid *grid =(UMAssetsCollectionGrid *)[self viewWithTag:i+kTagPad];
            
            CGRect frame = CGRectMake(kPaddingX+(i%(int)[self.assets count])*(fitWidth+kSpaceX),y, fitWidth, fitHeight);
            
            if(grid == nil)
            {
                grid =[[UMAssetsCollectionGrid alloc] initWithFrame:frame];
                
                [grid setAsset:self.assets[i]];
                [grid setTag:i+kTagPad];
                [self addSubview:grid];
                
                // 保存grid
                [_gridViews addObject:grid];
                
                // 给Grid添加单击手势
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
                tapGes.numberOfTapsRequired = 1;
                [grid addGestureRecognizer:tapGes];
            }
            else
            {
                NSNumber *number = [NSNumber numberWithInteger:tagToIndex(self.range,grid.tag)];
                
                if([self.assetsSelection objectForKey:number])
                {
                    [grid setIsSelected:YES];
                }
                else
                {
                    [grid setIsSelected:NO];
                }
                
                [grid setFrame:frame];
                [grid setAsset:self.assets[i]];
            }
            
        }
        
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGes
{
    
    UMAssetsCollectionGrid *grid =(UMAssetsCollectionGrid *)[self viewWithTag:tapGes.view.tag];
    
    NSNumber *number = [NSNumber numberWithInteger:tagToIndex(self.range,grid.tag)];
    
    if ([self.assetsSelectionArr containsObject:number]) {
        [self.assetsSelectionArr removeObject:number];
    }
    if([self.assetsSelection objectForKey:number])
    {
        [self.assetsSelection removeObjectForKey:number];
    }
    else
    {
        if([self.assetsSelection count]>=self.maximumNumberOfSelection)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Warning", @"警告") message:[NSString stringWithFormat:UMComLocalizedString(@"Selected_Max_Pics", @"当前最多选择%d张图片"),self.maximumNumberOfSelection] delegate:self cancelButtonTitle:UMComLocalizedString(@"OK", @"好的") otherButtonTitles:nil];
            
            [alert show];
            return;
        }
        [self.assetsSelectionArr addObject:number];
        [self.assetsSelection setObject:number forKey:number];
    }
    
    
    [grid setIsSelected:!grid.isSelected];
}


@end
