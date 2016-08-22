//
//  UMComLocationTableViewCell.h
//  UMCommunity
//
//  Created by Gavin Ye on 12/18/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LocationCellHeight 60;

@class UMComLocationModel;

@interface UMComLocationTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *locationName;

@property (nonatomic, weak) IBOutlet UILabel *locationDetail;


- (void)reloadFromLocationModel:(UMComLocationModel *)locationModel;

@end
