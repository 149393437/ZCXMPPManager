//
//  UMComLoginViewController.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComUserAccount;

@interface UMComLoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *sinaLoginButton;
@property (nonatomic, weak) IBOutlet UIButton *qqLoginButton;
@property (nonatomic, weak) IBOutlet UIButton *wechatLoginButton;

@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@end
