//
//  UMComGridTableViewCell.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/16.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComGridTableViewCell.h"
#import "UMComGridTableViewCellOne.h"

#define kTagPad  99



static inline NSRange getRangeForIndex(NSInteger index,NSInteger allcount,NSInteger statiCountOfLine)
{
    NSRange range;
    
    range.location = allcount - (allcount - index * statiCountOfLine);
    
    if(range.location + statiCountOfLine < allcount)
    {
        range.length = statiCountOfLine;
    }
    else
    {
        range.length = allcount - range.location;
    }
    
    return range;
}


static NSInteger kPadx = 0;
static NSInteger kPadY = 0;

@interface UMComGridTableViewCell ()
@property (nonatomic) Class registerCellClass;
@property (nonatomic) Class registerCellOneClass;
@property (nonatomic,strong) NSArray *dataArray;
//@property (nonatomic,strong) NSMutableArray  *cellViews;
@end
@implementation UMComGridTableViewCell

+ (NSUInteger)getGridTableLineNumber:(NSUInteger)allCount countOfOneLine:(NSUInteger)countOfOneLine{
   
     return allCount % countOfOneLine == 0 ? (allCount/countOfOneLine) : (allCount/countOfOneLine + 1);
    
}
+ (NSRange)getGridTableRangeForIndex:(NSUInteger)index allCount:(NSUInteger)allCount countOfOneLine:(NSUInteger)countOfOneLine{
    return getRangeForIndex(index, allCount,countOfOneLine);
}

+ (CGFloat)staticHeight{
    return 0.0f;
}

+ (NSUInteger)countOfOneLine{
    return 4;
}

- (CGRect)getRectForIndex:(NSUInteger)index
{
    if(!self.registerCellClass||!self.registerCellOneClass){
        return CGRectZero;
    }
    
    if(!kPadx||!kPadY){
        kPadx = (self.bounds.size.width - ([self.registerCellClass countOfOneLine]*[self.registerCellOneClass staticSize].width))/([self.registerCellClass countOfOneLine]+1);
        kPadY = ([self.registerCellClass staticHeight] - [self.registerCellOneClass staticSize].height)/2;
    }

    return CGRectMake(([self.registerCellOneClass staticSize].width+kPadx)*index+kPadx, kPadY,
                      [self.registerCellOneClass staticSize].width, [self.registerCellOneClass staticSize].height);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        self.cellViews = [[NSMutableArray alloc] init];
        
        
    }
    return self;
}

- (void)registerCellClasser:(Class)cellClasser CellOneViewClasser:(Class)cellOneClasser
{
    self.registerCellClass = cellClasser;
    self.registerCellOneClass = cellOneClasser;
}

- (void)reloadWithDataArray:(NSArray *)dataArray
{
    if(!self.registerCellClass||!self.registerCellOneClass){
        return;
    }
    
    if(![dataArray count]){
        return;
    }
//    for (UIView *subView in self.cellViews) {
//        [subView removeFromSuperview];
//    }
    self.dataArray = dataArray;
    
    @autoreleasepool{
        for(int i=0;i<[self.dataArray count];i++)
        {
            UMComGridTableViewCellOne *one =(UMComGridTableViewCellOne *)[self viewWithTag:i+kTagPad];
            
            CGRect frame = [self getRectForIndex:i];
            
            if(one){
                [one setFrame:frame];
                [one setWithData:self.dataArray[i]];
            }else{
                one = [[self.registerCellOneClass alloc] initWithFrame:frame];

                [one setWithData:self.dataArray[i]];
                [one setTag:i+kTagPad];
                [self addSubview:one];
//                [self.cellViews addObject:one];
                
                // 给Grid添加单击手势
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleWithTap:)];
                tapGes.numberOfTapsRequired = 1;
                [one addGestureRecognizer:tapGes];
            }
            

        }
    }
}
- (void)handleWithTap:(UITapGestureRecognizer *)tapGes
{
    NSInteger index = tapGes.view.tag - kTagPad;
    id data = self.dataArray[index];
    [self handleTap:data];
}

- (void)handleTap:(id)dataOne
{    
}
@end
