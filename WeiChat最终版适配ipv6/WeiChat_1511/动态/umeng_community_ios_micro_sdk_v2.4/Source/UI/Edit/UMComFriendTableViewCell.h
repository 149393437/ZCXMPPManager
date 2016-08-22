//
//  UMComFriendTableViewCell.h
//  UMCommunity
//
//  Created by Gavin Ye on 12/18/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComImageView;

@interface UMComFriendTableViewCell : UITableViewCell

@property (nonatomic, strong) UMComImageView * profileImageView;

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;


@end
