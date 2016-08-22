//
//  UMComAddedImageView.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/11.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComAddedImageView.h"
#import "UMComActionPickerAddView.h"
#import "UMComAddedImageCellView.h"
#import "UMUtils.h"
#import "UMComActionDeleteView.h"


NSInteger const g_AddedImageView_MaxLine = 3;//显示图片最大的行数
NSInteger const g_AddedImageView_MinLine = 1;//显示图片最小的行数
NSInteger const g_AddedImageView_IMGCountPerLine = 4;//一行图片的个数
NSInteger const g_AddedImageView_LeftMargin = 15;//最左边缘的距离
NSInteger const g_AddedImageView_RightMargin = 15;//最左边缘的距离
NSInteger const g_AddedImageView_TopMargin = 5;//最上边缘的距离
NSInteger const g_AddedImageView_BottomMargin = 5;//最下边缘的距离
NSInteger const g_AddedImageView_VerSpaceBetweenImg = 5;//图片间的垂直间距

@interface UMComAddedImageView()
{
    UMComActionDeleteViewType _deleteViewType;
    
    CGSize _intrinsicSize;
}
@property (nonatomic,strong,readwrite) NSMutableArray *arrayImages;
@property (nonatomic,strong) UMComActionPickerAddView *actionView;
@property (nonatomic, assign) CGFloat imageSpace ;
@property (nonatomic, assign) CGFloat maxTotalCount;


-(void) computeCell:(UIView*)view WithCurIndex:(NSUInteger)curIndex;
@end

@implementation UMComAddedImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.actionView = [[UMComActionPickerAddView alloc] init];
        //添加触控
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [self.actionView addGestureRecognizer:tapGesture];
        _itemSize = CGSizeMake(50.f, 50.f);
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.actionView];
        self.arrayImages = [NSMutableArray array];
        self.maxTotalCount = 9;
    }
    return self;
}

-(void) setIsDashWithBorder:(BOOL)isDashWithBorder
{
    self.actionView.isDashWithBorder = isDashWithBorder;
}
-(BOOL) isDashWithBorder
{
    return self.actionView.isDashWithBorder;
}

-(void) setDeleteViewType:(UMComActionDeleteViewType)deleteViewType
{
    _deleteViewType = deleteViewType;
}

-(UMComActionDeleteViewType) deleteViewType
{
    return _deleteViewType;
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    self.imageSpace  = (self.frame.size.width - itemSize.width*4)/5;

}



- (void)deleteImageAtIndex:(NSInteger)index
{
    
    if(index>=0&&index<[self.arrayImages count])
    {
        UMComAddedImageCellView *iv = self.arrayImages[index];
        [iv removeFromSuperview];
        [self.arrayImages removeObjectAtIndex:index];
        for(NSInteger i = index;i< self.arrayImages.count;i++)
        {
            UMComAddedImageCellView *iv = self.arrayImages[i];
            iv.frame = CGRectMake((i-4*(i/4))*(self.imageSpace +self.itemSize.width)+self.imageSpace , (i/4)*(self.itemSize.height+self.imageSpace )+self.imageSpace /2, self.itemSize.width, self.itemSize.height);
            iv.curIndex = i;
        }
        [self reloadData];
        if (self.imagesDeleteFinish) {
            self.imagesDeleteFinish(index);
        }
    }    
}


- (void)tapImageView:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.view == self.actionView) {
        if(self.pickerAction)
        {
            self.pickerAction();
        }
    }else{
        if (_actionWithTapImages) {
            _actionWithTapImages();
        }
    }

}


- (void)doOldAddImages:(NSArray *)images
{
    CGFloat imageSpace  = (int)(self.frame.size.width - self.itemSize.width*4)/5;
    self.imageSpace  = imageSpace ;
    if (!self.isAddImgViewShow) {
        if (images.count == 0) {
            return;
        }
    }
    for(UIImage *image in images)
    {
        if (self.arrayImages.count >= self.maxTotalCount) {
            break;
        }
        UMComAddedImageCellView *iv = [[UMComAddedImageCellView alloc] initWithImage:image];
        iv.deleteViewType = self.deleteViewType;
        NSInteger index = self.arrayImages.count;
        iv.frame = CGRectMake((index-4*(index/4))*(imageSpace +self.itemSize.width)+imageSpace , (index/4)*(self.itemSize.height+imageSpace )+imageSpace /2, self.itemSize.width, self.itemSize.height);
        iv.curIndex = index;
        [iv setHandle:^(UMComAddedImageCellView *iv){
            [self deleteImageAtIndex:iv.curIndex];
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [iv addGestureRecognizer:tap];
        [self addSubview:iv];
        [self.arrayImages addObject:iv];
    }
    [self reloadData];
}




- (void)reloadData
{
    if(self.arrayImages.count<=self.maxTotalCount && self.arrayImages.count > 0)
    {
        NSInteger index = self.arrayImages.count;
        [self.actionView setFrame:CGRectMake((index-4*(index/4))*(self.imageSpace +self.itemSize.width)+self.imageSpace , (index/4)*(self.itemSize.height+self.imageSpace )+self.imageSpace /2, self.itemSize.width, self.itemSize.height)];
        ;
        [self.actionView setNeedsDisplay];
        if (!self.isAddImgViewShow) {
          self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.itemSize.height + self.imageSpace /2);
        }
        self.contentSize = CGSizeMake(self.frame.size.width, (self.imageSpace +self.itemSize.height)*(self.arrayImages.count/4 + 1));
        if (self.arrayImages.count == self.maxTotalCount) {
            self.actionView.hidden = YES;
        }else{
            self.actionView.hidden = NO;
        }
    }else if (self.arrayImages.count == 0){
        if(self.isAddImgViewShow)
        {
            self.actionView.hidden = NO;
            int offsetx = (self.bounds.size.height - self.itemSize.height)/2;
            self.actionView.frame = CGRectMake(15, offsetx, self.itemSize.width, self.itemSize.height);
        }
        else
        {
            self.actionView.hidden = YES;
        }
    }else{
        self.actionView.hidden = YES;
    }
    if (self.arrayImages.count > self.maxTotalCount) {
        NSArray *temArray = [self.arrayImages subarrayWithRange:NSMakeRange(0, self.maxTotalCount)];
        [self.arrayImages removeAllObjects];
        [self.arrayImages addObjectsFromArray:temArray];
    }
    if (self.imagesChangeFinish) {
        self.imagesChangeFinish();
    }
}

/*****************************************************/
//新论坛的方法
/*****************************************************/
- (void)addImages:(NSArray *)images
{
    if (!self.isUsingForumMethod) {
       
        [self doOldAddImages:images];
    }
    else
    {
        //[self doNewAddImages:images];
        [self doNewAddImagesForForum:images];
    }
}

/**
 *  计算每个cell的位置
 *
 *  @param curIndex      当前的数组中的位置
 *  @param showCellCount 当前要显示的cell的个数包括（+）
 */
-(void) computeCell:(UIView*)view WithCurIndex:(NSUInteger)curIndex
{
    NSUInteger horSpace = self.imageSpace;
    NSUInteger verSpace = (self.bounds.size.height - self.itemSize.height) /2;

    NSUInteger row =  curIndex / g_AddedImageView_IMGCountPerLine;
    NSUInteger colunm =  curIndex % g_AddedImageView_IMGCountPerLine;
    
    NSUInteger temp_x = colunm * (self.itemSize.width + horSpace) +  g_AddedImageView_LeftMargin;
    NSUInteger temp_y = row    * (self.itemSize.height + verSpace) + g_AddedImageView_TopMargin;
    
    view.frame = CGRectMake(temp_x, temp_y, self.itemSize.width, self.itemSize.height);
}

/**
 *  删除cell的函数
 *
 *  @param index 当前arrayImages的索引
 */
- (void)doNewdeleteImageAtIndex:(NSInteger)index
{
    if(index>=0&&index<[self.arrayImages count])
    {
        UMComAddedImageCellView *iv = self.arrayImages[index];
        [iv removeFromSuperview];
        [self.arrayImages removeObjectAtIndex:index];
        for(NSInteger i = index;i< self.arrayImages.count;i++)
        {
            UMComAddedImageCellView *iv = self.arrayImages[i];
            iv.curIndex = i;
        }
        [self doNewReloadData];
        if (self.imagesDeleteFinish) {
            self.imagesDeleteFinish(index);
        }
    }
}

/**
 *  增加数据
 *
 *  @param images 图片数组
 */
-(void) doNewAddImages:(NSArray *)images
{
    if (self.itemSize.height <= 0 || self.itemSize.width <= 0) {
        return;
    }
    
    CGFloat imageSpace  = (int)(self.frame.size.width - self.itemSize.width*4)/5;
    self.imageSpace  = imageSpace;
    
    if (!self.isAddImgViewShow) {
        if (images.count == 0) {
            return;
        }
    }
    
    NSInteger index = [self.arrayImages count];
    for(UIImage *image in images)
    {
        if (self.arrayImages.count >= self.maxTotalCount) {
            break;
        }
        
        UMComAddedImageCellView *iv = [[UMComAddedImageCellView alloc] initWithImage:image];
        iv.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        iv.deleteViewType = self.deleteViewType;
        iv.curIndex = index;
        
        [iv setHandle:^(UMComAddedImageCellView *iv){
            [self doNewdeleteImageAtIndex:iv.curIndex];
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [iv addGestureRecognizer:tap];
        [self addSubview:iv];
        [self.arrayImages addObject:iv];
        
        index++;
    }
    
    [self doNewReloadData];
    
}

- (void)doNewReloadData
{
    NSInteger compare_zero = 0.f;
    NSInteger imageMaxIndex = 0;
    UIView* lastView = self.actionView;
    if(self.arrayImages.count<= self.maxTotalCount && self.arrayImages.count > compare_zero)
    {
        for(UMComAddedImageCellView *iv in self.arrayImages)
        {
            [self computeCell:iv WithCurIndex:iv.curIndex];
            imageMaxIndex = iv.curIndex;
            lastView = iv;
        }
        
        //判断+是否隐藏或者显示的位置
        if (imageMaxIndex < self.maxTotalCount -1 ) {
            self.actionView.hidden = NO;
            lastView = self.actionView;
            imageMaxIndex = imageMaxIndex + 1;
            [self computeCell:lastView WithCurIndex:imageMaxIndex];
        }
        else{
            self.actionView.hidden = YES;
            imageMaxIndex = imageMaxIndex;
        }
    }
    else if(self.arrayImages.count == compare_zero){

        if(self.isAddImgViewShow)
        {
            //method 1
            //        self.actionView.hidden = NO;
            //        lastView = self.actionView;
            //        imageMaxIndex = 0;
            //        [self computeCell:lastView WithCurIndex:imageMaxIndex];
            
            /**
             *  method2
             */
            self.actionView.hidden = NO;
            int offsetx = (self.bounds.size.height - self.itemSize.height)/2;
            self.actionView.frame = CGRectMake(15, offsetx, self.itemSize.width, self.itemSize.height);
        }
        else
        {
            self.actionView.hidden = YES;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        }

    }
    else{
        self.actionView.hidden = YES;
    }
    
    //设置scrollview的contentsize
    self.contentSize =  CGSizeMake(self.bounds.size.width, lastView.frame.origin.y +  lastView.frame.size.height + self.imageSpace);
    //NSLog(@"self.contentSize = %f",self.contentSize.height);
    
    //回调
    if (self.imagesChangeFinish) {
        self.imagesChangeFinish();
    }
    
}


/*****************************************************/
//新论坛的方法2.4版本
/*****************************************************/

/**
 *  设置预定义的最大高度
 *
 *  @return 最大高度
 */
-(NSInteger)preMaxHeightForForum
{
    NSInteger preMaxHeight = g_AddedImageView_TopMargin + g_AddedImageView_BottomMargin +
    g_AddedImageView_MaxLine * self.itemSize.height +  (g_AddedImageView_MaxLine -1) * g_AddedImageView_VerSpaceBetweenImg;
    return preMaxHeight;
}


/**
 *  设置预定义的最小高度
 *
 *  @return 最小高度
 */
-(NSInteger)preMinHeightForForum
{
    NSInteger preMinHeight = g_AddedImageView_TopMargin + g_AddedImageView_BottomMargin +
    g_AddedImageView_MinLine * self.itemSize.height +  (g_AddedImageView_MinLine -1) * g_AddedImageView_VerSpaceBetweenImg;
    return preMinHeight;
}

/**
 *  计算每个cell的位置
 *
 *  @param curIndex      当前的数组中的位置
 *  @param showCellCount 当前要显示的cell的个数包括（+）
 */
-(void) computeCellForForum:(UIView*)view WithCurIndex:(NSUInteger)curIndex
{
    NSUInteger horSpace = self.imageSpace;
    NSUInteger verSpace = g_AddedImageView_VerSpaceBetweenImg;
    
    NSUInteger row =  curIndex / 4;
    NSUInteger colunm =  curIndex % 4;
    
    NSUInteger temp_x = colunm * (self.itemSize.width + horSpace) +  g_AddedImageView_LeftMargin;
    NSUInteger temp_y = row    * (self.itemSize.height + verSpace) + g_AddedImageView_TopMargin;
    
    view.frame = CGRectMake(temp_x, temp_y, self.itemSize.width, self.itemSize.height);
}

-(void) notifyImagesChangeFinishForForum
{
    //回调
    if (self.imagesChangeFinish) {
        self.imagesChangeFinish();
    }
}

- (void)doNewReloadDataForForum
{
    NSInteger compare_zero = 0.f;
    NSInteger imageMaxIndex = 0;
    UIView* firstView = self.actionView;
    UIView* lastView = firstView;
    if(self.arrayImages.count <= self.maxTotalCount && self.arrayImages.count > compare_zero)
    {
        for(UMComAddedImageCellView *iv in self.arrayImages)
        {
            NSInteger curIndex = iv.curIndex;
            if (self.arrayImages.count == self.maxTotalCount) {
                firstView.hidden = YES;
            }
            else
            {
                firstView.hidden = NO;
                curIndex += 1;
            }
            imageMaxIndex = curIndex;
            lastView = iv;
            [self computeCellForForum:iv WithCurIndex:curIndex];
            
//            NSLog(@"iv%ld:[%f,%f:%f,%f]",(long)iv.curIndex,iv.frame.origin.x,
//                  iv.frame.origin.y,iv.frame.size.width,iv.frame.size.height);
        }
        [self computeCell:firstView WithCurIndex:0];
    }
    else if(self.arrayImages.count == compare_zero){
        
        if(self.isAddImgViewShow)
        {
            //method 1
            //        self.actionView.hidden = NO;
            //        lastView = self.actionView;
            //        imageMaxIndex = 0;
            //        [self computeCell:lastView WithCurIndex:imageMaxIndex];
            
            /**
             *  method2
             */
            self.actionView.hidden = NO;
            int offsetx = (self.bounds.size.height - self.itemSize.height)/2;
            self.actionView.frame = CGRectMake(g_AddedImageView_LeftMargin, offsetx, self.itemSize.width, self.itemSize.height);
        }
        else
        {
            self.actionView.hidden = YES;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
        }
        
    }
    else{
        self.actionView.hidden = YES;
    }
    
    //先计算最后一个控件的位置，来确定自己的bound 和 contentsize
    CGRect orgBounds = self.bounds;
    CGRect lastFrame = lastView.frame;
    NSInteger curMaxHeight = lastFrame.origin.y + lastFrame.size.height + g_AddedImageView_BottomMargin;
    NSInteger curContentSizeHeight = curMaxHeight;
    NSInteger curBoundsHeight = curMaxHeight;
    
    //计算最大的高度和最小的高度
    NSInteger preMaxHeight = [self preMaxHeightForForum];
    NSInteger preMinHeight = [self preMinHeightForForum];
    
    //判断当前的高度和预定义的高度，来决定contentsize 和自己本身的高度
    if(curBoundsHeight <=  preMinHeight)
    {
        curBoundsHeight = preMinHeight;
    }
    else if(curBoundsHeight >= preMaxHeight)
    {
        curBoundsHeight = preMaxHeight;
    }
    else{}
    
    if (orgBounds.size.height != curBoundsHeight) {
        orgBounds.size.height = curBoundsHeight;
        self.bounds = orgBounds;
    }
    

    if (_intrinsicSize.height > 0) {
        
        self.bounds = CGRectMake(0, 0, _intrinsicSize.width, _intrinsicSize.height);
    }

    //设置scrollview的contentsize
    self.contentSize =  CGSizeMake(self.bounds.size.width, curContentSizeHeight);
    //NSLog(@"self.contentSize = %f",self.contentSize.height);
    
//    //回调
//    if (self.imagesChangeFinish) {
//        self.imagesChangeFinish();
//    }
}

/**
 *  删除cell的函数
 *
 *  @param index 当前arrayImages的索引
 */
- (void)doNewdeleteImageAtIndexForForum:(NSInteger)index
{
    if(index>=0&&index<[self.arrayImages count])
    {
        UMComAddedImageCellView *iv = self.arrayImages[index];
        [iv removeFromSuperview];
        [self.arrayImages removeObjectAtIndex:index];
        for(NSInteger i = index;i< self.arrayImages.count;i++)
        {
            UMComAddedImageCellView *iv = self.arrayImages[i];
            iv.curIndex = i;
        }
        [self doNewReloadDataForForum];
        if (self.imagesDeleteFinish) {
            self.imagesDeleteFinish(index);
        }
        [self notifyImagesChangeFinishForForum];
    }
}
/**
 *  2.4版本的新方法
 *
 *  @param images 增加的图片
 */
-(void) doNewAddImagesForForum:(NSArray *)images
{
    if (self.itemSize.height <= 0 || self.itemSize.width <= 0) {
        return;
    }
    
    
    CGFloat imageSpace =(int) (self.frame.size.width - g_AddedImageView_LeftMargin -g_AddedImageView_RightMargin -self.itemSize.width*(g_AddedImageView_IMGCountPerLine)) / (g_AddedImageView_IMGCountPerLine - 1);
    
    self.imageSpace  = imageSpace;
    
    if (!self.isAddImgViewShow) {
        if (images.count == 0) {
            return;
        }
    }
    
    NSInteger index = [self.arrayImages count];
    for(UIImage *image in images)
    {
        if (self.arrayImages.count >= self.maxTotalCount) {
            break;
        }
        
        UMComAddedImageCellView *iv = [[UMComAddedImageCellView alloc] initWithImage:image];
        iv.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        iv.deleteViewType = self.deleteViewType;
        iv.curIndex = index;
        
        [iv setHandle:^(UMComAddedImageCellView *iv){
            [self doNewdeleteImageAtIndexForForum:iv.curIndex];
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [iv addGestureRecognizer:tap];
        [self addSubview:iv];
        [self.arrayImages addObject:iv];
        
        index++;
    }
    
    [self doNewReloadDataForForum];
    [self notifyImagesChangeFinishForForum];
    
}

-(void) setIntrinsicSize:(CGSize)IntrinsicSize
{
    _intrinsicSize = IntrinsicSize;
    [self doNewReloadDataForForum];
    
}


@end
