//
//  RootViewController.h
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
    ZCXMPPManager*manager;
    UIImageView*imageView;
}
@property(nonatomic,copy)NSString*imagePath;
-(UIImage*)imageNameStringToImage:(NSString*)imageName;

//当主题变化时候,重写子类
-(void)themeClick;

-(void)backClick;

@end
