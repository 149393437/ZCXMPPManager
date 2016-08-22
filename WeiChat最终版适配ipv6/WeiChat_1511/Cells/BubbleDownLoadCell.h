//
//  BubbleDownLoadCell.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/1.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleDownLoadCell : UITableViewCell
{
    //左边
    UIButton*leftButton;
    
    //右边
    UIButton*rightButton;
    
    UIImageView*selectImageView;
    

}
@property(nonatomic)BOOL isFont;
@property(nonatomic,assign)NSMutableArray*dataArray;
//下载气泡
-(void)configWithArray:(NSMutableArray*)array;
//下载字体
-(void)configFontWithArray:(NSMutableArray*)array;

@end
