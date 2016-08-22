//
//  ThemeCell.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/9.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeCell : UITableViewCell
{
    UIImageView*selectImageView;
}

@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic)BOOL isBgViewCell;
-(void)configWithArray:(NSArray*)array;
//聊天背景
-(void)configChatBgViewWithArray:(NSArray*)array;
@end
