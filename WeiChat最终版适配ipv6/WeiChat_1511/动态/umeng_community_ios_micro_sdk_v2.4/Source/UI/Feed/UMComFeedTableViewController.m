//
//  UMComFeedsTableViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComFeedTableViewController.h"
#import "UMUtils.h"
#import "UMComLoginManager.h"
#import "UMComTools.h"
#import "UMComCoreData.h"
#import "UMComShowToast.h"
#import "UMComShareCollectionView.h"
#import "UIViewController+UMComAddition.h"
#import "UMComPushRequest.h"
#import "UMComFeedsTableViewCell.h"
#import "UMComPullRequest.h"
#import "UMComTopicFeedViewController.h"
#import "UMComFeedStyle.h"
#import "UMComEditViewController.h"
#import "UMComNavigationController.h"
#import "UMComUserCenterViewController.h"
#import "UMComNearbyFeedViewController.h"
#import "UMComClickActionDelegate.h"
#import "UMComFeedDetailViewController.h"
#import "UMComWebViewController.h"
#import "UMComSession.h"
#import "UMComFeed.h"
#import "UMComScrollViewDelegate.h"
#import "UMComFeedOperationFinishDelegate.h"
#import "UMComTopic.h"
#import "UMComTopFeedTableViewHelper.h"
#import "UMComReplyEditViewController.h"
#import "UMComComment.h"


@interface UMComFeedTableViewController ()<NSFetchedResultsControllerDelegate,UITextFieldDelegate,UMComClickActionDelegate,UMComScrollViewDelegate,UMComFeedOperationFinishDelegate, UIActionSheetDelegate> {
    
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, strong) UMComShareCollectionView *shareListView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UMComFeed *selectedFeed;

@end

@implementation UMComFeedTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoadLoacalData = YES;
        self.feedCellBgViewTopEdge = UMCom_Micro_Feed_Cell_Space;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isLoadLoacalData = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isShowEditButton && !self.editButton.superview) {
        self.editButton.hidden = NO;
        [self.navigationController.view addSubview:self.editButton];
    }else if (self.isShowEditButton){
        self.editButton.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.editButton removeFromSuperview];
    [self.shareListView dismiss];
}

- (void)viewDidLoad
{
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComFeedsTableViewCell" bundle:nil] forCellReuseIdentifier:@"FeedsTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super viewDidLoad];
    
    self.tableView.backgroundColor = UMComRGBColor(245, 246, 250);
    self.feedStyleList = [NSMutableArray array];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if (_isShowEditButton) {
        [self createEditButton];
    }
    [self setTitleViewWithTitle:self.title];
}

- (void)createEditButton
{
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, 50, 50);
    self.editButton.center = CGPointMake(self.view.frame.size.width-DeltaRight, [UIApplication sharedApplication].keyWindow.bounds.size.height-DeltaBottom);
    [self.editButton setImage:UMComImageWithImageName(@"um_edit_nomal") forState:UIControlStateNormal];
    [self.editButton setImage:UMComImageWithImageName(@"um_edit_highlight") forState:UIControlStateSelected];
    [self.editButton addTarget:self action:@selector(onClickEdit:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - deleagte 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedStyleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"FeedsTableViewCell";
    UMComFeedsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellBgViewTopEdge = self.feedCellBgViewTopEdge;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (indexPath.row < self.feedStyleList.count) {
        [cell reloadFeedWithfeedStyle:[self.feedStyleList objectAtIndex:indexPath.row] tableView:tableView cellForRowAtIndexPath:indexPath];
        if (!self.showTopMark) {
            //如果当前view设置不显示置顶就直接不显示cell的置顶标签
            cell.topImage.hidden = YES;
        }
    }
    if (!self.isDisplayDistance) {
        cell.locationDistance.hidden = YES;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 0;
    if (indexPath.row < self.feedStyleList.count) {
        UMComFeedStyle *feedStyle = self.feedStyleList[indexPath.row];
        cellHeight = feedStyle.totalHeight;
    }
    return cellHeight;
}

- (void)customScrollViewDidScroll:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    if (self.isShowEditButton){
        [self.view.superview bringSubviewToFront:self.editButton];
    }
    if (self.isShowEditButton) {
        [self setEditButtonAnimationWithScrollView:scrollView lastPosition:self.lastPosition];
    }
}

- (void)setEditButtonAnimationWithScrollView:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    if (scrollView.contentOffset.y >0 && scrollView.contentOffset.y > lastPosition.y+15) {
        if (self.editButton.center.y > [UIApplication sharedApplication].keyWindow.bounds.size.height) {
            return;
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.editButton.center = CGPointMake(self.editButton.center.x, [UIApplication sharedApplication].keyWindow.bounds.size.height+DeltaBottom);
        } completion:nil];
    }else{
        if (self.editButton.center.y <= ([UIApplication sharedApplication].keyWindow.bounds.size.height-DeltaBottom)) {
            return;
        }
        if (scrollView.contentOffset.y < lastPosition.y-15) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.editButton.center = CGPointMake(self.editButton.center.x, [UIApplication sharedApplication].keyWindow.bounds.size.height-DeltaBottom);
            } completion:nil];
        }
    }
}

#pragma mark - handdle feeds data
- (NSArray *)transFormToFeedStylesWithFeedDatas:(NSArray *)feedList
{
    NSMutableArray *feedStyles = [NSMutableArray arrayWithCapacity:1];
    @autoreleasepool {
        for (UMComFeed *feed in feedList) {
            if ([feed.status integerValue]>= FeedStatusDeleted) {
                continue;
            }
            UMComFeedStyle *feedStyle = [UMComFeedStyle feedStyleWithFeed:feed viewWidth:self.tableView.frame.size.width];
            if (feedStyle) {
                [feedStyles addObject:feedStyle];
            }
        }
    }
    return feedStyles;
}


- (void)reloadRowAtIndex:(NSIndexPath *)indexPath
{
    if ([self.tableView cellForRowAtIndexPath:indexPath]) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)insertFeedStyleToDataArrayWithFeed:(UMComFeed *)newFeed
{
    __weak typeof(self) weakSlef = self;
    if ([newFeed isKindOfClass:[UMComFeed class]] && ![self.dataArray containsObject:newFeed]) {
        self.noDataTipLabel.hidden = YES;
        if (self.dataArray.count == 0) {
            self.dataArray = @[newFeed];
            [self.feedStyleList addObject:[UMComFeedStyle feedStyleWithFeed:newFeed viewWidth:self.view.frame.size.width]];
        }else{
            __block NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
            [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UMComFeed *feed = (UMComFeed *)obj;
                if ([feed.is_top boolValue] == NO) {
                    [tempArray insertObject:newFeed atIndex:idx];
                    weakSlef.dataArray = tempArray;
                    UMComFeedStyle *feedStyle = [UMComFeedStyle feedStyleWithFeed:newFeed viewWidth:weakSlef.tableView.frame.size.width];
                    [self.feedStyleList insertObject:feedStyle atIndex:idx];
                    *stop = YES;
                    [weakSlef insertCellAtRow:idx section:0];
                }
            }];
        }
        }

    [self.tableView reloadData];
}

- (void)deleteFeedFromList:(UMComFeed *)feed
{
    __weak typeof(self) weakSelf = self;
    [self.feedStyleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UMComFeedStyle *feedStyle = obj;
        if ([feedStyle.feed.feedID isEqualToString:feed.feedID]) {
            *stop = YES;
            [weakSelf.feedStyleList removeObject:feedStyle];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - edit button
-(void)onClickEdit:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComEditViewController *editViewController = [[UMComEditViewController alloc] init];
            editViewController.feedOperationFinishDelegate = weakSelf;
            UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
            [self presentViewController:editNaviController animated:YES completion:nil];
        }
    }];
    
}


#pragma mark -  UMComClickActionDelegate


- (void)customObj:(id)obj clickOnUser:(UMComUser *)user
{
    UMComUserCenterViewController *userCenterVc = [[UMComUserCenterViewController alloc]initWithUser:user];
    [self.navigationController pushViewController:userCenterVc animated:YES];
}

- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    if (!topic) {
        return;
    }
    if ([self.fetchRequest isKindOfClass:[UMComTopicFeedsRequest class]] && [topic.topicID isEqualToString:self.fetchRequest.topicId]) {
        return;
    }
    UMComTopicFeedViewController *oneFeedViewController = [[UMComTopicFeedViewController alloc] initWithTopic:topic];
    [self.navigationController  pushViewController:oneFeedViewController animated:YES];
}

- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    UMComFeedDetailViewController * feedDetailViewController = [[UMComFeedDetailViewController alloc] initWithFeed:feed showFeedDetailShowType:UMComShowFromClickFeedText];
    feedDetailViewController.feedOperationFinishDelegate = self;
    [self.navigationController pushViewController:feedDetailViewController animated:YES];
}

- (void)customObj:(id)obj clickOnOriginFeedText:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    UMComFeedDetailViewController * feedDetailViewController = [[UMComFeedDetailViewController alloc] initWithFeed:feed showFeedDetailShowType:UMComShowFromClickFeedText];
    feedDetailViewController.feedOperationFinishDelegate = self;
    [self.navigationController pushViewController:feedDetailViewController animated:YES];
}


- (void)customObj:(id)obj clickOnURL:(NSString *)url
{
    UMComWebViewController * webViewController = [[UMComWebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)customObj:(id)obj clickOnLocationText:(UMComFeed *)feed
{
    if (!feed || [feed.status intValue] >= FeedStatusDeleted) {
        return;
    }
    NSDictionary *locationDic = feed.location;
    if (!locationDic) {
        locationDic = feed.origin_feed.location;
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[[[locationDic valueForKey:@"geo_point"] objectAtIndex:1] floatValue] longitude:[[[locationDic valueForKey:@"geo_point"] objectAtIndex:0] floatValue]];
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComNearbyFeedViewController *nearbyFeedViewController = [[UMComNearbyFeedViewController alloc] initWithLocation:location title:[locationDic valueForKey:@"name"]];
            [weakSelf.navigationController pushViewController:nearbyFeedViewController animated:YES];
        }
    }];
}

- (void)customObj:(id)obj clickOnLikeFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    BOOL isLike = ![feed.liked boolValue];
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [UMComPushRequest likeWithFeed:feed isLike:isLike completion:^(id responseObject, NSError *error) {
                if (error) {
                    [UMComShowToast showFetchResultTipWithError:error];
                }
                [weakSelf reloadRowAtIndex:[weakSelf.tableView indexPathForCell:obj]];
            }];
        }
    }];
}

- (void)customObj:(id)obj clickOnForward:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComEditViewController *editViewController = [[UMComEditViewController alloc] initWithForwardFeed:feed];
            editViewController.feedOperationFinishDelegate = weakSelf;
            UMComNavigationController *editNaviController = [[UMComNavigationController alloc] initWithRootViewController:editViewController];
            [self presentViewController:editNaviController animated:YES completion:nil];
        }
    }];
}

- (void)customObj:(id)obj clickOnComment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [weakSelf showCommentEditViewWithComment:comment feed:feed];
        }
    }];
}

- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *viewcontroller))block
{
    if (block) {
        block(self);
    }
}


- (void)customObj:(id)obj clikeOnMoreButton:(id)param
{
    UMComFeedsTableViewCell *cell = obj;
    [self showActionSheetWithFeed:cell.feed];
}


#pragma mark - show ActionSheet
- (void)showActionSheetWithFeed:(UMComFeed *)feed
{
    self.selectedFeed =feed;
    NSMutableArray *_menuList = [NSMutableArray array];
    NSString *destructiveButtonString = nil;
    if ([self checkAuthDeletePostWithFeed:feed]) {
        [_menuList addObject:@"删除"];
    }
    if ([feed.has_collected boolValue]) {
        [_menuList addObject:@"取消收藏"];
    }else{
        [_menuList addObject:@"收藏"];
    }
    [_menuList addObject:@"分享"];
    
    if ([self checkNeedReportCreatorWithFeed:feed]) {
        [_menuList addObject:@"举报用户"];
    }
    
    if ([self checkNeedReportWithFeed:feed]) {
        [_menuList addObject:@"举报内容"];
    }
    [_menuList addObject:@"拷贝"];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:destructiveButtonString
                                              otherButtonTitles:nil];
    for (int i = 0; i < _menuList.count; ++i) {
        [sheet addButtonWithTitle:_menuList[i]];
    }
    sheet.tag = 10002;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}



#pragma mark -  UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (actionSheet.tag == 10002) {
        UMComFeed *feed = self.selectedFeed;
        if ([title isEqualToString:@"删除"]) {
            [self deleteFeed:feed];
        }else if ([title isEqualToString:@"收藏"] || [title isEqualToString:@"取消收藏"]){
            [self collectFeed:feed];
        }else if ([title isEqualToString:@"分享"]){
            [self shareFeed:feed];
        }else if ([title isEqualToString:@"举报用户"]){
            [self spamUser:feed];
        }else if ([title isEqualToString:@"举报内容"]){
            [self spamFeed:feed];
        }else if ([title isEqualToString:@"拷贝"]){
            [self copyFeed:feed];
        }
    }else{
        [self showActionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    }
}

- (void)showActionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{

}

- (BOOL)checkAuthDeletePostWithFeed:(UMComFeed *)feed
{
    return ([feed.permission integerValue] >= 100);
}

/**
 *  判断当前用户是否有举报功能针对feed
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).
 *        如果用户是全局管理员，也不需要出现举报按钮.(全局管理员可以直接删除，举报功能多余)
 *        如果用户是这个话题的管理员，也不需要举报按钮。
 */
- (BOOL)checkNeedReportWithFeed:(UMComFeed *)feed
{
    //针对feed
    //如果是本人发布的就不需要举报
    NSString* temp_LogUid = [UMComSession sharedInstance].loginUser.uid;
    NSString* temp_CreatorUid = feed.creator.uid;
    if (temp_LogUid && temp_CreatorUid && [temp_LogUid isEqualToString:temp_CreatorUid]) {
        return NO;
    }
    
    //如果当前是全局管理员
    NSNumber* typeNumber = [UMComSession sharedInstance].loginUser.atype;
    if(typeNumber && typeNumber.shortValue == 1)
    {
        return NO;
    }
    //此处简单的判断当前帖子的permission为100以上就认为有删除权限，不需要举报
    int permission = 0;
    permission = feed.permission.intValue;
    if (permission >= 100) {
        return NO;
    }
    
    return YES;
}

/**
 *  判断是否可以举报当前feed创建者
 *
 *  @return YES 表示需要举报 NO表示不需要举报
 *  @note 如果用户feed是自己发的，就不需要出现举报按钮(自己举报自己没有意义).其他情况都可以举报(包括全局管理员和话题管理员)
 */
- (BOOL)checkNeedReportCreatorWithFeed:(UMComFeed *)feed
{
    //针对feed
    //如果是本人发布的就不需要举报
    NSString* temp_LogUid = [UMComSession sharedInstance].loginUser.uid;
    NSString* temp_CreatorUid = feed.creator.uid;
    if (temp_LogUid && temp_CreatorUid && [temp_LogUid isEqualToString:temp_CreatorUid]) {
        return NO;
    }
    return YES;
}


#pragma mark - feed operation

- (void)deleteFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    if (feed.isDeleted) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUMComFeedDeletedFinishNotification object:feed];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [UMComPushRequest deleteWithFeed:feed completion:^(NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                if (error){
                    [UMComShowToast showFetchResultTipWithError:error];
                }
                if ([feed.status integerValue] >= 2) {
                    [self deleteFeedFromList:feed];
                }
            }];
        }
    }];
}

- (void)shareFeed:(UMComFeed *)feed
{
    if (!feed) {
        return;
    }
    self.shareListView = [[UMComShareCollectionView alloc]initWithFrame:CGRectMake(0, self.view.window.frame.size.height, self.view.window.frame.size.width,120)];
    self.shareListView.feed = feed;
    self.shareListView.shareViewController = self;
    [self.shareListView shareViewShow];
}

- (void)collectFeed:(UMComFeed *)feed
{
    __weak typeof(self) weakSelf = self;
    BOOL isFavourite = ![[feed has_collected] boolValue];
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [UMComPushRequest favouriteFeedWithFeed:feed
                                        isFavourite:isFavourite
                                         completion:^(NSError *error) {
                                             [UMComShowToast favouriteFeedFail:error isFavourite:isFavourite];
                                             [weakSelf.tableView reloadData];
                                         }];
        }
    }];
}

- (void)spamUser:(UMComFeed *)feed
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [UMComPushRequest spamWithUser:feed.creator completion:^(NSError *error) {
                [UMComShowToast spamUser:error];
            }];
        }
    }];
}

- (void)spamFeed:(UMComFeed *)feed
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
    if (!error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [UMComPushRequest spamWithFeed:feed completion:^(NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [UMComShowToast spamSuccess:error];
        }];
    }
    }];
}


- (void)copyFeed:(UMComFeed *)feed
{
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:1];
    NSMutableString *string = [[NSMutableString alloc]init];
    if (feed.text) {
        [strings addObject:feed.text];
        [string appendString:feed.text];
    }
    if (feed.origin_feed.text) {
        [strings addObject:feed.origin_feed.text];
        [string appendString:feed.origin_feed.text];
    }
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.strings = strings;
    pboard.string = string;
}


#pragma mark - rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.shareListView dismiss];
}


#pragma mark - UMComFeedOperationFinishDelegate
- (void)reloadDataWhenFeedOperationFinish:(UMComFeed *)feed
{
    [self.tableView reloadData];
}

- (void)createFeedSucceed:(UMComFeed *)feed
{
    if ([self.fetchRequest isKindOfClass:[UMComAllFeedsRequest class]] || ([self.fetchRequest isKindOfClass:[UMComUserFeedsRequest class]] && [self.fetchRequest.fuid isEqualToString:[UMComSession sharedInstance].uid]) || [self.fetchRequest isKindOfClass:[UMComTopicFeedsRequest class]]) {
        if ([self.fetchRequest isKindOfClass:[UMComTopicFeedsRequest class]]) {
            UMComTopicFeedsRequest *topicFeedsRequest = (UMComTopicFeedsRequest *)self.fetchRequest;
            if (topicFeedsRequest.orderType == UMComFeedSortTypeDefault) {
             [self insertFeedStyleToDataArrayWithFeed:feed];
            }
        }else{
            [self insertFeedStyleToDataArrayWithFeed:feed];
        }
    }
}

#pragma mark - 
- (void)showCommentEditViewWithComment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            __weak typeof(self) weakself = self;
            UMComReplyEditViewController* tempReplyController =  [[UMComReplyEditViewController alloc] init];
            
            tempReplyController.commentcreator =  comment.creator.name;
            tempReplyController.commitBlock = ^(NSString *content, NSArray *imageList) {
                [weakself replyContent:content toPost:feed fromComment:comment imageList:imageList];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            };
            tempReplyController.cancelBlock = ^{                
                [weakself dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:tempReplyController animated:YES completion:nil];
        }
    }];
    
}

- (void)replyContent:(NSString *)content toPost:(UMComFeed *)feed fromComment:(UMComComment *)comment imageList:(NSArray *)imageList
{
    if ((content.length == 0 && imageList.count == 0) || !feed) {
        return;
    }
    [UMComPushRequest commentFeedWithFeed:feed
                           commentContent:content
                             replyComment:comment
                     commentCustomContent:nil
                                   images:imageList
                               completion:^(id responseObject, NSError *error) {
                                   if (error) {
                                       [UMComShowToast showFetchResultTipWithError:error];
                                   } else {
                                       [UMComShowToast fetchFailWithNoticeMessage:@"评论成功"];
                                       
                                   }
                                   [self.tableView reloadData];
                                   if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0")) {
                                       [self setNeedsStatusBarAppearanceUpdate];
                                   }
                               }];
}


- (void)deleteFeedFinish:(UMComFeed *)feed
{
    [self deleteFeed:feed];
}

#pragma mark - overide method
- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (self.topFeedTableViewHelper) {
        [self.topFeedTableViewHelper handleServerDataWithData:data error:error dataHandleFinish:^{
            if (finishHandler) {
                finishHandler();
            }
        }];
        
        //赋值给tableview的模型
        self.dataArray = self.topFeedTableViewHelper.tablviewDataArray;
        [self.feedStyleList removeAllObjects];
        [self.feedStyleList addObjectsFromArray:[self transFormToFeedStylesWithFeedDatas:self.dataArray]];
        
        //是否提示用户没有数据
        if(self.feedStyleList.count > 0)
        {
            self.noDataTipLabel.hidden = YES;
        }
        else
        {
            self.noDataTipLabel.hidden = NO;
        }
        
        if (self.topFeedTableViewHelper.topFeedState == EUMTopFeedStateFinishServerData ||
            self.topFeedTableViewHelper.topFeedState == EUMTopFeedStateServerDataError  ||
            self.topFeedTableViewHelper.topFeedState == EUMTopFeedStateNone) {
    
        }
    }
    else
    {
        if (!error && [data isKindOfClass:[NSArray class]]) {
            [self.feedStyleList removeAllObjects];
            self.dataArray = data;
            [self.feedStyleList addObjectsFromArray:[self transFormToFeedStylesWithFeedDatas:data]];
        }else {
            [UMComShowToast showFetchResultTipWithError:error];
        }
    }
    if (finishHandler) {
//        NSLog(@"handleServerDataWithData....reloadTableview");
        finishHandler();
    }
//    [self.tableView reloadData];
}

- (void)refreshNewDataFromServer:(LoadSeverDataCompletionHandler)complection
{
    if (self.topFeedTableViewHelper) {
         __weak typeof(self) weakSelf = self;
        [self.topFeedTableViewHelper refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
            [UMComShowToast showFetchResultTipWithError:error];
            if (weakSelf.isLoadFinish) {
                weakSelf.dataArray = weakSelf.topFeedTableViewHelper.tablviewDataArray;
                [weakSelf.feedStyleList removeAllObjects];
                [weakSelf.feedStyleList addObjectsFromArray:[weakSelf transFormToFeedStylesWithFeedDatas:weakSelf.dataArray]];
                
                //是否提示用户没有数据
                if(weakSelf.feedStyleList.count > 0)
                {
                    weakSelf.noDataTipLabel.hidden = YES;
                }
                else
                {
                    weakSelf.noDataTipLabel.hidden = NO;
                }
                [weakSelf.tableView reloadData];
                [super refreshNewDataFromServer:complection];
            }
        }];
        
    }
    else
    {
         [super refreshNewDataFromServer:complection];
    }
    
   
}

- (void)handleLoadMoreDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error) {
        if (data.count > 0) {
            NSMutableArray *feedDatas = [NSMutableArray arrayWithCapacity:20];
            //此处去重--bengin
            if (self.topFeedTableViewHelper) {
                
               NSArray* realArray =  [UMComTopFeedTableViewHelper filterTopfeedFromCommonFeedArray:data];
                if (realArray) {
                    [feedDatas addObjectsFromArray:realArray];
                }
            }
            else{
                [feedDatas addObjectsFromArray:data];
            }
            //此处去重--end
            self.dataArray = feedDatas;
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.feedStyleList];
            NSArray *array = [self transFormToFeedStylesWithFeedDatas:self.dataArray];
            if (array.count > 0) {
                [tempArray addObjectsFromArray:array];
            }
            self.feedStyleList = tempArray;
            
        }else {
            [UMComShowToast showNoMore];
        }
        
    } else {
        [UMComShowToast showFetchResultTipWithError:error];
    }
    if (finishHandler) {
        finishHandler();
    }
}


/**
 *  重新加载tableviewde数据(与下面函数handleCoreDataDataWithData一起使用，目前暂时不用)
 *
 *  @param data          tableview的数据模型
 *  @param finishHandler 成功后的调用的block
 */
//-(void) reloadTableviewData:(NSArray *)data dataHandleFinish:(DataHandleFinish)finishHandler
//{
//    if ([data isKindOfClass:[NSArray class]] &&  data.count > 0) {
//        self.dataArray = data;
//        NSMutableArray *nomalArray = [NSMutableArray array];
//        NSMutableArray *topArray = [NSMutableArray array];
//        for (UMComFeed *feed in data) {
//            if ([feed.is_top boolValue] == YES) {
//                [topArray addObject:feed];
//            }else{
//                [nomalArray addObject:feed];
//            }
//        }
//        [topArray addObjectsFromArray:nomalArray];
//        [self.feedStyleList addObjectsFromArray:[self transFormToFeedStylesWithFeedDatas:topArray]];
//    }
//    if (finishHandler) {
//        finishHandler();
//    }
//}


/**
 *  本地回调的时候，获得置顶的feed插入到tableview数据的上方(此函数目前暂时不用)
 *
 *  @param data          本地数据
 *  @param error         @see NSError
 *  @param finishHandler 获得数据后的block动作
 */
//- (void)handleCoreDataDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
//{
//    if (self.topFeedTableViewHelper) {
//        
//        //如果需要置顶数据，就请求并加入tableview的顶部
//        NSArray* result = [self.topFeedTableViewHelper FetchTopFeedFromCoreData];
//        if (result && result.count > 0) {
//            NSMutableArray* tableviewData = [NSMutableArray arrayWithArray:result];
//
//            if (!error && [data isKindOfClass:[NSArray class]]) {
//                [tableviewData addObjectsFromArray:data];
//            }
//            
//            [self reloadTableviewData:tableviewData dataHandleFinish:finishHandler];
//            
//        }
//        else
//        {
//            [self reloadTableviewData:data dataHandleFinish:finishHandler];
//        }
//        
//    }
//    else{
//        [self reloadTableviewData:data dataHandleFinish:finishHandler];
//    }
//
//}

@end
