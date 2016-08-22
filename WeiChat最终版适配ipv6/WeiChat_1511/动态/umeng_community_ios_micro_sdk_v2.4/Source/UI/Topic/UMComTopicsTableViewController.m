//
//  UMComTopicsTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/7/15.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComTopicsTableViewController.h"
#import "UMComTopic.h"
#import "UMComPullRequest.h"
#import "UMComCommonTopicTableViewCell.h"
#import "UMComLoginManager.h"
#import "UMComPushRequest.h"
#import "UMComShowToast.h"
#import "UMComTopicFeedViewController.h"
#import "UMComBarButtonItem.h"
#import "UMComTopicType.h"
#import "UIViewController+UMComAddition.h"

@interface UMComTopicsTableViewController ()

@property (nonatomic, strong) NSArray *originDataArray;

@property (nonatomic, strong) UMComSearchTopicRequest *searchTopicRequest;


@end

@implementation UMComTopicsTableViewController

- (instancetype)initWithCompletion:(void (^)(UIViewController *viewController))completion
{
    self = [super init];
    if (self) {
        self.completion = completion;
        UMComBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithTitle:UMComLocalizedString(@"NextStep",@"下一步") target:self action:@selector(onClickNext)];
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
    return self;
}

-(void) handleFollowTopicNotification:(NSNotification*)notification
{
    
    //    NSLog(@"UMComForumTopicFocusedTableViewController:%@",notification.userInfo);
    
    UMComTopic* topic =  (UMComTopic*)notification.object;
    if (!topic) {
        return;
    }
    if ([self.fetchRequest isKindOfClass:[UMComUserTopicsRequest class]]) {
        //判断是否是我的关注界面
        if(topic.is_focused.intValue == 0)
        {
            [self deleteTopicFromTableView:topic];
        }
        else
        {
            [self insertTopicToTableView:topic];
        }
    }else{
        [self.tableView reloadData];
    }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.rowHeight = UMCom_Forum_Topic_Cell_Height;
    
    if (self.title) {
        [self setForumUITitle:self.title];
    }else{
        [self setForumUITitle:@"话题列表"];
    }
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFollowTopicNotification:) name:kUMComFollowTopicNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onClickNext
{
    if (self.completion) {
        self.completion(self);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(UMCom_Forum_Topic_Edge_Left*2 + UMCom_Forum_Topic_Icon_Width, UMCom_Forum_Topic_Cell_Height, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(UMCom_Forum_Topic_Edge_Left*2 + UMCom_Forum_Topic_Icon_Width, UMCom_Forum_Topic_Cell_Height, 0, 0)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComCommonTopicTableViewCell *cell = (UMComCommonTopicTableViewCell *)[self cellForIndexPath:indexPath];
    return cell;
    // return [self recommendTopicCellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"TopicCellID";
    UMComCommonTopicTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UMComCommonTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellSize:CGSizeMake(self.tableView.frame.size.width, self.tableView.rowHeight)];
    }
    __weak typeof(self) weakSelf = self;
    cell.index = indexPath.row;
    [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
    UMComTopic *topic = self.dataArray[indexPath.row];
    [cell reloadWithTopic:topic];
    cell.clickOnButton = ^(UMComCommonTopicTableViewCell *cell){
        [weakSelf followTopicAtCell:cell index:indexPath];
    };
    //    cell.button.imageView.image = nil;
    return cell;
}


- (void)followTopicAtCell:(UMComCommonTopicTableViewCell *)cell index:(NSIndexPath *)indexPath
{
    id object = self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComTopic *topic = object;
            [UMComPushRequest followerWithTopic:topic isFollower:![topic.is_focused boolValue] completion:^(NSError *error) {
                if (error) {
                    [UMComShowToast showFetchResultTipWithError:error];
                }
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self showTopicPostTableViewWithTopicAtIndexPath:indexPath];
}


- (void)showTopicPostTableViewWithTopicAtIndexPath:(NSIndexPath *)indexPath
{
    UMComTopic *topic = self.dataArray[indexPath.row];
    
    UMComTopicFeedViewController *topicPostListController = [[UMComTopicFeedViewController alloc] initWithTopic:topic];
    
    [self.navigationController pushViewController:topicPostListController animated:YES];
}


- (void)insertTopicToTableView:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    if ([topic isKindOfClass:[UMComTopic class]]) {
        NSMutableArray *topicList = nil;
        if (self.dataArray.count > 0) {
            topicList = [NSMutableArray arrayWithArray:self.dataArray];
            if (![topicList containsObject:topic]) {
                [topicList insertObject:topic atIndex:0];
            }
        }else{
            topicList = [NSMutableArray arrayWithObject:topic];
        }
        self.dataArray = topicList;
        [self insertCellAtRow:0 section:0];
    }
}

- (void)deleteTopicFromTableView:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if ([topic isKindOfClass:[UMComTopic class]]) {
        NSMutableArray *topicList = [NSMutableArray arrayWithArray:self.dataArray];
        [topicList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UMComTopic* item = (UMComTopic*)obj;
            if ([item.topicID isEqualToString:topic.topicID]) {
                *stop = YES;
                [topicList removeObject:topic];
                weakSelf.dataArray = topicList;
                [weakSelf deleteCellAtRow:idx section:0];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
