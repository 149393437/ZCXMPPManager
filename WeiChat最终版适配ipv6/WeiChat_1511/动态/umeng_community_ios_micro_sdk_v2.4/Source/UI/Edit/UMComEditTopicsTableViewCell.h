//
//  UMComEditTopicsTableViewCell.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/23.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComTopic;

@interface UMComEditTopicsTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *labelName;
@property (nonatomic,strong) IBOutlet UILabel *labelDesc;

- (void)setWithTopic:(UMComTopic *)topic;

@end
