//
//  UMComUserInfoBar.h
//  UMCommunity
//
//  Created by umeng on 1/21/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComImageView.h"

@interface UMComUserInfoBar : UIView

@property (weak, nonatomic) IBOutlet UMComImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *follower;
@property (weak, nonatomic) IBOutlet UILabel *folowing;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *loginTip;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryView;

- (void)refresh;

@end
