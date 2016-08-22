//
//  HorizontalTableView.h
//  TableViewHorizontalScroll
//
//  Created by Umeng on 14-6-16.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComImageView, UMComUser, UMComPullRequest;

@interface UMComHorizontalTableView : UITableView

@property (nonatomic, strong) NSArray *userList;

@property (nonatomic, strong) UMComPullRequest *userFetchRequest;

@property (nonatomic, copy) void (^didSelectedUser)(UMComUser *user);

- (void)searchUsersWithKeyWord:(NSString *)keyWord;
@end




//  HorizontalTableViewCell.h
//  TableViewHengGun
//
//  Created by Umeng on 14-6-16.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//
@interface HorizontalTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UMComImageView *userImageView;

@property (nonatomic, strong) UMComUser *user;

- (void)setUser:(UMComUser *)user;

@end


