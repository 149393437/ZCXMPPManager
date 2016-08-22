//
//  UMComReplyEditViewController.h
//  UMCommunity
//
//  Created by 张军华 on 16/2/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComPostReplyEditView.h"

@interface UMComReplyEditViewController : UIViewController

@property(nonatomic,readwrite,copy)UMComPostReplyCommitBlock commitBlock;
@property(nonatomic,readwrite,copy)UMComPostReplyCancelBlock cancelBlock;
@property (nonatomic, readwrite,copy)UMComPostReplyCommitGetImageBlock getImageBlock;

//回复评论者的名字
@property(nonatomic,readwrite,strong)NSString* commentcreator;

@end
