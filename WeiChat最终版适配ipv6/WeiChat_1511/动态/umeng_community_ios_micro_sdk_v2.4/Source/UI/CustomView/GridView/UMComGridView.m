//
//  UMComGridView.m
//  UMCommunity
//
//  Created by luyiyuan on 14/8/27.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import "UMComGridView.h"
#import "UMComImageView.h"
#import "math.h"
#import "UMComShowToast.h"
#import "UMUtils.h"
#import "UMComImageUrl.h"
#define HTTP_PREFIX @"http://"
#define IMAGE_CELL_WIDTH 75
#define A_WEEK_SECONDES (60*60*24*7)


static inline CGRect getImageViewRect(NSUInteger index,NSInteger deltaWidth, NSUInteger cellPad)
{
    CGFloat originX = 0;
    if (index%3 != 0) {
        originX = (cellPad+deltaWidth)*(index%3);
    }
    return CGRectMake(originX, (cellPad+deltaWidth)*(index/3), deltaWidth, deltaWidth);
}

static inline CGSize getGridViewSize(NSArray *array,NSUInteger cellPad,CGFloat imageWidth)
{
    CGSize size;
    
    size.width = [array count]/3 > 0 ? (cellPad+imageWidth) * 3 + cellPad : (cellPad+imageWidth)*([array count]%3)+cellPad;
    
    size.height = (cellPad+imageWidth)*(([array count] - 1)/3 + 1) + cellPad;
    
    return size;
}

@interface UMComGridView ()

@property (nonatomic) NSUInteger cellPad;
@property (nonatomic,strong) UIImage *placeholder;
@property (nonatomic,strong) NSArray *imageModels;
@property (nonatomic,strong) NSMutableArray *arrayImageView;
@property (nonatomic,strong) UMComGridViewerController *viewerController;
@property (nonatomic,strong) UIViewController *fatherController;

@property (nonatomic,assign) float imageDeltaWidth;

@end

@implementation UMComGridView

/*
 array 样例：
 
 @[@[@"http://1",@"http://2"],@[],@[]]
 
 */

- (id)initWithArray:(NSArray *)array placeholder:(UIImage *)placeholder cellPad:(NSUInteger)cellPad
{
    self = [super init];
    
    if(self)
    {
        self.arrayImageView = [[NSMutableArray alloc] init];
        self.cellPad = cellPad;
        
        self.placeholder = placeholder;
        
        for(int i = 0; i<9; i++)
        {
            UMComImageView *iv = [[UMComImageView alloc] initWithPlaceholderImage:placeholder];

            [iv setIsAutoStart:NO];
            
            iv.tag = i + 100;
            
            [iv setCacheSecondes:A_WEEK_SECONDES];
                        
            iv.userInteractionEnabled = YES;
            
            [self.arrayImageView addObject:iv];
        }
        
        [self setArray:array];
        
    }
    
    return self;
}

- (void)setImages:(NSArray *)images placeholder:(UIImage *)placeholder cellPad:(NSInteger)cellPad
{
    if (self.arrayImageView == nil) {
        self.arrayImageView = [[NSMutableArray alloc] init];
    }else{
        for (UMComImageView *imageView in self.arrayImageView) {
            [imageView removeFromSuperview];
        }
        [self.arrayImageView removeAllObjects];
    }
    self.cellPad = cellPad;
    self.placeholder = placeholder;
    
    self.imageDeltaWidth = (self.frame.size.width-cellPad*2)/3;
    for(int i = 0; i<9; i++)
    {
        UMComImageView *iv = [[[UMComImageView imageViewClassName] alloc] initWithPlaceholderImage:placeholder];
        [iv setIsAutoStart:NO];
        
        iv.tag = i + 100;
        
        [iv setCacheSecondes:A_WEEK_SECONDES];
        
        [iv setFrame:getImageViewRect(i,self.imageDeltaWidth, cellPad)];
        
        iv.userInteractionEnabled = YES;
        
        [self.arrayImageView addObject:iv];
    }
    
    [self setArray:images];
}

#pragma mark 根据size截取图片中间矩形区域的图片 这里的size是正方形
- (void)setArray:(NSArray *)array
{
    self.imageModels = array;
    if([array count])
    {
        CGSize size = getGridViewSize(array, self.cellPad, self.imageDeltaWidth);
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height)];
        
        int curImageCount = 0;
        
        for (int i = 0;i < array.count;i++)
        {
            UMComImageUrl *imageModel = [array objectAtIndex:i];
            if (curImageCount < self.arrayImageView.count) {
                UMComImageView *iv = self.arrayImageView[curImageCount];
                iv.needCutOff = YES;
                if (iv.superview != self) {
                    [self addSubview:iv];
                }
                [iv setImageURL:imageModel.small_url_string placeHolderImage:self.placeholder];
                curImageCount++;
                //添加触控
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
                [iv addGestureRecognizer:tapGesture];
            }
//            if(imageModel.smallImageUrlString && imageModel.largeImageUrlString)
//            {
//
//
//            }
//            else
//            {
//                UMLog(@"arr doesn't has 2 children![%@]",[imageModel description]);
//            }
        }
        
        for (NSInteger i = array.count; i < 9; i++) {
            UMComImageView *iv = self.arrayImageView[i];
            [iv removeFromSuperview];
        }
    }
    else
    {
        self.frame = CGRectZero;
    }
}

- (void)removeAllSubviews
{
    for(UMComImageView *iv in self.arrayImageView)
    {
        [iv removeFromSuperview];
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tapGesture
{

    NSInteger index = -1;
    
    CGPoint point = [tapGesture locationInView:self];
    
    for(UMComImageView *iv in self.arrayImageView)
    {
        if(CGRectContainsPoint(iv.frame, point))
        {
            index = iv.tag - 100;
            break;
        }
    }
    
    if(index == -1)
    {
        UMLog(@"sorry,you didn't select the imageview");
        return;
    }
    self.viewerController = [[UMComGridViewerController alloc] initWithArray:self.imageModels index:index];
    [self.viewerController setCacheSecondes:A_WEEK_SECONDES];
    
    self.viewerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if (self.TapInImage) {
        self.TapInImage(self.viewerController,self.arrayImageView[index]);
    }
}

- (void)setPresentFatherViewController:(UIViewController *)viewController
{
    self.fatherController = viewController;
}

- (void)setCacheSecondes:(NSTimeInterval)secondes
{
    for(UMComImageView *iv in self.arrayImageView)
    {
        [iv setCacheSecondes:secondes];
    }
}

- (void)startDownload
{
    for(UMComImageView *iv in self.arrayImageView)
    {
        [iv startImageLoad];
    }
}
@end
