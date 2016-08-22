//
//  UMComFriendsTableViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 9/9/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComFriendTableViewController.h"
#import "UMComUser.h"
#import "UMComSession.h"
#import "UMComPullRequest.h"
#import "UMComFriendTableViewCell.h"
#import "UMComShowToast.h"
#import "UIViewController+UMComAddition.h"
#import "UMComImageView.h"
#import "UMComUser+UMComManagedObject.h"

const CGFloat g_Micro_FriendTableView_CellHeight = 66.f;//tableviewCell的高度

//头像的参数
const CGFloat g_Micro_FriendTableView_ProfileImageViewWidth = 38.f;//头像的宽度
const CGFloat g_Micro_FriendTableView_ProfileImageViewHeight = 38.f;//头像的高度
const CGFloat g_Micro_FriendTableView_ProfileImageViewLeftMargin = 10.f;//头像的左边距
const CGFloat g_Micro_FriendTableView_ProfileImageViewTopMargin = 15.f;//头像的上边距

//名字的参数
const CGFloat g_Micro_FriendTableView_ProfileNameTopMargin = 29.f;//名字的上边距
const CGFloat g_Micro_FriendTableView_ProfileNameDefaultHeight = 14.f;//名字的默认高度
const CGFloat g_Micro_FriendTableView_SpaceBetweenNameAndImg = 10.f;//名字和图片的距离

const CGFloat g_Micro_FriendTableView_RightMargin = 10.f;//名字和图片的距离

#define kFetchLimit 20

typedef void(^FriendsDataLoadFinishHandler)(NSArray *data, NSError *error);

@interface UMComFriendTableViewController ()

@property (nonatomic, copy) void (^complectionBlock)(UMComUser *user);

-(void) relayoutCellWithIndexPath:(NSIndexPath *)indexPath cell:(UMComFriendTableViewCell*)cell;

@end

@implementation UMComFriendTableViewController


- (instancetype)initWithUserSelectedComplectionBlock:(void (^)(UMComUser *))block
{
    self = [super init];
    if (self) {
        self.complectionBlock = block;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setTitleViewWithTitle: UMComLocalizedString(@"FriendTitle",@"我的好友")];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];
    
    self.fetchRequest = [[UMComFollowersRequest alloc] initWithUid:[UMComSession sharedInstance].uid count:BatchSize];
    
    [self loadAllData:nil fromServer:nil];
    self.tableView.rowHeight = 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FriendTableViewCell";
    UMComFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UMComUser *follower = [self.dataArray objectAtIndex:indexPath.row];
//    NSString *iconUrl = [follower iconUrlStrWithType:UMComIconSmallType];
//
//    [cell.profileImageView setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:follower.gender.integerValue]];
//    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
//    cell.profileImageView.clipsToBounds = YES;
//
//    [cell.nameLabel setText:follower.name];
    [self relayoutCellWithIndexPath:indexPath cell:cell];
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return g_Micro_FriendTableView_CellHeight;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UMComUser *user = [self.dataArray objectAtIndex:indexPath.row];
    if (self.complectionBlock) {
        self.complectionBlock(user);
    }
//    [self.editViewModel.followers addObject:user];
//    NSString *atFriendStr = @"";
//    if (self.isShowFromAtButton == YES) {
//        atFriendStr = @"@";
//    }
//    [self.editViewModel editContentAppendKvoString:[NSString stringWithFormat:@"%@%@ ",atFriendStr,user.name]];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) relayoutCellWithIndexPath:(NSIndexPath *)indexPath cell:(UMComFriendTableViewCell*)cell;
{
    UMComUser *follower = [self.dataArray objectAtIndex:indexPath.row];
    NSString *iconUrl = [follower iconUrlStrWithType:UMComIconSmallType];
    
    cell.profileImageView.frame = CGRectMake(g_Micro_FriendTableView_ProfileImageViewLeftMargin, g_Micro_FriendTableView_ProfileImageViewTopMargin, g_Micro_FriendTableView_ProfileImageViewWidth, g_Micro_FriendTableView_ProfileImageViewHeight);
    
    [cell.profileImageView setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:follower.gender.integerValue]];
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
    cell.profileImageView.clipsToBounds = YES;
    
    
    CGSize timeStringSize = [follower.name sizeWithFont:UMComFontNotoSansLightWithSafeSize(15)];
    CGFloat nameHeight = 0;
    CGFloat nameWidth = 0;
    //加5个像素为了label上下两边的margin
    if (timeStringSize.height <= g_Micro_FriendTableView_ProfileNameDefaultHeight) {
        nameHeight = g_Micro_FriendTableView_ProfileNameDefaultHeight + 5 ;
    }
    else{
        nameHeight = timeStringSize.height + 5;
    }
    
    nameWidth = cell.contentView.bounds.size.width - g_Micro_FriendTableView_ProfileImageViewWidth - g_Micro_FriendTableView_SpaceBetweenNameAndImg - g_Micro_FriendTableView_RightMargin;
    
    cell.frame = CGRectMake(cell.profileImageView.frame.origin.x + cell.profileImageView.frame.size.width + g_Micro_FriendTableView_SpaceBetweenNameAndImg , g_Micro_FriendTableView_ProfileNameTopMargin, nameWidth, nameHeight);
    
    cell.nameLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    cell.nameLabel.textColor = UMComColorWithColorValueString(@"#666666");;
    [cell.nameLabel setText:follower.name];
}

@end
