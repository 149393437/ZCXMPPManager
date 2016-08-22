//
//  CategroyViewController.h
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol categroyDelegate <NSObject>

-(void)categroyIDToRootViewController:(NSString*)cateID;

@end
@interface CategroyViewController : UIViewController
//传递categoryID的block 声明
@property(nonatomic,copy)void(^myBlock)(NSString*);

//遵循协议的指针
@property(nonatomic,assign)id<categroyDelegate>delegate;


@end
