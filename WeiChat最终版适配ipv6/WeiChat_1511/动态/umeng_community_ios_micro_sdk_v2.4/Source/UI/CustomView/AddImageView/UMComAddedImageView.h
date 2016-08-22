//
//  UMComAddedImageView.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/11.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComActionDeleteView.h"

typedef void (^PickerHandleAction)(void);

@interface UMComAddedImageView : UIScrollView
@property (nonatomic,copy) PickerHandleAction pickerAction;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic,strong,readonly) NSMutableArray *arrayImages;
@property (nonatomic,copy) void (^imagesChangeFinish)(void);
@property (nonatomic,copy) void (^imagesDeleteFinish)(NSInteger index);
@property (nonatomic,copy) void (^actionWithTapImages)(void);
@property (nonatomic,assign,readonly) CGFloat imageSpace;
@property (nonatomic,readwrite,assign) BOOL isAddImgViewShow;//首次判断当前的+的是否显示
@property (nonatomic,readwrite,assign)BOOL isDashWithBorder;//判断边框是否为虚线
@property (nonatomic,readwrite,assign)UMComActionDeleteViewType deleteViewType;//设置删除的类型
@property (nonatomic,readwrite,assign) BOOL isUsingForumMethod;//论坛的方法的显示方式和旧版本的显示不一样
- (void)addImages:(NSArray *)images;

-(void) setIntrinsicSize:(CGSize)size;

@end
